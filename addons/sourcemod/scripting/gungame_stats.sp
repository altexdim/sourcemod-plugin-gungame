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
 * FlyingMongoose for slaping my ideas away and now we have none left ... Geez.
 * I would also like to thank sawce with ^^.
 * Another person who I would like to thank is OneEyed.
 */

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
	url = "http://www.hat-city.net/"
};

public bool:AskPluginLoad(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GG_DisplayTop10", __DisplayTop10);
	CreateNative("GG_GetClientWins", __GetPlayerWins);
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

public OnClientAuthorized(client, const String:auth[])
{
	if(auth[0] == 'B')
	{
		if(HandicapMode)
		{
			GG_GiveAverageLevel(client);
			return;
		}
	} else {

		#if !defined SQL_SUPPORT
		RetrieveKeyValues(client, auth);
		#endif

		if(HandicapMode && (Top10Handicap || IsPlayerInTop10(auth) == -1))
		{
			GG_GiveAverageLevel(client);
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