/**
 * ===============================================================
 * GunGame:SM, Copyright (C) 2007
 * All rights reserved.
 * ===============================================================
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * To view the latest information, see: http://www.hat-city.net/
 * Author(s): teame06
 *
 * This was also brought to you by faluco and the hat (http://www.hat-city.net/haha.jpg)
 *
 * Credit:
 * Original Idea and concepts of Gun Game was made by cagemonkey @ http://www.cagemonkey.org
 *
 * Especially would like to thank BAILOPAN for everything.
 * Also faluco for listening to my yapping.
 * Custom Mutliple Kills Per Level setting was an idea from XxAvalanchexX GunGame 1.6.
 * To the SourceMod Dev Team for making a nicely design system for this plugin to be recreated it.
 * FlyingMongoose for slaping my ideas away and now we have now left ... Geez.
 * I would also like to thank sawce with ^^.
 * Another person who I would like to thank is OneEyed.
 */

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

/**
 * So the plugin won't search for the library gungame
 * but since I keep all the const in the same file too.
 * Since it requires the const.
 */
#undef REQUIRE_PLUGIN
#include <gungame>
#include <colors>

/**
 * Enable debug code
 * This is only meant for the author.
 */
//#define DEBUG

#include "gungame/gungame.h"
#include "gungame/menu.h"
#include "gungame/config.h"
#include "gungame/keyvalue.h"
#include "gungame/event.h"
#include "gungame/hacks.h"
#include "gungame/offset.h"

#if defined DEBUG
#include "gungame/debug.h"
#include "gungame/debug.sp"
#endif

#include "gungame/natives.sp"
#include "gungame/offset.sp"
#include "gungame/hacks.sp"
#include "gungame/menu.sp"
#include "gungame/config.sp"
#include "gungame/keyvalue.sp"
#include "gungame/util.sp"
#include "gungame/event.sp"
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

public OnPluginStart()
{
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
    FwdLevelChange = CreateGlobalForward("GG_OnClientLevelChange", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
    FwdPoint = CreateGlobalForward("GG_OnClientPointChange", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
    FwdLeader = CreateGlobalForward("GG_OnLeaderChange", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
    FwdWinner = CreateGlobalForward("GG_OnWinner", ET_Ignore, Param_Cell, Param_String);
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

    decl String:steamid[64];
    GetClientAuthString(client, steamid, sizeof(steamid));
    new level = 0;
    if ( GetTrieValue(PlayerLevelsBeforeDisconnect, steamid, level) )
    {
        if ( PlayerLevel[client] < level )
        {
            PlayerLevel[client] = level;
        }
    }
    
    UTIL_RecalculateLeader(client, 0, level);
    if ( CurrentLeader && (level == PlayerLevel[CurrentLeader]) ) 
    {
        decl String:name[MAX_NAME_SIZE];
        GetClientName(client, name, sizeof(name));
        PrintLeaderToChat(client, 0, level, name);
    }
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

    if(CommandPanel != INVALID_HANDLE)
    {
        CloseHandle(CommandPanel);
        CommandPanel = INVALID_HANDLE;
    }

    if(RulesMenu != INVALID_HANDLE)
    {
        CloseHandle(RulesMenu);
        RulesMenu = INVALID_HANDLE;
    }

    if(JoinMsgPanel != INVALID_HANDLE)
    {
        CloseHandle(JoinMsgPanel);
        JoinMsgPanel = INVALID_HANDLE;
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

StartWarmupRound()
{
    WarmupInitialized = true;
    PrintToServer("[GunGame] Warmup round has started.");
    PrintHintTextToAll("%t", "Warmup round seconds left", Warmup_TimeLength - WarmupCounter);

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
        PrintHintTextToAll("%t", "Warmup round seconds left", Warmup_TimeLength - WarmupCounter);
        return Plugin_Continue;
    }

    WarmupTimer = INVALID_HANDLE;
    //WarmupEnabled = false; // Delayed warmup ending
    DisableWarmupOnRoundEnd = true;

    /* Restart Game */
    SetConVarInt(mp_restartgame, 1);

    CPrintToChatAll("%t", "Warmup round has ended");

    if(WarmupReset)
    {
        new maxslots = GetMaxClients( );
        TotalLevel = NULL;

        for(new i = 1; i <= maxslots; i++)
        {
            PlayerLevel[i] = 0;
        }
    }
    
    Call_StartForward(FwdWarmupEnd);
    Call_Finish();
        
    return Plugin_Stop;
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

    if(TotalLevel < 0)
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
    }
}

public GG_OnStartup(bool:Command)
{
    if(!IsActive)
    {
        IsActive = true;

        OnEventStart();
    }

    if(IsActive)
    {
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
}

public GG_OnShutdown(bool:Command)
{
    if(IsActive)
    {
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

        if(Command)
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

        if(IsObjectiveHooked)
        {
            if(MapStatus & OBJECTIVE_BOMB)
            {
                IsObjectiveHooked = false;
                UnhookEvent("bomb_planted", _BombState);
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
}

/**
 * Return current leader client.
 *
 * Return 0 if no leaders found.
 *
 * @param bool DisallowBot
 * @return int
 */
FindLeader(bool:DisallowBot = false)
{
    new leaderId      = 0;
    new leaderLevel   = 0;
    new currentLevel  = 0;

    for (new i = 1; i <= MaxClients; i++)
    {
        if ( DisallowBot && IsClientInGame(i) && IsFakeClient(i) )
        {
            continue;
        }

        currentLevel = PlayerLevel[i];

        if ( currentLevel > leaderLevel )
        {
            leaderLevel = currentLevel;
            leaderId = i;
        }
    }

    return leaderId;
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
        CPrintToChatAllEx(client, "%t", "Is leading on level", name, newLevel + 1);
        return;
    }
    // CurrentLeader != client
    if ( newLevel < PlayerLevel[CurrentLeader] )
    {
        // say how much to the lead
        CPrintToChat(client, "%t", "You are levels behind leader", PlayerLevel[CurrentLeader]-newLevel);
        return;
    }
    // new level == leader level
    // say tied to the lead on level X
    CPrintToChatAllEx(client, "%t", "Is tied with the leader on level", name, newLevel + 1);
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
