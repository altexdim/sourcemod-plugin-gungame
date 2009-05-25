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

/**
 * Config Setting
 */

new State:ConfigState;
new bool:ConfigReset;

new MapStatus;
new MaxLevelPerRound = 3;
new MinKillsPerLevel = 1;
new bool:TurboMode;
new bool:JoinMessage;
new bool:IntermissionCalcWinner;
new bool:CanStealFirstLevel;
new bool:CanLevelDownOnGrenade;
new VoteLevelLessWeaponCount;
new bool:ObjectiveBonus;
new bool:WorldspawnSuicide;
new bool:NadeGlock;
new bool:NadeSmoke;
new bool:NadeFlash;
new bool:ExtraNade;
new bool:UnlimitedNades;
new bool:WarmupNades;
new bool:KnifePro;
new KnifeProMinLevel;
new bool:KnifeElite;
new bool:AutoFriendlyFire;
new bool:BotCanWin;
new TotalLevel;
new bool:WarmupEnabled = true;
new bool:WarmupInitialized;
new WarmupStartup = 1;
new Warmup_TimeLength = 30;
new WarmupKnifeOnly = 1;
new WarmupReset = 1;
new WarmupCounter;
new bool:IsVotingCalled = false;
new bool:TripleLevelBonus = false;
new bool:KnifeProHE = false;
new bool:ObjectiveBonusWin = false;
new bool:InternalIsActive = true;
new bool:CommitSuicide = true;
new bool:AlltalkOnWin = false;
