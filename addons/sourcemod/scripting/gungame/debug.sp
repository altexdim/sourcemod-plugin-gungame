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

OnCreateDebug()
{
	RegConsoleCmd("display", _CmdDisplay);
	RegConsoleCmd("set_level", _CmdSetLevel);
}

public Action:_CmdSetLevel(client, args)
{
	decl String:Arg[10];
	GetCmdArg(1, Arg, sizeof(Arg));

	UTIL_ChangeLevel(client, StringToInt(Arg));
	return Plugin_Handled;
}

public Action:_CmdDisplay(client, args)
{
	decl String:Args[64];
	GetCmdArg(1, Args, sizeof(Args));

	if(strcmp("weapons", Args) == 0)
	{
		//for(new i = 0; i <
	} else if(strcmp("Config", Args) == 0) {
		DisplayConfig(client);
	} else if(strcmp("", Args) == 0) {

	} else if(strcmp("", Args) == 0) {

	} else if(strcmp("", Args) == 0) {

	}

	return Plugin_Handled;
}

DisplayConfig(client)
{
	/*IsActive
	TurboMode
	IntermissionCalcWinner
	CanStealFirstLevel
	CanLevelDownOnGrenade
	VoteLevelLessWeaponCount
	AutoFriendlyFire
	MapStatus
	ObjectiveBonus
	WorldspawnSuicide
	MaxLevelPerRound
	MinKillsPerLevel
	BotCanWin
	KnifePro
	KnifeElite
	WarmupEnabled
	Warmup_TimeLength
	WarmupKnifeOnly
	WarmupReset
	AfkManagement
	AfkDeaths
	AfkAction
	NadeSmoke
	NadeGlock
	NadeFlash
	ExtraNade
	Prune
	WarmupStartup
	TripleLevelBonus
	Top10Handicap*/
}