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
 *	Config Reader
 */

public GG_ConfigNewSection(const String:name[])
{
	if(strcmp("Config", name, false) == 0)
	{
		ConfigState = CONFIG_STATE_CONFIG;
	} else if(strcmp("WeaponOrder", name, false) == 0) {
		ConfigState = CONFIG_STATE_EQUIP;
	} else if(strcmp("MultipleKillsPerLevel", name, false) == 0) {
		ConfigReset = true;
		ConfigState = CONFIG_STATE_KILLS;
	} else if(strcmp("Sounds", name, false) == 0) {
		ConfigState = CONFIG_STATE_SOUNDS;
	}
}

public GG_ConfigKeyValue(const String:key[], const String:value[])
{
	if(ConfigReset && ConfigState == CONFIG_STATE_KILLS)
	{
		ConfigReset = false;
		ClearCustomKill();
	}

	switch(ConfigState)
	{
		case CONFIG_STATE_CONFIG:
		{
			if(strcmp("Enabled", key, false) == 0)
			{
				InternalIsActive = bool:StringToInt(value);
			} else if(strcmp("TurboMode", key, false) == 0) {
				TurboMode = bool:StringToInt(value);
			} else if(strcmp("JoinMessage", key, false) == 0) {
				JoinMessage = bool:StringToInt(value);
			} else if(strcmp("IntermissionCalcWinner", key, false) == 0) {
				IntermissionCalcWinner = bool:StringToInt(value);
			} else if(strcmp("VoteLevelLessWeaponCount", key, false) == 0) {
				VoteLevelLessWeaponCount = StringToInt(value);
			} else if(strcmp("CanLevelDownOnGrenade", key, false) == 0) {
				CanLevelDownOnGrenade = bool:StringToInt(value);
			} else if(strcmp("CanStealFirstLevel", key, false) == 0) {
				CanStealFirstLevel = bool:StringToInt(value);
			} else if(strcmp("AutoFriendlyFire", key, false) == 0) {
				AutoFriendlyFire = bool:StringToInt(value);
			} else if(strcmp("RemoveObjectives", key, false) == 0) {
				MapStatus = StringToInt(value);
			} else if(strcmp("ObjectiveBonus", key, false) == 0) {
				ObjectiveBonus = bool:StringToInt(value);
			} else if(strcmp("WorldspawnSuicide", key, false) == 0) {
				WorldspawnSuicide = bool:StringToInt(value);
			} else if(strcmp("MaxLevelPerRound", key, false) == 0) {
				MaxLevelPerRound = StringToInt(value);

				if(MaxLevelPerRound < 0)
				{
					MaxLevelPerRound = NULL;
				}
			} else if(strcmp("MinKillsPerLevel", key, false) == 0) {

				if((MinKillsPerLevel = StringToInt(value)) < 1)
				{
					MinKillsPerLevel = 1;
				}

			} else if(strcmp("BotsCanWinGame", key, false) == 0) {
				BotCanWin = bool:StringToInt(value);
			} else if(strcmp("KnifePro", key, false) == 0) {
				KnifePro = bool:StringToInt(value);
			} else if(strcmp("KnifeElite", key, false) == 0) {
				KnifeElite = bool:StringToInt(value);
			} else if(strcmp("WarmupEnabled", key, false) == 0) {
				WarmupEnabled = bool:StringToInt(value);
			} else if(strcmp("WarmupTimeLength", key, false) == 0) {
				Warmup_TimeLength = StringToInt(value);
			} else if(strcmp("WarmupKnifeOnly", key, false) == 0) {
				WarmupKnifeOnly = bool:StringToInt(value);
			} else if(strcmp("ResetLevelAfterWarmup", key, false) == 0) {
				WarmupReset = bool:StringToInt(value);
			} else if(strcmp("NadeSmoke", key, false) == 0) {
				NadeSmoke = bool:StringToInt(value);
			} else if(strcmp("NadeGlock", key, false) == 0) {
				NadeGlock = bool:StringToInt(value);
			} else if(strcmp("NadeFlash", key, false) == 0) {
				NadeFlash = bool:StringToInt(value);
			} else if(strcmp("ExtraNade", key, false) == 0) {
				ExtraNade = bool:StringToInt(value);
			} else if(strcmp("WarmupStartup", key, false) == 0) {
				WarmupStartup = StringToInt(value);
			} else if(strcmp("TripleLevelBonus", key, false) == 0) {
				TripleLevelBonus = bool:StringToInt(value);
			} else if(strcmp("ObjectiveBonusWin", key, false) == 0) {
				ObjectiveBonusWin = bool:StringToInt(value);
			} else if(strcmp("KnifeProHE", key, false) == 0) {
				KnifeProHE = bool:StringToInt(value);
			} else if(strcmp("KnifeProMinLevel", key, false) == 0) {
				KnifeProMinLevel = StringToInt(value) - 1;

				if(KnifeProMinLevel < 0)
				{
					KnifeProMinLevel = NULL;
				}
			} else if(strcmp("CommitSuicide", key, false) == 0) {
				CommitSuicide = bool:StringToInt(value);
			}
		}

		case CONFIG_STATE_EQUIP:
		{
			new Level = StringToInt(key);

			if(1 <= Level <= GUNGAME_MAX_LEVEL)
			{
				strcopy(WeaponOrderName[Level - 1], sizeof(WeaponOrderName[]), value);
				WeaponOrderCount = Level;
			}

			/*if(strcmp("RandomWeaponOrder", key, false) == 0)
			{
				// Setup random weapon order.
			}*/
		}

		case CONFIG_STATE_KILLS:
		{
			new Level = StringToInt(key);

			if(1 < Level <= GUNGAME_MAX_LEVEL)
			{
				if((CustomKillPerLevel[Level - 1] = StringToInt(value)) < 0)
				{
					CustomKillPerLevel[Level - 1] = NULL;
				}
			}
		}

		case CONFIG_STATE_SOUNDS:
		{
			if(strcmp(key, "IntroSound", false) == 0)
			{
				strcopy(EventSounds[Welcome], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "KnifeLevel", false) == 0) {
				strcopy(EventSounds[Knife], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "NadeLevel", false) == 0) {
				strcopy(EventSounds[Nade], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "LevelSteal", false) == 0) {
				strcopy(EventSounds[Steal], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "LevelUp", false) == 0) {
				strcopy(EventSounds[Up], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "LevelDown", false) == 0) {
				strcopy(EventSounds[Down], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "Triple", false) == 0) {
				strcopy(EventSounds[Triple], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "Autoff", false) == 0) {
				strcopy(EventSounds[AutoFF], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "MultiKill", false) == 0) {
				strcopy(EventSounds[MultiKill], sizeof(EventSounds[]), value);
			} else if(strcmp(key, "Winner", false) == 0) {
				if (!StrEqual(value, "", false))
				{
					new String:songs[64][64];
					new songsfound = ExplodeString(value, ",", songs, 64, 64);
					if ( songsfound > 1 )
					{
						new Float:etime = GetEngineTime();
						new rand = (RoundFloat((etime-RoundToZero(etime))*1000000) + GetTime()) % songsfound;
						strcopy(EventSounds[Winner], sizeof(EventSounds[]), songs[rand]);
					}
					else
					{
						strcopy(EventSounds[Winner], sizeof(EventSounds[]), value);
					}
				}
				else
				{
					strcopy(EventSounds[Winner], sizeof(EventSounds[]), value);
				}
			}
		}
	}
}

