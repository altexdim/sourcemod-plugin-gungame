#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>
#include <gungame_stats>
#include <gungame_config>
#include <colors>
#include <langutils>

#include "gungame_stats/gungame_stats.h"
#include "gungame_stats/config.h"
#include "gungame_stats/menu.h"

#if defined SQL_SUPPORT
    #include "gungame_stats/sql.h"
    #include "gungame_stats/sql.sp"
#endif

#if !defined SQL_SUPPORT
    #include "gungame_stats/ranks.h"
    #include "gungame_stats/ranks.sp"
    #include "gungame_stats/keyvalues.h"
    #include "gungame_stats/keyvalues.sp"
#endif

#include "gungame_stats/menu.sp"
#include "gungame_stats/config.sp"
#include "gungame_stats/natives.sp"

public Plugin:myinfo =
{
    name = "GunGame:SM Stats",
    author = GUNGAME_AUTHOR,
    description = "Stats for GunGame:SM",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

#if defined ASK_PLUGIN_LOAD2_SUPPORT
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
    RegPluginLibrary("gungame_st");
    OnCreateNatives();
    return APLRes_Success;
}

#else
// deprecated in 1.3.1
public bool:AskPluginLoad(Handle:myself, bool:late, String:error[], err_max)
{
    RegPluginLibrary("gungame_st");
    OnCreateNatives();
    return true;
}
#endif

public OnPluginStart()
{
    #if defined SQL_SUPPORT
        FwdLoadRank = CreateGlobalForward("GG_OnLoadRank", ET_Ignore);
        FwdLoadPlayerWins = CreateGlobalForward("GG_OnLoadPlayerWins", ET_Ignore, Param_Cell);
    #endif
    
    LoadTranslations("gungame_stats");
    OnCreateKeyValues();

    RegConsoleCmd("top10", _CmdTop);
    RegConsoleCmd("top", _CmdTop);
    #if defined SQL_SUPPORT
        RegConsoleCmd("rank", _CmdRank);
    #endif
    RegAdminCmd("gg_rebuild", _CmdRebuild, GUNGAME_ADMINFLAG, "Rebuilds the top rank from the player data information");
    RegAdminCmd("gg_import", _CmdImport, GUNGAME_ADMINFLAG, "Imports the winners file from es gungame.");
    #if defined SQL_SUPPORT
        RegAdminCmd("gg_reset", _CmdReset, GUNGAME_ADMINFLAG, "Reset all gungame stats.");
        RegAdminCmd("gg_importdb", _CmdImportDb, GUNGAME_ADMINFLAG, "Imports the winners from gungame players data file into database.");
    #endif
}

public OnClientAuthorized(client, const String:auth[])
{
    RetrieveKeyValues(client, auth);
}

public OnMapStart()
{
    SaveProcess = false;
}

public OnMapEnd()
{
    EndProcess();
}

public OnPluginEnd()
{
    EndProcess();
}

public GG_OnStartup(bool:Command)
{
    if ( !IsActive )
    {
        IsActive = true;
        decl String:Auth[64];
        for(new i = 1; i <= MaxClients; i++)
        {
            if ( IsClientAuthorized(i) )
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

        EndProcess();

        for(new i = 1; i <= MaxClients; i++)
        {
            if ( IsClientInGame(i) )
            {
                OnClientDisconnect(i);
            }
        }
    }
}

public OnClientDisconnect(client)
{
    g_PlayerWinsLoaded[client] = false;
    PlayerWinsData[client] = 0;
    #if defined SQL_SUPPORT
        PlayerPlaceData[client] = 0;
    #endif
}

public Action:_CmdTop(client, args)
{
    if ( IsActive )
    {
        ShowTopMenu(client);
    }
    return Plugin_Handled;
}

#if defined SQL_SUPPORT
public Action:_CmdRank(client, args)
{
    if ( IsActive )
    {
        ShowRank(client);
    }
    return Plugin_Handled;
}
#endif

EndProcess()
{
    if ( SaveProcess )
    {
        return;
    }
    
    SaveProcess = true;

    #if !defined SQL_SUPPORT
        SaveRank();
    #endif
    SavePlayerDataInfo();
}

public GG_OnWinner(client, const String:Weapon[], victim) {
    if ( IsClientInGame(client) && !IsFakeClient(client) ) {
        if ( g_Cfg_DontAddWinsOnBot && victim && IsFakeClient(victim) ) {
            return;
        }

        ++PlayerWinsData[client];
        SavePlayerData(client);
        #if !defined SQL_SUPPORT
            CheckRank(client);
        #endif
    }
}
