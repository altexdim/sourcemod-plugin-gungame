#pragma semicolon 1
#include <sourcemod>
#include <gungame>

/**
 * UnComment and recompile the plugin to support sql stats
 */
//#define SQL_SUPPORT


#include "gungame_stats/gungame_stats.h"
#include "gungame_stats/keyvalues.h"
#include "gungame_stats/config.h"
#include "gungame_stats/menu.h"
#include "gungame_stats/ranks.h"

#if defined SQL_SUPPORT /* Todo */
  #if defined SQL_LITE
    //#include "gungame_stats/sqlite.h"
    //#include "gungame_stats/sqlite.sp"
  #else
    //#include "gungame_stats/mysql.h"
    //#include "gungame_stats/mysql.sp"
  #endif
#endif

#include "gungame_stats/ranks.sp"
#include "gungame_stats/menu.sp"
#include "gungame_stats/config.sp"
#include "gungame_stats/keyvalues.sp"

public Plugin:myinfo =
{
    name = "GunGame:SM Stats",
    author = GUNGAME_AUTHOR,
    description = "Stats for GunGame:SM",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public bool:AskPluginLoad(Handle:myself, bool:late, String:error[], err_max)
{
    CreateNative("GG_DisplayTop10", __DisplayTop10);
    CreateNative("GG_GetClientWins", __GetPlayerWins);
    CreateNative("GG_CountPlayersInStat", __CountPlayersInStat);
    CreateNative("GG_GetPlayerPlaceInStat", __GetPlayerPlaceInStat);
    return true;
}

public OnPluginStart()
{
    OnCreateKeyValues();
    RegConsoleCmd("top10", _CmdTop10);
    RegAdminCmd("gg_rebuild", _CmdRebuild, GUNGAME_ADMINFLAG, "Rebuilds the top10 rank from the player data information");
    RegAdminCmd("gg_import", _CmdImport, GUNGAME_ADMINFLAG, "Imports the winners file from es gungame.");
}

public OnMapStart()
{
    SaveProcess = false;
    Top10Panel = CreateTop10Panel();
}

public OnMapEnd()
{
    if(!SaveProcess)
    {
        EndProcess();
    }

    if(Top10Panel != INVALID_HANDLE)
    {
        CloseHandle(Top10Panel);
        Top10Panel = INVALID_HANDLE;
    }

}

public OnPluginEnd()
{
    if(!SaveProcess)
    {
        EndProcess();
    }
}

public GG_OnStartup(bool:Command)
{
    if(!IsActive)
    {
        new maxslots = GetMaxClients( );
        IsActive = true;
        decl String:Auth[64];
        for(new i = 1; i <= maxslots; i++)
        {
            if(IsClientInGame(i))
            {
                GetClientAuthString(i, Auth, sizeof(Auth));
                OnClientAuthorized(i, Auth);
            }
        }
    }
}

public GG_OnShutdown()
{
    if(IsActive)
    {
        IsActive = false;

        if(!SaveProcess)
        {
            EndProcess();
        }

        new maxslots = GetMaxClients( );

        for(new i = 1; i <= maxslots; i++)
        {
            if(IsClientInGame(i))
            {
                OnClientDisconnect(i);
            }
        }
    }
}

public __DisplayTop10(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > GetMaxClients())
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    if(Top10Panel != INVALID_HANDLE)
    {
        SendPanelToClient(Top10Panel, client, EmptyHandler, GUNGAME_MENU_TIME);
    }
    return 1;
}

public __GetPlayerPlaceInStat(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > GetMaxClients())
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return GetPlayerPlaceInStat(client);
}

public __CountPlayersInStat(Handle:plugin, numParams)
{
    return CountPlayersInStat();
}

public __GetPlayerWins(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > GetMaxClients())
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return PlayerWinsData[client];
}

// Handicap is here because of IsPlayerInTop10 is in stats part of plugin.
public OnClientAuthorized(client, const String:auth[])
{
    if(auth[0] == 'B')
    {
        if(HandicapMode)
        {
            GG_GiveHandicapLevel(client, HandicapMode);
            return;
        }
    } else {

        #if !defined SQL_SUPPORT
        RetrieveKeyValues(client, auth);
        #endif

        if(HandicapMode && (Top10Handicap || IsPlayerInTop10(auth) == -1))
        {
            GG_GiveHandicapLevel(client, HandicapMode);
        }
    }
}

public OnClientDisconnect(client)
{
    PlayerWinsData[client] = NULL;
}

public Action:_CmdTop10(client, args)
{
    if(IsActive && Top10Panel != INVALID_HANDLE)
    {
        SendPanelToClient(Top10Panel, client, EmptyHandler, GUNGAME_MENU_TIME);
    }
    return Plugin_Handled;
}

EndProcess()
{
    SaveProcess = true;

    SaveRank();
    SavePlayerDataInfo();
}
