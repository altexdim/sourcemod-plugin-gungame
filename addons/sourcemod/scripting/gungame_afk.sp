#include <sourcemod>
#include <sdktools>
#include <gungame>
#include "gungame/chat.h"
#include "gungame/chat.sp"

new OffsetOrigin;
new bool:AfkManagement;
new AfkDeaths;
new AfkAction;
new bool:IsActive;

new Float:PlayerAfk[MAXPLAYERS + 1][3];
new PlayerAfkCount[MAXPLAYERS + 1];
new bool:PlayerSwitch[MAXPLAYERS + 1]

new State:ConfigState;
new Handle:GameConf;
new Handle:SwitchTeam;

public Plugin:myinfo =
{
    name = "GunGame:SM Afk Management",
    author = GUNGAME_AUTHOR,
    description = "GunGame:SM Afk Management System",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public OnPluginStart()
{
    CHAT_DetectColorMsg();
    GameConf = LoadGameConfigFile("gungame.games");
    CreateSwitchTeam();

    OffsetOrigin = FindSendPropOffs("CBaseEntity", "m_vecOrigin");

    if(OffsetOrigin == INVALID_OFFSET)
    {
        decl String:Error[128];
        FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetOrigin [%d]", OffsetOrigin);
        SetFailState(Error);
    }
}

public GG_OnStartup()
{
    if(!IsActive)
    {
        HookEvent("player_spawn", _PlayerSpawn);
        HookEvent("weapon_fire", _WeaponFire);
        IsActive = true;
    }
}

public GG_OnShutdown()
{
    if(IsActive)
    {
        UnhookEvent("player_spawn", _PlayerSpawn);
        UnhookEvent("weapon_fire", _WeaponFire);
        IsActive = false;
    }
}

public _PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(!IsActive || !AfkManagement)
    {
        return;
    }

    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if(!client || IsFakeClient(client))
    {
        return;
    }

    /**
     * Stores where they are spawn so that they can check for afk on death.
     */
    GetEntDataVector(client, OffsetOrigin, PlayerAfk[client]);
}

public _WeaponFire(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(!IsActive || !AfkManagement)
    {
        return;
    }

    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if(client && !IsFakeClient(client))
    {
        PlayerAfk[client][0] += 500;
    }
}

public Action:GG_OnClientDeath(Killer, Victim, Weapons:WeaponId, bool:TeamKilled)
{
    /* Afk management only checks after the player worldspawn/suicide checks */
    if(AfkManagement)
    {
        decl Float:Origin[3];
        GetEntDataVector(Victim, OffsetOrigin, Origin);

        /* Basically by the time you get here the player drop approx about 55-60 units. So checking z now here is invalid. */
        if(PlayerAfk[Victim][0] == Origin[0] && PlayerAfk[Victim][1] == Origin[1])
        {
            /* You killed an afk. */
            PrintToChat(Killer, "%c[%cGunGame%c]%c You do not gain a level because you killed an afk.", GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, YELLOW);

            if(++PlayerAfkCount[Victim] > AfkDeaths)
            {
                /* Hope this works */
                if(AfkAction & AFK_KICK)
                {
                    KickClient(Victim, "[GunGame] Max afk deaths reached");
                } else {
                    HACK_SwitchTeam(Victim, TEAM_SPECTATOR);
                    PlayerSwitch[Victim] = true;
                }
            }

            return Plugin_Handled;

        } else {
            PlayerAfkCount[Victim] = NULL;
        }
    }
    return Plugin_Continue;
}

public GG_ConfigNewSection(const String:name[])
{
    if(strcmp("Config", name, false) == 0)
    {
        ConfigState = CONFIG_STATE_CONFIG;
    }
}

public GG_ConfigKeyValue(const String:key[], const String:value[])
{
    if(ConfigState == CONFIG_STATE_CONFIG)
    {
        if(strcmp("AfkManagement", key, false) == 0) {
            AfkManagement = bool:StringToInt(value);
        } else if(strcmp("AfkDeaths", key, false) == 0) {
            AfkDeaths = StringToInt(value);
        } else if(strcmp("AfkAction", key, false) == 0) {
            AfkAction = StringToInt(value);
        }
    }
}

public GG_ConfigParseEnd()
{
    ConfigState = CONFIG_STATE_NONE;
}

CreateSwitchTeam()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "SwitchTeam");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    SwitchTeam = EndPrepSDKCall();

    if(SwitchTeam == INVALID_HANDLE)
    {
        SetFailState("Virtual SwitchTeam failed. Please contact the author.");
    }
}

HACK_SwitchTeam(client, team)
{
    SDKCall(SwitchTeam, client, team);
}