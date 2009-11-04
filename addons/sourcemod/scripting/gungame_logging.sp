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
 * This is a plugin for hlstatx logging of the winner of the gungame current level.
 */

public Plugin:myinfo =
{
    name = "GunGame:SM Winner Logger",
    author = GUNGAME_AUTHOR,
    description = "Logging of winner for external stats plugin",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public GG_OnWinner(client, const String:Weapon[])
{
    LogEventToGame("gg_win", client);
}

public GG_OnLeaderChange(client, level, totalLevels)
{
    if ( client && IsClientInGame(client) )
    {
        LogEventToGame("gg_leader", client);
    }
}

public Action:GG_OnClientLevelChange(client, level, difference, bool:steal, bool:last)
{
    if ( !difference )
    {
        return;
    }
    if ( difference > 0 )
    {
        if ( steal )
        {
            LogEventToGame("gg_knife_steal", client);
        }
        LogEventToGame("gg_levelup", client);
        if ( last )
        {
            LogEventToGame("gg_knife_level", client);
        }
    }
    else
    {
        LogEventToGame("gg_leveldown", client);
    }
}

LogEventToGame(const String:event[], client)
{
    decl String:Name[64], String:Auth[64];

    GetClientName(client, Name, sizeof(Name));
    GetClientAuthString(client, Auth, sizeof(Auth));

    new team = GetClientTeam(client), UserId = GetClientUserId(client);
    LogToGame("\"%s<%d><%s><%s>\" triggered \"%s\"", Name, UserId, Auth, (team == TEAM_T) ? "TERRORIST" : "CT", event);
}
   
