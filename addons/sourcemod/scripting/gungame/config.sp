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
            if ( strcmp("Enabled", key, false) == 0 ) {
                InternalIsActive = bool:StringToInt(value);
            } else if(strcmp("DisableRtvLevel", key, false) == 0) {
                g_cfgDisableRtvLevel = StringToInt(value) - 1;
                if ( g_cfgDisableRtvLevel < 0 ) {
                    g_cfgDisableRtvLevel = 0;
                }
            } else if(strcmp("EnableFriendlyFireLevel", key, false) == 0) {
                g_cfgEnableFriendlyFireLevel = StringToInt(value) - 1;
                if ( g_cfgEnableFriendlyFireLevel < 0 ) {
                    g_cfgEnableFriendlyFireLevel = 0;
                }
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
            } else if(strcmp("FFA", key, false) == 0) {
                FFA = StringToInt(value);
            } else if(strcmp("NumberOfNades", key, false) == 0) {
                NumberOfNades = StringToInt(value);
                if ( NumberOfNades && (NumberOfNades < 2) )
                {
                    NumberOfNades = 0;
                }
            } else if(strcmp("TurboMode", key, false) == 0) {
                TurboMode = bool:StringToInt(value);
                SetConVarInt(g_Cvar_Turbo, TurboMode);
            } else if(strcmp("HandicapTimesPerMap", key, false) == 0) {
                g_Cfg_HandicapTimesPerMap = StringToInt(value);
            } else if(strcmp("MultiLevelAmount", key, false) == 0) {
                g_Cfg_MultiLevelAmount = StringToInt(value);
                SetConVarInt(g_Cvar_MultiLevelAmount, g_Cfg_MultiLevelAmount);
            } else if(strcmp("KnifeProMaxDiff", key, false) == 0) {
                g_Cfg_KnifeProMaxDiff = StringToInt(value);
            } else if(strcmp("HandicapSkipBots", key, false) == 0) {
                g_Cfg_HandicapSkipBots = bool:StringToInt(value);
            } else if(strcmp("KnifeProRecalcPoints", key, false) == 0) {
                g_Cfg_KnifeProRecalcPoints = StringToInt(value);
            } else if(strcmp("HandicapUpdate", key, false) == 0) {
                g_Cfg_HandicapUpdate = StringToFloat(value);
            } else if(strcmp("WarmupWeapon", key, false) == 0) {
                if ( !value[0] ) {
                    g_Cfg_WarmupWeapon = 0;
                } else {
                    g_Cfg_WarmupWeapon = UTIL_GetWeaponIndex(value);
                }
            } else if(strcmp("ScoreboardClearDeaths", key, false) == 0) {
                g_Cfg_ScoreboardClearDeaths = StringToInt(value);
            } else if(strcmp("MaxHandicapLevel", key, false) == 0) {
                g_Cfg_MaxHandicapLevel = StringToInt(value);
                if ( g_Cfg_MaxHandicapLevel ) {
                    g_Cfg_MaxHandicapLevel -= 1;
                }
            } else if(strcmp("ShowSpawnMsgInHintBox", key, false) == 0) {
                g_Cfg_ShowSpawnMsgInHintBox = StringToInt(value);
            } else if(strcmp("ShowLeaderInHintBox", key, false) == 0) {
                g_Cfg_ShowLeaderInHintBox = StringToInt(value);
            } else if(strcmp("ShowLeaderWeapon", key, false) == 0) {
                g_Cfg_ShowLeaderWeapon = StringToInt(value);
            } else if(strcmp("ObjectiveBonusExplode", key, false) == 0) {
                g_Cfg_ObjectiveBonusExplode = StringToInt(value);
            } else if(strcmp("KnifeSmoke", key, false) == 0) {
                g_Cfg_KnifeSmoke = StringToInt(value);
            } else if(strcmp("KnifeFlash", key, false) == 0) {
                g_Cfg_KnifeFlash = StringToInt(value);
            } else if(strcmp("HandicapLevelSubstract", key, false) == 0) {
                g_Cfg_HandicapLevelSubstract = StringToInt(value);
            } else if(strcmp("ArmorKevlar", key, false) == 0) {
                g_Cfg_ArmorKevlar = StringToInt(value);
            } else if(strcmp("ArmorHelmet", key, false) == 0) {
                g_Cfg_ArmorHelmet = StringToInt(value);
            } else if(strcmp("MultiLevelBonusSpeed", key, false) == 0) {
               g_Cfg_TripleLevelBonusSpeed = StringToFloat(value);
            } else if(strcmp("MultiLevelEffect", key, false) == 0) {
               g_Cfg_TripleLevelEffect = bool:StringToInt(value);
            } else if(strcmp("MultiLevelBonusGravity", key, false) == 0) {
               g_Cfg_TripleLevelBonusGravity = StringToFloat(value);
            } else if(strcmp("LevelsInScoreboard", key, false) == 0) {
                g_Cfg_LevelsInScoreboard = StringToInt(value);
            } else if(strcmp("UnlimitedNadesMinPlayers", key, false) == 0) {
                UnlimitedNadesMinPlayers = StringToInt(value);
            } else if(strcmp("WarmupRandomWeaponMode", key, false) == 0) {
                WarmupRandomWeaponMode = bool:StringToInt(value);
                WarmupRandomWeaponLevel = -1;
            } else if(strcmp("StripDeadPlayersWeapon", key, false) == 0) {
                StripDeadPlayersWeapon = bool:StringToInt(value);
            } else if(strcmp("MultiKillChat", key, false) == 0) {
                MultiKillChat = bool:StringToInt(value);
            } else if(strcmp("JoinMessage", key, false) == 0) {
                JoinMessage = bool:StringToInt(value);
            } else if(strcmp("VoteLevelLessWeaponCount", key, false) == 0) {
                VoteLevelLessWeaponCount = StringToInt(value);
            } else if(strcmp("AutoFriendlyFire", key, false) == 0) {
                AutoFriendlyFire = bool:StringToInt(value);
            } else if(strcmp("RemoveObjectives", key, false) == 0) {
                MapStatus = StringToInt(value);
            } else if(strcmp("ObjectiveBonus", key, false) == 0) {
                ObjectiveBonus = StringToInt(value);
            } else if(strcmp("WorldspawnSuicide", key, false) == 0) {
                WorldspawnSuicide = StringToInt(value);
            } else if(strcmp("MaxLevelPerRound", key, false) == 0) {
                MaxLevelPerRound = StringToInt(value);
                if ( MaxLevelPerRound < 0 )
                {
                    MaxLevelPerRound = 0;
                }
            } else if(strcmp("MinKillsPerLevel", key, false) == 0) {
                MinKillsPerLevel = StringToInt(value);
                if( MinKillsPerLevel < 1)
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
            } else if(strcmp("NadeSmoke", key, false) == 0) {
                NadeSmoke = bool:StringToInt(value);
            } else if(strcmp("NadeBonus", key, false) == 0) {
                if ( !value[0] ) {
                    NadeBonusWeaponId = 0;
                } else {
                    NadeBonusWeaponId = UTIL_GetWeaponIndex(value);
                }
            } else if(strcmp("NadeFlash", key, false) == 0) {
                NadeFlash = bool:StringToInt(value);
            } else if(strcmp("ExtraNade", key, false) == 0) {
                g_Cfg_ExtraNade = StringToInt(value);
            } else if(strcmp("UnlimitedNades", key, false) == 0) {
                UnlimitedNades = bool:StringToInt(value);
            } else if(strcmp("WarmupNades", key, false) == 0) {
                WarmupNades = bool:StringToInt(value);
            } else if(strcmp("MultiLevelBonus", key, false) == 0) {
                TripleLevelBonus = bool:StringToInt(value);
            } else if(strcmp("MultiLevelBonusGodMode", key, false) == 0) {
                TripleLevelBonusGodMode = bool:StringToInt(value);
            } else if(strcmp("ObjectiveBonusWin", key, false) == 0) {
                ObjectiveBonusWin = bool:StringToInt(value);
            } else if(strcmp("KnifeProHE", key, false) == 0) {
                KnifeProHE = bool:StringToInt(value);
            } else if(strcmp("KnifeProMinLevel", key, false) == 0) {
                KnifeProMinLevel = StringToInt(value) - 1;

                if(KnifeProMinLevel < 0)
                {
                    KnifeProMinLevel = 0;
                }
            } else if(strcmp("CommitSuicide", key, false) == 0) {
                CommitSuicide = StringToInt(value);
            } else if(strcmp("HandicapMode", key, false) == 0) {
                HandicapMode = StringToInt(value);
            } else if(strcmp("TopRankHandicap", key, false) == 0) {
                TopRankHandicap = bool:StringToInt(value);
            } else if(strcmp("FriendlyFireOnOff", key, false) == 0) {
                g_cfgFriendlyFireOnOff = bool:StringToInt(value);
            } else if(strcmp("HandicapUseSpectators", key, false) == 0) {
                g_Cfg_HandicapUseSpectators = bool:StringToInt(value);
            } else if(strcmp("CanLevelUpWithPhysics", key, false) == 0) {
                g_Cfg_CanLevelUpWithPhysics = bool:StringToInt(value);
            } else if(strcmp("CanLevelUpWithPhysicsOnGrenade", key, false) == 0) {
                g_Cfg_CanLevelUpWithPhysicsG = bool:StringToInt(value);
            } else if(strcmp("CanLevelUpWithPhysicsOnKnife", key, false) == 0) {
                g_Cfg_CanLevelUpWithPhysicsK = bool:StringToInt(value);
            } else if(strcmp("CanLevelUpWithMapNades", key, false) == 0) {
                g_Cfg_CanLevelUpWithMapNades = bool:StringToInt(value);
            } else if(strcmp("CanLevelUpWithNadeOnKnife", key, false) == 0) {
                g_Cfg_CanLevelUpWithNadeOnKnife = bool:StringToInt(value);
            } else if(strcmp("DisableLevelDown", key, false) == 0) {
                g_Cfg_DisableLevelDown = bool:StringToInt(value);
            } else if(strcmp("SelfKillProtection", key, false) == 0) {
                g_Cfg_SelfKillProtection = bool:StringToInt(value);
            } else if(strcmp("GameDesc", key, false) == 0) {
                strcopy(g_CfgGameDesc, sizeof(g_CfgGameDesc), value);
                ReplaceString(g_CfgGameDesc, sizeof(g_CfgGameDesc), "{version}", GUNGAME_VERSION, false);
            } else if(strcmp("MultilevelEffectType", key, false) == 0) {
                g_Cfg_MultilevelEffectType = StringToInt(value);
            } else if ( strcmp("BlockWeaponSwitchOnNade", key, false) == 0 ) {
                g_Cfg_BlockWeaponSwitchOnNade = bool:StringToInt(value);
            } else if ( strcmp("BlockWeaponSwitchIfKnife", key, false) == 0 ) {
                g_Cfg_BlockWeaponSwitchIfKnife = bool:StringToInt(value);
            }
        }
        
        case CONFIG_STATE_EQUIP:
        {
            
            if ( ( strcmp("RandomWeaponReserveLevels", key, false) == 0 ) && ( value[0] ) )
            {
                new String:buffers[sizeof(g_Cfg_RandomWeaponReservLevels)][3];
                ExplodeString(value, ",", buffers, sizeof(buffers), sizeof(buffers[]));
                for ( new i = 0; i < sizeof(buffers); i++ )
                {
                    if ( !buffers[i][0] ) {
                        break;
                    }
                    g_Cfg_RandomWeaponReservLevels[StringToInt(buffers[i])-1] = 1;
                }
            }
            else if ( ( strcmp("RandomWeaponOrder", key, false) == 0 ) && ( StringToInt(value) == 1 ) )
            {
                // Setup random weapon order.
                RandomWeaponOrder = true;
                new String:tmpWeaponName[24], sizeOfRandom;
                for ( new i = 0; i < WeaponOrderCount; i++ )
                {
                    if ( !g_Cfg_RandomWeaponReservLevels[i] )
                    {
                        RandomWeaponOrderMap[sizeOfRandom++] = i;
                    }
                }
                UTIL_ArrayIntRand(RandomWeaponOrderMap, sizeOfRandom);
                for ( new i = 0; (i < WeaponOrderCount) && (sizeOfRandom < WeaponOrderCount); i++ )
                {
                    if ( g_Cfg_RandomWeaponReservLevels[i] )
                    {
                        RandomWeaponOrderMap[sizeOfRandom++] = RandomWeaponOrderMap[i];
                        RandomWeaponOrderMap[i] = i;
                    }
                }
                for ( new i = 0; i < WeaponOrderCount; i++ )
                {
                    tmpWeaponName = WeaponOrderName[RandomWeaponOrderMap[i]];
                    WeaponOrderName[RandomWeaponOrderMap[i]] = WeaponOrderName[i];
                    WeaponOrderName[i] = tmpWeaponName;
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
                    CustomKillPerLevel[Level] = 0;
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
        new Handle:Cvar_CfgDirName;
        Cvar_CfgDirName = FindConVar("sm_gg_cfgdirname");

        if ( Cvar_CfgDirName == INVALID_HANDLE ) {
            LogError("Cvar sm_gg_cfgdirname not found. Does gungame_config.smx plugin loaded?");
        } else {
            decl String:ConfigDirName[PLATFORM_MAX_PATH];
            GetConVarString(Cvar_CfgDirName, ConfigDirName, sizeof(ConfigDirName));

            decl String:ConfigDir[PLATFORM_MAX_PATH];
            if (g_GameName == GameName:Css) {
                FormatEx(ConfigDir, sizeof(ConfigDir), "%s\\css", ConfigDirName);
            } else if (g_GameName == GameName:Csgo) {
                FormatEx(ConfigDir, sizeof(ConfigDir), "%s\\csgo", ConfigDirName);
            }

            InsertServerCommand("exec \\%s\\gungame.mapconfig.cfg", ConfigDir);
        }
    }
}

ClearCustomKill()
{
    for(new i = 0; i < WeaponOrderCount; i++)
    {
        CustomKillPerLevel[i] = 0;
    }
}
