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

new PlayerState[MAXPLAYERS + 1];
new PlayerOnGrenade;

// TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
// new bool:IsIntermissionCalled;

/**
 * Caching information to see if there aleast a player on each team
 * Work around for game_start and game_end. Use GameCommenced for replacement
 */
new bool:GameCommenced;
new CTcount;
new Tcount;

/* Checks to make sure clients only gain level by objective during Round Started and not during Round End*/
new bool:RoundStarted;

/* Changes the default MinKillsPerWeapon setting if value is greater than 0. */
new CustomKillPerLevel[GUNGAME_MAX_LEVEL];

new PlayerLevel[MAXPLAYERS + 1];
new CurrentKillsPerWeap[MAXPLAYERS + 1];
new CurrentLevelPerRound[MAXPLAYERS + 1];
new CurrentLevelPerRoundTriple[MAXPLAYERS + 1];
new CurrentLeader;
new GameWinner;