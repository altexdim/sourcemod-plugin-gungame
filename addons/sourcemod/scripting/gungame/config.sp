/**
 *  Config Reader
 */

public GG_ConfigNewSection(const String:name[])
{
    if(strcmp("Config", name, false) == 0)
    {
        ConfigState = CONFIG_STATE_CONFIG;
    } else if(strcmp("WeaponOrder", name, false) == 0) {
        RandomWeaponOrder = false;
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
            } else if(strcmp("AlltalkOnWin", key, false) == 0) {
                AlltalkOnWin = bool:StringToInt(value);
            } else if(strcmp("RemoveBonusWeaponAmmo", key, false) == 0) {
                RemoveBonusWeaponAmmo = bool:StringToInt(value);
            } else if(strcmp("ReloadWeapon", key, false) == 0) {
                ReloadWeapon = bool:StringToInt(value);
            } else if(strcmp("AllowLevelUpAfterRoundEnd", key, false) == 0) {
                AllowLevelUpAfterRoundEnd = bool:StringToInt(value);
            } else if(strcmp("RestoreLevelOnReconnect", key, false) == 0) {
                RestoreLevelOnReconnect = bool:StringToInt(value);
            } else if(strcmp("TurboMode", key, false) == 0) {
                TurboMode = bool:StringToInt(value);
            } else if(strcmp("UnlimitedNadesIfOne", key, false) == 0) {
                UnlimitedNadesIfOne = bool:StringToInt(value);
            } else if(strcmp("WarmupRandomWeaponMode", key, false) == 0) {
                WarmupRandomWeaponMode = bool:StringToInt(value);
                WarmupRandomWeaponLevel = -1;
            } else if(strcmp("StripDeadPlayersWeapon", key, false) == 0) {
                StripDeadPlayersWeapon = bool:StringToInt(value);
            } else if(strcmp("MultiKillChat", key, false) == 0) {
                MultiKillChat = bool:StringToInt(value);
            } else if(strcmp("JoinMessage", key, false) == 0) {
                JoinMessage = bool:StringToInt(value);
            // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
            /*
            } else if(strcmp("IntermissionCalcWinner", key, false) == 0) {
                IntermissionCalcWinner = bool:StringToInt(value);
            */
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
                DisableWarmupOnRoundEnd = false;
            } else if(strcmp("WarmupTimeLength", key, false) == 0) {
                Warmup_TimeLength = StringToInt(value);
            } else if(strcmp("WarmupKnifeOnly", key, false) == 0) {
                WarmupKnifeOnly = bool:StringToInt(value);
            } else if(strcmp("ResetLevelAfterWarmup", key, false) == 0) {
                WarmupReset = bool:StringToInt(value);
            } else if(strcmp("NadeSmoke", key, false) == 0) {
                NadeSmoke = bool:StringToInt(value);
            } else if(strcmp("NadeBonus", key, false) == 0) {
                new String:NadeBonus[24];
                strcopy(NadeBonus, sizeof(NadeBonus), value);
                if ( strcmp("", NadeBonus, true) != 0 )
                {
                    UTIL_StringToLower(NadeBonus);
                    NadeBonusWeaponId = UTIL_GetWeaponIndex(NadeBonus);
                }
                else
                {
                    NadeBonusWeaponId = Weapons:0;
                }
            } else if(strcmp("NadeFlash", key, false) == 0) {
                NadeFlash = bool:StringToInt(value);
            } else if(strcmp("ExtraNade", key, false) == 0) {
                ExtraNade = bool:StringToInt(value);
            } else if(strcmp("UnlimitedNades", key, false) == 0) {
                UnlimitedNades = bool:StringToInt(value);
            } else if(strcmp("WarmupNades", key, false) == 0) {
                WarmupNades = bool:StringToInt(value);
            } else if(strcmp("WarmupStartup", key, false) == 0) {
                WarmupStartup = StringToInt(value);
            } else if(strcmp("TripleLevelBonus", key, false) == 0) {
                TripleLevelBonus = bool:StringToInt(value);
            } else if(strcmp("TripleLevelBonusGodMode", key, false) == 0) {
                TripleLevelBonusGodMode = bool:StringToInt(value);
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
            } else if(strcmp("HandicapMode", key, false) == 0) {
                HandicapMode = StringToInt(value);
            } else if(strcmp("Top10Handicap", key, false) == 0) {
                Top10Handicap = bool:StringToInt(value);
            }
        }
        
        case CONFIG_STATE_EQUIP:
        {
            if ( (strcmp("RandomWeaponOrder", key, false) == 0) && (StringToInt(value) == 1) )
            {
                // Setup random weapon order.
                RandomWeaponOrder = true;
                new switchIndex, switchLevel, String:switchWeaponName[24];
                new Float:etime;
                for (new i = 0; i < WeaponOrderCount; i++)
                {
                    RandomWeaponOrderMap[i] = i;
                }
                for (new i = 0; i < WeaponOrderCount; i++)
                {
                    switchIndex = UTIL_GetRandomInt(0, WeaponOrderCount-1);
                    if ( switchIndex == i )
                    {
                        continue;
                    }
                    switchWeaponName = WeaponOrderName[switchIndex];
                    WeaponOrderName[switchIndex] = WeaponOrderName[i];
                    WeaponOrderName[i] = switchWeaponName;
                    
                    switchLevel = RandomWeaponOrderMap[switchIndex];
                    RandomWeaponOrderMap[switchIndex] = RandomWeaponOrderMap[i];
                    RandomWeaponOrderMap[i] = switchLevel;
                }
            }
            else
            {
                new Level = StringToInt(key);

                if ( 1 <= Level <= GUNGAME_MAX_LEVEL )
                {
                    strcopy(WeaponOrderName[Level - 1], sizeof(WeaponOrderName[]), value);
                    WeaponOrderCount = Level;
                }
            }
        }

        case CONFIG_STATE_KILLS:
        {
            new Level = StringToInt(key)-1;
            if ( RandomWeaponOrder ) 
            {
                for (new i = 0; i < WeaponOrderCount; i++)
                {
                    if ( RandomWeaponOrderMap[i] == Level )
                    {
                        Level = i;
                        break;
                    }
                }
            }

            if ( 0 <= Level < GUNGAME_MAX_LEVEL )
            {
                if ( (CustomKillPerLevel[Level] = StringToInt(value)) < 0 )
                {
                    CustomKillPerLevel[Level] = NULL;
                }
            }
        }

        case CONFIG_STATE_SOUNDS:
        {
            if(strcmp(key, "IntroSound", false) == 0) {
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
            } else if(strcmp(key, "WarmupTimerSound", false) == 0) {
                strcopy(EventSounds[WarmupTimerSound], sizeof(EventSounds[]), value);
            } else if(strcmp(key, "Winner", false) == 0) {
                if (!StrEqual(value, "", false))
                {
                    new String:songs[64][64];
                    new songsfound = ExplodeString(value, ",", songs, 64, 64);
                    if ( songsfound > 1 )
                    {
                        strcopy(EventSounds[Winner], sizeof(EventSounds[]), songs[UTIL_GetRandomInt(0, songsfound-1)]);
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

    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    // MinimumLevel = WeaponOrderCount / 2;
    WeaponLevelPages = (WeaponOrderCount / 7);

    if((WeaponOrderCount - (WeaponLevelPages * 7)) != 0)
    {
        WeaponLevelPages++;
    }

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
