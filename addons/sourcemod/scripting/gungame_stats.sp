#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>
#include <gungame_stats>
#include <gungame_config>

/**
 * UnComment and recompile the plugin to support sql stats
 */
//#define SQL_SUPPORT
//#define MYSQL_SUPPORT
//#define SQLITE_SUPPORT

#include "gungame_stats/gungame_stats.h"
#include "gungame_stats/keyvalues.h"
#include "gungame_stats/config.h"
#include "gungame_stats/menu.h"
#include "gungame_stats/ranks.h"

#if defined MYSQL_SUPPORT
    //#include "gungame_stats/mysql.h"
    //#include "gungame_stats/mysql.sp"
#endif
#if defined SQLITE_SUPPORT
    //#include "gungame_stats/sqlite.h"
    //#include "gungame_stats/sqlite.sp"
#endif

#include "gungame_stats/ranks.sp"
#include "gungame_stats/menu.sp"
#include "gungame_stats/config.sp"
#include "gungame_stats/keyvalues.sp"
#include "gungame_stats/util.sp"
#include "gungame_stats/natives.sp"

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
    RegPluginLibrary("gungame_st");
    OnCreateNatives();
    return true;
}

public OnPluginStart()
{
    LoadTranslations("gungame_stats");

    OnCreateKeyValues();
    RegConsoleCmd("top10", _CmdTop10);
    RegAdminCmd("gg_rebuild", _CmdRebuild, GUNGAME_ADMINFLAG, "Rebuilds the top10 rank from the player data information");
    RegAdminCmd("gg_import", _CmdImport, GUNGAME_ADMINFLAG, "Imports the winners file from es gungame.");
}

public OnClientAuthorized(client, const String:auth[])
{
    if ( auth[0] != 'B' )
    {
        RetrieveKeyValues(client, auth);
    }
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
        new maxslots = GetMaxClients( );
        decl String:Auth[64];
        for(new i = 1; i <= maxslots; i++)
        {
            if ( IsClientInGame(i) )
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

public OnClientDisconnect(client)
{
    PlayerWinsData[client] = 0;
}

public Action:_CmdTop10(client, args)
{
    if(IsActive)
    {
        ShowTop10Panel(client);
    }
    return Plugin_Handled;
}

EndProcess()
{
    if ( SaveProcess )
    {
        return;
    }
    
    SaveProcess = true;

    SaveRank();
    SavePlayerDataInfo();
}