public GG_ConfigParseEnd()
{
	ConfigState = CONFIG_STATE_NONE;
}

public GG_ConfigEnd()
{
	/**
	 * It should of been done reading the end of WeaponOrder List
	 * Truncate the WeaponOrderCount if does not equal to MAX_LEVEL
	 */
	if(WeaponOrderCount != GUNGAME_MAX_LEVEL)
	{
		WeaponOrderName[WeaponOrderCount][0] = '\0';
	}

	UTIL_ConvertWeaponToIndex();

	MinimumLevel = WeaponOrderCount / 2;
	WeaponLevelPages = (WeaponOrderCount / 7);

	if((WeaponOrderCount - (WeaponLevelPages * 7)) != 0)
	{
		WeaponLevelPages++;
	}

	JoinMsgPanel = CreateJoinMsgPanel();
	RulesMenu = CreateRulesMenu();
	CommandPanel = CreateCommandPanel();

	if(InternalIsActive)
	{
		SetConVarInt(gungame_enabled, 1);

		Call_StartForward(FwdStart);
		Call_PushCell(false);
		Call_Finish();
	} else {
		SetConVarInt(gungame_enabled, 0);

		Call_StartForward(FwdShutdown);
		Call_PushCell(false);
		Call_Finish();
	}
}

public OnConfigsExecuted()
{
	if(IsActive)
	{
		InsertServerCommand("exec \\gungame\\gungame.mapconfig.cfg");
	}
}

ClearCustomKill()
{
	for(new i = 0; i < WeaponOrderCount; i++)
	{
		CustomKillPerLevel[i] = NULL;
	}
}
