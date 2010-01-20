#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#include <colors>
#include <gungame_const>
#include <gungame>
#include <gungame_config>
#include <langutils>
#undef REQUIRE_PLUGIN
#include <gungame_stats>

/**
 * Enable debug code
 */
//#define DEBUG

#include "gungame/gungame.h"
#include "gungame/menu.h"
#include "gungame/config.h"
#include "gungame/keyvalue.h"
#include "gungame/event.h"
#include "gungame/hacks.h"
#include "gungame/offset.h"
#include "gungame/util.h"

#if defined DEBUG
#include "gungame/debug.h"
#include "gungame/debug.sp"
#endif

#include "gungame/util.sp"
#include "gungame/natives.sp"
#include "gungame/offset.sp"
#include "gungame/hacks.sp"
#include "gungame/config.sp"
#include "gungame/keyvalue.sp"
#include "gungame/event.sp"
#include "gungame/menu.sp"
#include "gungame/commands.sp"

public Plugin:myinfo =
{
    name = "GunGame:SM",
    author = GUNGAME_AUTHOR,
    description = "GunGame:SM for SourceMod",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public bool:AskPluginLoad(Handle:myself, bool:late, String:error[], err_max)
{
    RegPluginLibrary("gungame");
    OnCreateNatives();
    return true;
}

public OnLibraryAdded(const String:name[])
{
    if ( StrEqual(name, "gungame_st") )
    {
        StatsEnabled = true;
    }
}

public OnLibraryRemoved(const String:name[])
{
    if ( StrEqual(name, "gungame_st") )
    {
        StatsEnabled = false;
    }
}

public OnPluginStart()
{
    StatsEnabled = LibraryExists("gungame_st");
    LoadTranslations("gungame");
    PlayerLevelsBeforeDisconnect = CreateTrie();
    
    // ConVar
    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    // VGUIMenu = GetUserMessageId("VGUIMenu");
    mp_friendlyfire = FindConVar("mp_friendlyfire");
    mp_restartgame = FindConVar("mp_restartgame");
    
    new Handle:Version = CreateConVar("sm_gungamesm_version", GUNGAME_VERSION,    "GunGame Version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

    /* Just to make sure they it updates the convar version if they just had the plugin reload on map change */
    SetConVarString(Version, GUNGAME_VERSION);

    gungame_enabled = CreateConVar("gungame_enabled", "1", "Display if GunGame is enabled or disabled", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

    /* Dynamic Forwards */
    FwdDeath = CreateGlobalForward("GG_OnClientDeath", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
    FwdLevelChange = CreateGlobalForward("GG_OnClientLevelChange", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
    FwdPoint = CreateGlobalForward("GG_OnClientPointChange", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
    FwdLeader = CreateGlobalForward("GG_OnLeaderChange", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
    FwdWinner = CreateGlobalForward("GG_OnWinner", ET_Ignore, Param_Cell, Param_String);
    FwdTripleLevel = CreateGlobalForward("GG_OnTripleLevel", ET_Ignore, Param_Cell);
    FwdWarmupEnd = CreateGlobalForward("GG_OnWarmupEnd", ET_Ignore);
    FwdVoteStart = CreateGlobalForward("GG_OnStartMapVote", ET_Ignore);
    FwdStart = CreateGlobalForward("GG_OnStartup", ET_Ignore, Param_Cell);
    FwdShutdown = CreateGlobalForward("GG_OnShutdown", ET_Ignore, Param_Cell);

    OnKeyValueStart();
    OnOffsetStart();
    OnCreateCommand();
    OnHackStart();

    #if defined DEBUG
    OnCreateDebug();
    #endif
}

public OnClientAuthorized(client, const String:auth[])
{
    if ( IsFakeClient(client) || !RestoreLevelOnReconnect )
    {
        return;
    }

    new level = 0;
    if ( GetTrieValue(PlayerLevelsBeforeDisconnect, auth, level) )
    {
        if ( PlayerLevel[client] < level )
        {
            PlayerLevel[client] = level;
        }
    }
    
    UTIL_RecalculateLeader(client, 0, level);

    if ( auth[0] == 'B' )
    {
        if ( HandicapMode )
        {
            GG_GiveHandicapLevel(client, HandicapMode);
        }
    } else {
        if ( HandicapMode && ( Top10Handicap 
            || !StatsEnabled || (GG_GetPlayerPlaceInTop10(auth) == -1) /* HINT: gungame_stats */
        ) )
        {
            GG_GiveHandicapLevel(client, HandicapMode);
        }
    }
    
    UTIL_UpdatePlayerScoreLevel(client);
}

public OnPluginEnd()
{
    SetConVarInt(gungame_enabled, 0);
}

public OnMapEnd()
{
    /* Kill timer on map change if was in warmup round. */
    if(WarmupTimer != INVALID_HANDLE)
    {
        KillTimer(WarmupTimer);
        WarmupTimer = INVALID_HANDLE;
    }

    /* Clear out data */
    WarmupInitialized = false;
    WarmupCounter = NULL;
    MapStatus = NULL;
    HostageEntInfo = NULL;
    IsVotingCalled = false;
    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    // IsIntermissionCalled = false;
    GameWinner = NULL;
    TotalLevel = NULL;
    CurrentLeader = NULL;
    ClearTrie(PlayerLevelsBeforeDisconnect);

    for(new Sounds:i = Welcome; i < MaxSounds; i++)
    {
        EventSounds[i][0] = '\0';
    }

    if(IsObjectiveHooked)
    {
        if(MapStatus & OBJECTIVE_BOMB)
        {
            IsObjectiveHooked = false;
            UnhookEvent("bomb_planted", _BombState);
            UnhookEvent("bomb_exploded", _BombState);
            UnhookEvent("bomb_defused", _BombState);
            UnhookEvent("bomb_pickup", _BombPickup);
        }

        if(MapStatus & OBJECTIVE_HOSTAGE)
        {
            IsObjectiveHooked = false;
            UnhookEvent("hostage_killed", _HostageKilled);
        }
    }
}

public OnClientDisconnect(client)
{
    /* Clear current leader if player is leader */
    if ( CurrentLeader == client )
    {
        UTIL_RecalculateLeader(client, PlayerLevel[client], 0);
        if ( CurrentLeader == client )
        {
            CurrentLeader = 0;
        }
    }

    if ( AutoFriendlyFire && (PlayerState[client] & GRENADE_LEVEL) )
    {
        PlayerState[client] &= ~GRENADE_LEVEL;

        if ( --PlayerOnGrenade < 1 )
        {
            UTIL_ChangeFriendlyFire(false);
        }
    }

    /* This does not take into account for steals. */
    TotalLevel -= PlayerLevel[client];

    if ( TotalLevel < 0 )
    {
        TotalLevel = NULL;
    }

    if ( !IsFakeClient(client) )
    {
        decl String:steamid[64];
        GetClientAuthString(client, steamid, sizeof(steamid));
        SetTrieValue(PlayerLevelsBeforeDisconnect, steamid, PlayerLevel[client]);
    }
    
    PlayerLevel[client] = 0;
    CurrentKillsPerWeap[client] = NULL;
    CurrentLevelPerRound[client] = 0;
    CurrentLevelPerRoundTriple[client] = 0;
    PlayerState[client] = NULL;
    
    if ( IsClientInGame(client) && IsPlayerAlive(client) )
    {
        UTIL_RemoveClientDroppedWeapons(client, true);
        UTIL_StopTripleEffects(client);
    }
}

public GG_OnStartup(bool:Command)
{
    if ( !IsActive )
    {
        IsActive = true;

        OnEventStart();
    }

    if ( !IsActive )
    {
        return;
    }

    UTIL_RemoveBuyZones();
        
    if(WarmupStartup & MAP_START && !WarmupInitialized && WarmupEnabled)
    {
        StartWarmupRound();
    }

    UTIL_FindMapObjective();

    if(!IsObjectiveHooked)
    {
        if(MapStatus & OBJECTIVE_BOMB)
        {
            IsObjectiveHooked = true;
            HookEvent("bomb_planted", _BombState);
            HookEvent("bomb_exploded", _BombState);
            HookEvent("bomb_defused", _BombState);
            HookEvent("bomb_pickup", _BombPickup);
        }
    
        if(MapStatus & OBJECTIVE_HOSTAGE)
        {
            IsObjectiveHooked = true;
            HookEvent("hostage_killed", _HostageKilled);
        }
    }

    decl String:Hi[PLATFORM_MAX_PATH];
    for(new Sounds:i = Welcome; i < MaxSounds; i++)
    {
        if(EventSounds[i][0])
        {
            PrecacheSound(EventSounds[i]);
            Format(Hi, sizeof(Hi), "sound/%s", EventSounds[i]);
            AddFileToDownloadsTable(Hi);
        }
    }
}

public GG_OnShutdown(bool:Command)
{
    if ( !IsActive )
    {
        reuturn;
    }

    IsActive = false;
    InternalIsActive = false;
    WarmupInitialized = false;
    WarmupCounter = NULL;
    IsVotingCalled = false;
    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    // IsIntermissionCalled = false;
    GameWinner = NULL;
    TotalLevel = NULL;
    CurrentLeader = NULL;
    ClearTrie(PlayerLevelsBeforeDisconnect);
        
    OnEventShutdown();

    if ( Command )
    {
        new maxslots = GetMaxClients( );

        for(new i = 1; i <= maxslots; i++)
        {
            if(IsClientInGame(i))
            {
                OnClientDisconnect(i);
            }
        }

        if(WarmupTimer != INVALID_HANDLE)
        {
            KillTimer(WarmupTimer);
            WarmupTimer = INVALID_HANDLE;
        }
    }

    if ( IsObjectiveHooked )
    {
        if ( MapStatus & OBJECTIVE_BOMB )
        {
            IsObjectiveHooked = false;
            UnhookEvent("bomb_planted", _BombState);
            UnhookEvent("bomb_exploded", _BombState);
            UnhookEvent("bomb_defused", _BombState);
            UnhookEvent("bomb_pickup", _BombPickup);
        }

        if(MapStatus & OBJECTIVE_HOSTAGE)
        {
            IsObjectiveHooked = false;
            UnhookEvent("hostage_killed", _HostageKilled);
        }
    }
}

/**
 * Print messages to chat about leaders.
 *
 * @param int client
 * @param int oldLevel
 * @param int newLevel
 * @param String name
 * @return void
 */
PrintLeaderToChat(client, oldLevel, newLevel, const String:name[])
{
    if ( !CurrentLeader || newLevel <= oldLevel )
    {
        return;
    }
    // newLevel > oldLevel
    if ( CurrentLeader == client )
    {
        // say leading on level X
        if ( g_Cfg_ShowLeaderWeapon ) {
            CPrintToChatAllEx(client, "%t", "Is leading on level weapon", name, newLevel + 1, WeaponOrderName[newLevel]);
        } else {
            CPrintToChatAllEx(client, "%t", "Is leading on level", name, newLevel + 1);
        }
        return;
    }
    // CurrentLeader != client
    if ( newLevel < PlayerLevel[CurrentLeader] )
    {
        // say how much to the lead
        decl String:subtext[64];
        FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), PlayerLevel[CurrentLeader]-newLevel, "levels");
        CPrintToChat(client, "%t", "You are levels behind leader", subtext);
        return;
    }
    // new level == leader level
    // say tied to the lead on level X
    CPrintToChatAllEx(client, "%t", "Is tied with the leader on level", name, newLevel + 1);
}

StartWarmupRound()
{
    WarmupInitialized = true;
    PrintToServer("[GunGame] Warmup round has started.");
    decl String:subtext[64];
    new maxClients = GetMaxClients();
    for ( new i = 1; i <= maxClients; i++ )
    {
        if ( IsClientInGame(i) )
        {
            SetGlobalTransTarget(i);
            FormatLanguageNumberTextEx(i, subtext, sizeof(subtext), Warmup_TimeLength - WarmupCounter, "seconds left");
            PrintHintText(i, "%t", "Warmup round seconds left", subtext);
        }
    }

    /* Start Warmup round */
    WarmupTimer = CreateTimer(1.0, EndOfWarmup, _, TIMER_REPEAT);
}

/* End of Warmup */
public Action:EndOfWarmup(Handle:timer)
{
    if ( ++WarmupCounter <= Warmup_TimeLength )
    {
        if ( Warmup_TimeLength - WarmupCounter < 5)
        {
            EmitSoundToAll(EventSounds[WarmupTimerSound]);
        }
        decl String:subtext[64];
        for ( new i = 1; i <= MaxClients; i++ )
        {
            if ( IsClientInGame(i) )
            {
                SetGlobalTransTarget(i);
                FormatLanguageNumberTextEx(i, subtext, sizeof(subtext), Warmup_TimeLength - WarmupCounter, "seconds left");
                PrintHintText(i, "%t", "Warmup round seconds left", subtext);
            }
        }
        return Plugin_Continue;
    }

    WarmupTimer = INVALID_HANDLE;
    //WarmupEnabled = false; // Delayed warmup ending
    DisableWarmupOnRoundEnd = true;

    /* Restart Game */
    SetConVarInt(mp_restartgame, 1);

    CPrintToChatAll("%t", "Warmup round has ended");

    if ( WarmupReset )
    {
        new maxslots = GetMaxClients( );
        TotalLevel = NULL;

        for ( new i = 1; i <= maxslots; i++ )
        {
            PlayerLevel[i] = 0;
            UTIL_UpdatePlayerScoreLevel(i);
        }
    }
    
    Call_StartForward(FwdWarmupEnd);
    Call_Finish();
        
    return Plugin_Stop;
}

public OnMapStart()
{
    Tcount = 0;
    CTcount = 0;
    for ( new i = 1; i <= MaxClients; i++ )
    {
        if ( IsClientInGame(i) )
        {
            switch ( GetClientTeam(i) ) {
                case TEAM_T: {
                    Tcount++;
                } 
                case TEAM_CT: {
                    CTcount++;
                }
            }
        }
    }
}

/**
 * KillCam event message should probably should block in DeathMatch Style.
 * BarTime probably used to show how long left till respawn.
 */

/*
old todo:
Wait for CBasePlayer?::GetWeaponSlot()
Check byte size for SendProp Offset
*/

/* I wonder sending game_end or round_end with nextlevel cvar will force map to change? */
