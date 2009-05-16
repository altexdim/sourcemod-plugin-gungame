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

OnCreateCommand()
{
	// ConsoleCmd
	RegConsoleCmd("level", _CmdLevel);
	RegConsoleCmd("rules", _CmdRules);
	RegConsoleCmd("score", _CmdScore);
	RegConsoleCmd("weapons", _CmdWeapons);
	RegConsoleCmd("commands", _CmdCommand);

	RegConsoleCmd("gg_version", _CmdVersion);
	RegConsoleCmd("gg_status", _CmdStatus);
	RegAdminCmd("gg_restart", CmdReset, GUNGAME_ADMINFLAG, "Restarts the whole game from the beginning.");
	RegAdminCmd("gg_enable", _CmdEnable, GUNGAME_ADMINFLAG, "Turn off gungame and restart the game.");
	RegAdminCmd("gg_disable", _CmdDisable, GUNGAME_ADMINFLAG, "Turn on gungame and restart the game.");

	/**
	 * Add any ES GunGame command if there is any.
	 */
}

public Action:_CmdEnable(client, args)
{
	if(!IsActive)
	{
		ReplyToCommand(client, "[GunGame] Turning on GunGame:SM");
		PrintToChatAll("[GunGame] GunGame has been enabled.");

		SetConVarInt(gungame_enabled, 1);

		Call_StartForward(FwdStart);
		Call_PushCell(true);
		Call_Finish();

		SetConVarInt(mp_restartgame, 1);
	} else {
		ReplyToCommand(client, "[GunGame] is already enabled");
	}
	return Plugin_Handled;
}

public Action:_CmdDisable(client, args)
{
	if(IsActive)
	{
		ReplyToCommand(client, "[GunGame] Turning off GunGame:SM");
		PrintToChatAll("[GunGame] GunGame has been disabled.");

		SetConVarInt(gungame_enabled, 0);

		Call_StartForward(FwdShutdown);
		Call_PushCell(true);
		Call_Finish();

		SetConVarInt(mp_restartgame, 1);
	} else {
		ReplyToCommand(client, "[GunGame] is already disabled");
	}
	return Plugin_Handled;
}

public Action:_CmdLevel(client, args)
{
	if(IsActive)
	{
		CreateLevelPanel(client);
	}
	return Plugin_Handled;
}

public Action:_CmdRules(client, args)
{
	if(IsActive)
	{
		DisplayMenu(RulesMenu, client, GUNGAME_MENU_TIME);
	}
	return Plugin_Handled;
}

public Action:_CmdScore(client, args)
{
	if(IsActive)
	{
		ShowPlayerLevelMenu(client);
	}
	return Plugin_Handled;
}

public Action:_CmdWeapons(client, args)
{
	if(IsActive)
	{
		ShowWeaponLevelPanel(client);
	}
	return Plugin_Handled;
}

public Action:_CmdCommand(client, args)
{
	if(IsActive)
	{
		SendPanelToClient(CommandPanel, client, CommandPanelHandler, GUNGAME_MENU_TIME);
	}
	return Plugin_Handled;
}

public Action:_CmdVersion(client, args)
{
	if(GetCmdReplySource() == SM_REPLY_TO_CHAT)
	{
		PrintToChat(client, "%c[%cGunGame%c] Please view your console for more information.", GREEN, TEAMCOLOR, GREEN);
	}

	PrintToConsole(client, "Gun Game Information:\n   Version: %s\n   Author: %s", GUNGAME_VERSION, GUNGAME_AUTHOR);
	PrintToConsole(client, "   Website: http://www.sourcemod.net\n   Compiled Time: %s %s", DATE, TIME);
	PrintToConsole(client, "\n   Idea and concepts of Gun Game was\n   originally made by cagemonkey\n   @ http://www.cagemonkey.org");

	return Plugin_Handled;
}

public Action:CmdReset(client, args)
{
	if(IsActive)
	{
		new maxslots = GetMaxClients( );

		/* Reset the game and start over */
		for(new i = 1; i <= maxslots; i++)
		{
			PlayerLevel[i] = NULL;
		}

		SetConVarInt(mp_restartgame, 1);
	}

	return Plugin_Handled;
}

public Action:_CmdStatus(client, args)
{
	/**
	 * Add a command called gg_status this will tell the state of the current game.
	 * If the game is still in warmup round, warmup round has start/not started, If game is started
	 * or not and if started it will state the leader level and gun.
	 */

	if(IsActive)
	{
		ReplyToCommand(client, "[GunGame] Currently not implmented");
	}

	return Plugin_Handled;
}