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
 * This is a meant to make the tk optional where you lose a level by team killing another teammate.
 */

public Plugin:myinfo =
{
	name = "GunGame:SM TK Management",
	author = GUNGAME_AUTHOR,
	description = "Team Killed Management System",
	version = GUNGAME_VERSION,
	url = "http://www.hat-city.net/"
};

public Action:GG_OnClientDeath(Killer, Victim, Weapons:WeaponId, bool:TeamKilled)
{
	if(TeamKilled)
	{
		/* Tk a player */
		GG_RemoveALevel(Killer);
		// TODO: Recalculate leader on TK

		decl String:kName[MAX_NAME_SIZE], String:vName[MAX_NAME_SIZE];
		GetClientName(Killer, kName, sizeof(kName));
		GetClientName(Victim, vName, sizeof(vName));

		PrintToChatAll("%c[%cGunGame%c] %c%s%c has lost a level due to team kill of %c%s%c.",
			GREEN, TEAMCOLOR, GREEN, YELLOW, kName, GREEN, YELLOW, vName, GREEN);

		return Plugin_Handled;
	}
	return Plugin_Continue;
}
