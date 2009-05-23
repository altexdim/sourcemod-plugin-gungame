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

OnEventStart()
{
    // Events
    HookEvent("round_start", _RoundState);
    HookEvent("round_end", _RoundState);
    HookEvent("player_death", _PlayerDeath);
    HookEvent("player_spawn", _PlayerSpawn);
    HookEvent("player_team", _PlayerTeam);
    HookEvent("item_pickup", _ItemPickup);

    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    //HookUserMessage(VGUIMenu, _VGuiMenu);

    if(cssdm_enabled != INVALID_HANDLE)
    {
        IsDmActive = bool:GetConVarInt(cssdm_enabled);
        HookConVarChange(cssdm_enabled, DM_Handler);
    }
}

OnEventShutdown()
{
    // Events
    UnhookEvent("round_start", _RoundState);
    UnhookEvent("round_end", _RoundState);
    UnhookEvent("player_death", _PlayerDeath);
    UnhookEvent("player_spawn", _PlayerSpawn);
    UnhookEvent("player_team", _PlayerTeam);
    UnhookEvent("item_pickup", _ItemPickup);

    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    //UnhookUserMessage(VGUIMenu, _VGuiMenu);

    if(cssdm_enabled != INVALID_HANDLE)
    {
        IsDmActive = false;
        UnhookConVarChange(cssdm_enabled, DM_Handler);
    }
}

public Action:_VGuiMenu(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
    /* Check if init is always false after the first call. */
    if(!IsActive || IsIntermissionCalled || !IntermissionCalcWinner)
    {
        return;
    }

    decl String:Type[24];
    BfReadString(bf, Type, sizeof(Type));

    if(BfReadByte(bf) == 1 && BfReadByte(bf) == 0 && strcmp(Type, "scores", false) == 0)
    {
        IsIntermissionCalled =  true;

        /* Do intermission calculation if a winner wasn't declared by completing the weapon order. */
        if(!GameWinner)
        {
            /* No decisive winner has completed the game. */
            if(!CurrentLeader)
            {
                CurrentLeader = FindLeader();
                if ( !CurrentLeader )
                {
                    return;
                }
                new prevLeaderLevel = PlayerLevel[CurrentLeader];
                PlayerLevel[CurrentLeader] = 0;
                CurrentLeader = FindLeader();
                if ( PlayerLevel[CurrentLeader] == prevLeaderLevel )
                {
                    // multiple leaders found
                    return;
                }
            }

            if(CurrentLeader)
            {
                if(!BotCanWin && IsFakeClient(CurrentLeader))
                {
                    CurrentLeader = FindLeader(true);
                    /* No real player was found */
                    if( !CurrentLeader )
                    {
                        return;
                    }
                }
                new prevLeader = CurrentLeader;
                new prevLeaderLevel = PlayerLevel[CurrentLeader];
                PlayerLevel[CurrentLeader] = 0;
                CurrentLeader = FindLeader();
                if( CurrentLeader && PlayerLevel[CurrentLeader] == prevLeaderLevel )
                {
                    // multiple leaders found
                    return;
                }
                CurrentLeader = prevLeader;
                PlayerLevel[CurrentLeader] = prevLeaderLevel;
                new level = PlayerLevel[CurrentLeader];

                if(level > MinimumLevel)
                {
                    GameWinner = CurrentLeader;
                }

                if(GameWinner)
                {
                    decl String:Name[MAX_NAME_SIZE];

                    if(IsClientInGame(GameWinner))
                    {
                        GetClientName(GameWinner, Name, sizeof(Name));
                        new team = GetClientTeam(GameWinner);
                        new r = (team == TEAM_T ? 255 : 0);
                        new g = (team != TEAM_T && team != TEAM_CT) ? 255 : 0;
                        new b = (team == TEAM_CT ? 255 : 0);
                        UTIL_PrintToUpperLeft(0, r, g, b, "[GunGame] %s has won.", Name);
                    }

                    Call_StartForward(FwdWinner);
                    Call_PushCell(GameWinner);
                    Call_PushString(WeaponName[WeaponOrderId[level]][7]);
                    Call_Finish();

                    UTIL_PlaySound(0, Winner);
                }
            }
            /* else no leader was found so no winner. */
        }
    }
}

public _ItemPickup(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(IsActive && KnifeElite)
    {
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

        if(client && PlayerState[client] & KNIFE_ELITE)
        {
            UTIL_ForceDropAllWeapon(client);
        }
    }
}

public _BombPickup(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(IsActive && MapStatus & OBJECTIVE_REMOVE_BOMB && !IsDmActive)
    {
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

        if(client)
        {
            UTIL_ForceDropWeaponBySlot(client, Slot_C4, true);
        }
    }
}

public _PlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
    switch(GetEventInt(event, "oldteam"))
    {
        case TEAM_T:
        {
            Tcount--;
        }
        case TEAM_CT:
        {
            CTcount--;
        }
    }

    /* Player disconnected and didn't join a new team */
    if(!GetEventBool(event, "disconnect"))
    {
        switch(GetEventInt(event, "team"))
        {
            case TEAM_T:
            {
                Tcount++;
            }
            case TEAM_CT:
            {
                CTcount++;
            }
        }
    }

    /* If one of the counts goes to 0 that means game is not commenced any more */
    if(!CTcount || !Tcount)
    {
        GameCommenced = false;
    }
}

public _RoundState(Handle:event, const String:name[], bool:dontBroadcast)
{
    /**
     * round_start
     * round_end
     * 0123456
     */
    if(IsActive)
    {
        if(name[6] == 's')
        {
            if(GameWinner)
            {
                /* Lock all player since the winner was declare already if new round happened. */
                UTIL_FreezeAllPlayer();
            }

            /* Round has Started. */
            RoundStarted = true;

            /* Only remove the hostages on after it been initialized */
            if(MapStatus & OBJECTIVE_HOSTAGE && MapStatus & OBJECTIVE_REMOVE_HOSTAGE)
            {
                /*Delay for 0.1 because data need to be filled for hostage entity index */
                CreateTimer(0.1, RemoveHostages);
            }

            if(WarmupStartup & GAME_START && WarmupEnabled && !WarmupInitialized && GameCommenced)
            {
                StartWarmupRound();
            }
            UTIL_PlaySoundForLeaderLevel();
        } else {
            /* Round has ended. */
            RoundStarted = false;

            if(GetEventInt(event, "reason") == 16)
            {
                GameCommenced = true;
            }
        }
    }
}

public Action:RemoveHostages(Handle:timer)
{
    /**
     * m_bHostageAlive
     * I wonder if I have to set the other Hostage items.
     * */

    if(HostageEntInfo)
    {
        for(new i = 0, edict; i < MAXHOSTAGE; i++)
        {
            // Will this return 0 if there is no hostage id in the store? from m_iHostageEntityIDs
            edict = GetEntData(HostageEntInfo, OffsetHostage + (i * 4));

            if(edict && IsValidEntity(edict))
            {
                HACK_Remove(edict);
                SetEntData(HostageEntInfo, OffsetHostage + (i * 4), 0, _, true);

            } else {
                break;
            }
        }
    }
}

public Action:DelayClearMoney(Handle:Timer, any:client)
{
        SetEntData(client, OffsetMoney, 0);
}

public _PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
    // Player has died.
    if(IsActive)
    {
        new Victim = GetClientOfUserId(GetEventInt(event, "userid"));
        new Killer = GetClientOfUserId(GetEventInt(event, "attacker"));

        /* Clear money off from the killer so they can't buy anything */
        // KLUGE: It seems like player got money AFTER player_death
        CreateTimer(0.1, DelayClearMoney, Killer);

        /* They change team at round end don't punish them. */
        if(!RoundStarted)
            return;

        decl String:Weapon[24], String:vName[MAX_NAME_SIZE], String:kName[MAX_NAME_SIZE];

        GetEventString(event, "weapon", Weapon, sizeof(Weapon));
        GetClientName(Victim, vName, sizeof(vName));
        GetClientName(Killer, kName, sizeof(kName));


        /* Kill self with world spawn */
        if(WorldspawnSuicide && Victim && !Killer)
        {
            ClientSuicide(Victim, vName);
            return;
        }

        if(CommitSuicide)
        {
            /* They killed themself by kill command*/
            if(Victim == Killer && Weapon[0] == 'w')
            {
                /* ie ... kill command */
                ClientSuicide(Victim, vName);
                return;
            }
        }

        /* They killed themself with probably with grenade. Don't allow them to level up if so. */
        if(Victim == Killer && Weapon[0] != 'w')
        {
            return;
        }

        new bool:TeamKill;

        if(Victim != Killer && GetConVarInt(mp_friendlyfire) && GetClientTeam(Victim) == GetClientTeam(Killer))
        {
            /* Stop them from gaining a point or level by killing their team mate. */
            TeamKill = true;
        }

        new Weapons:WeaponIndex = UTIL_GetWeaponIndex(Weapon), ret;

        Call_StartForward(FwdDeath);
        Call_PushCell(Killer);
        Call_PushCell(Victim);
        Call_PushCell(WeaponIndex);
        Call_PushCell(TeamKill);
        Call_Finish(ret);

        if(ret || TeamKill)
        {
            return;
        }

        new level = PlayerLevel[Killer], Weapons:WeaponLevel = WeaponOrderId[level];

        /**
         * How to deal with with giving them more nades if KnifePro is enabled?
         * Because they will steal a level and the WeapoderOrderId will be off.
         * So it won't give them another nade.
         */

        /* Give them another grenade if they killed another person with another weapon or hegrenade with the option enabled*/
        if(ExtraNade && WeaponLevel == CSW_HEGRENADE)
        {
            /* Do not give them another nade if they already have one */
            if(UTIL_FindGrenadeByName(Killer, WeaponName[CSW_HEGRENADE]) == -1)
            {
                GivePlayerItem(Killer, WeaponName[CSW_HEGRENADE]);
            }
        }

        if(MaxLevelPerRound && CurrentLevelPerRound[Killer] >= MaxLevelPerRound)
        {
            return;
        }

        /**
         * Do not let them skip steal level if they are on knife level
         * I wonder if not to allow them to skip level if they are on nade level
         * Steal level from other player.
         */
        if(KnifePro && WeaponIndex == CSW_KNIFE && WeaponLevel != CSW_KNIFE)
        {
            if(!KnifeProHE && WeaponLevel == CSW_HEGRENADE && !CanLevelDownOnGrenade)
            {
                return;
            }

            new Level = PlayerLevel[Victim];

            if(Level >= KnifeProMinLevel)
            {
                if(Level || CanStealFirstLevel)
                {
                    new bool:Ret;
                    if ( Level )
                    {
                        new newLevelVictim = UTIL_ChangeLevel(Victim, -1, Ret, true, true);

                        if(Ret)
                        {
                            return;
                        }                        
                        PrintLeaderToChat(Victim, Level, newLevelVictim, vName);
                    }

                    Ret = false;

                    if ( KnifeProHE || WeaponLevel != CSW_HEGRENADE )
                    {
                        if ( !BotCanWin && IsFakeClient(Killer) && (level >= WeaponOrderCount - 1) )
                        {
                            /* Bot can't win so just keep them at the last level */
                            return;
                        }

                        new oldLevelKiller = level;
                        level = UTIL_ChangeLevel(Killer, 1, Ret, true, true);

                        if(Ret)
                        {
                            return;
                        }
                        PrintLeaderToChat(Killer, oldLevelKiller, level, kName);
                    }

                    new String:msg[MAX_CHAT_SIZE];
                    Format(msg, sizeof(msg), "%c[%cGunGame%c] %c%s%c has stolen a level from %c%s",
                        GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, isColorMsg ? TEAMCOLOR : YELLOW, kName, GREEN, YELLOW, vName);
                    CHAT_SayText(0, Killer, msg);

                    /* Need to reset CurrentKillsPerWeap[killer] to zero since they stole a level. */
                    /* Or reset on next round/spawn */
                    CurrentKillsPerWeap[Killer] = NULL;
                    CurrentLevelPerRound[Killer]++;

                    UTIL_PlaySound(Killer, Steal);
                    UTIL_PlaySound(Victim, Down);
                    
                    if ( KnifeProHE || WeaponLevel != CSW_HEGRENADE )
                    {
                        if(TurboMode)
                        {
                            UTIL_GiveNextWeapon(Killer, level);
                        } else if(TripleLevelBonus && CurrentLevelPerRound[Killer] == 3) {

                            decl String:Name[MAX_NAME_SIZE];
                            GetClientName(Killer, Name, sizeof(Name));

                            new String:cmsg[MAX_CHAT_SIZE];
                            Format(cmsg, sizeof(cmsg), "%c[%cGunGame%c] %c%s %ctriple leveled!!!",
                                GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, isColorMsg ? TEAMCOLOR : YELLOW, Name, GREEN);
                            CHAT_SayText(0, Killer, cmsg);

                            CreateTimer(10.0, RemoveBonus, Killer);
                            UTIL_SetClientGodMode(Killer, 1);
                            SetEntDataFloat(Killer, OffsetMovement, 1.5);

                            EmitSoundToAll(EventSounds[Triple], Killer, SNDCHAN_BODY);
                        }
                    }

                } else {
                    /* They are at level 1. Internally it is set at 0 for starting
                     * Levels only can be stolen if victim is level greater than 1.
                     */

                    new String:msg[MAX_CHAT_SIZE];
                    Format(msg, sizeof(msg), "%c[%cGunGame%c] %c%s%c has no levels to be stolen.",
                        GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, isColorMsg ? TEAMCOLOR : YELLOW, vName, GREEN);
                    CHAT_SayText(Killer, Victim, msg);
                }
            } else {
                new String:msg[MAX_CHAT_SIZE];
                Format(msg, sizeof(msg), "%c[%cGunGame%c] %c%s%c is lower than the minimum knife stealing level. They must be aleast %c%d%c level before you can steal.",
                        GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, isColorMsg ? TEAMCOLOR : YELLOW, vName, GREEN, YELLOW, KnifeProMinLevel, GREEN);
                CHAT_SayText(Killer, Victim, msg);
            }

            return;
        }

        /* They didn't kill with the weapon required */
        if(WeaponIndex != WeaponLevel)
        {
            return;
        }

        new temp = CustomKillPerLevel[WeaponIndex] ? CustomKillPerLevel[WeaponIndex] : MinKillsPerLevel,
            kills = ++CurrentKillsPerWeap[Killer], Handled;

        /* Need to look over this */
        if(kills <= temp)
        {
            Call_StartForward(FwdPoint);
            Call_PushCell(Killer);
            Call_PushCell(kills);
            Call_PushCell(1);
            Call_Finish(Handled);

            if(Handled)
            {
                CustomKillPerLevel[WeaponIndex]--;
                return;
            }

            if(kills < temp)
            {
                PrintToChat(Killer, "%c[%cGunGame%c] You need %c%d%c kills to advance to the next level :: Score: %c%d%c /%c %d",
                    GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, YELLOW, MinKillsPerLevel, GREEN, YELLOW, kills, GREEN, YELLOW, temp);

                UTIL_PlaySound(Killer, MultiKill);
                return;
            }
        } else {
            return;
        }

        CurrentKillsPerWeap[Killer] = NULL;
        CurrentLevelPerRound[Killer]++;

        if(KnifeElite)
        {
            PlayerState[Killer] |= KNIFE_ELITE;
        }

        if ( !BotCanWin && IsFakeClient(Killer) && (level >= WeaponOrderCount - 1) )
        {
            /* Bot can't win so just keep them at the last level */
            return;
        }
        
        new bool:Stop;
        new oldLevelKiller = level;
        level = UTIL_ChangeLevel(Killer, 1, Stop);

        if ( Stop || level >= WeaponOrderCount )
        {
            return;
        }
        PrintLeaderToChat(Killer, oldLevelKiller, level, kName);

        if(TurboMode)
        {
            UTIL_GiveNextWeapon(Killer, level);
        }

    }
}

// Player has spawned
public _PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(!IsActive)
    {
        return;
    }

    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if(!client)
    {
        return;
    }

    new team = GetClientTeam(client);

    if(team != TEAM_T && team != TEAM_CT)
    {
        return;
    }

    /* Reset Knife Elite state */
    if(KnifeElite)
    {
        PlayerState[client] &= ~KNIFE_ELITE;
    }

    /* Set money to 0. */
    SetEntData(client, OffsetMoney, 0);

    /* They are not alive don't proccess */
    if(!IsPlayerAlive(client))
    {
        return;
    }

    if(!(PlayerState[client] & FIRST_JOIN))
    {
        PlayerState[client] |= FIRST_JOIN;

        if(!IsFakeClient(client))
        {
            UTIL_PlaySound(client, Welcome);

            /**
             * Show join message.
             */

            if ( JoinMessage )
            {
                if ( !JoinMsgPanel )
                {
                    JoinMsgPanel = CreateJoinMsgPanel();
                }

                SendPanelToClient(JoinMsgPanel, client, EmptyHandler, GUNGAME_MENU_TIME);
            }
        }
    }

    /* Set armor to 100. */
    SetEntData(client, OffsetArmor, 100);
    /* Set user with helm. */
    SetEntData(client, OffsetHelm, 1);

    CurrentLevelPerRound[client] = NULL;

    if(team == TEAM_CT)
    {
        if(MapStatus & OBJECTIVE_BOMB && !(MapStatus & OBJECTIVE_REMOVE_BOMB))
        {
            // Give them a defuser if objective is not removed
            SetEntData(client, OffsetDefuser, 1);
        }
    }

    UTIL_ForceDropAllWeapon(client, IsDmActive ? false : true);

    /* A check to make sure player always has a knife because some maps do not give the knife. */
    new knife = GetPlayerWeaponSlot(client, _:Slot_Knife);

    if(knife == -1)
    {
        GivePlayerItem(client, "weapon_knife");
    }

    /* Something here is wrong */
    if(WarmupEnabled)
    {
        if(!WarmupInitialized)
        {
            PrintToChat(client, "%c[%cGunGame%c] Warmup round has not started yet.", GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN);
        } else {
            PrintToChat(client, "%c[%cGunGame%c] Warmup round is in progress.", GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN);
        }

        if(WarmupKnifeOnly)
            return;
    }

    /* For deathmatch when they get respawn after round start freeze after game winner. */
    if(GameWinner)
    {
        new flags = GetEntData(client, OffsetFlags) | FL_FROZEN;
        SetEntData(client, OffsetFlags, flags);
    }

    new Level = PlayerLevel[client];

    if(Level >= WeaponOrderCount)
    {
        return;
    }

    new Weapons:WeapId = WeaponOrderId[Level], Custom = CustomKillPerLevel[WeapId];

    Custom = (Custom) ? Custom : MinKillsPerLevel;

    PrintToChat(client, "%c[%cGunGame%c] You are on level %c%i %c:: %c%s",
        GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, YELLOW, Level + 1, GREEN, YELLOW, WeaponName[WeapId][7]);

    if ( Custom > 1 )
    {
        PrintToChat(client, "%c[%cGunGame%c] You need %c%d%c kills to advance to the next level :: Score: %c%d %c/%c %d",
            GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, YELLOW, Custom, GREEN, YELLOW, CurrentKillsPerWeap[client], GREEN, YELLOW, Custom);
    }
    
    new pState = PlayerState[client];

    if(AutoFriendlyFire && (pState & GRENADE_LEVEL) && WeapId != CSW_HEGRENADE)
    {
        PlayerState[client] &= ~GRENADE_LEVEL;

        if(--PlayerOnGrenade < 1)
        {
            UTIL_ChangeFriendlyFire(false);
        }
    }

    if(WeapId == CSW_HEGRENADE)
    {
        if(AutoFriendlyFire && !GetConVarInt(mp_friendlyfire))
        {
            if(!(pState & GRENADE_LEVEL))
            {
                PlayerOnGrenade++;
            }

            PlayerState[client] |= GRENADE_LEVEL;

            UTIL_ChangeFriendlyFire(true);
            PrintToChatAll("%c[%cGunGame%c] Friendly Fire has been enabled", GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN);

            UTIL_PlaySound(0, AutoFF);
        }

        if(NadeGlock)
        {
            new ent = GivePlayerItem(client, WeaponName[CSW_GLOCK]);

            if(ent != -1)
            {
                new iAmmo = HACK_GetAmmoType(ent);

                if(iAmmo != -1)
                {
                    new Handle:Info = CreateDataPack();
                    WritePackCell(Info, client);
                    WritePackCell(Info, iAmmo);
                    ResetPack(Info);

                    CreateTimer(0.1, DelayAmmoRemove, Info, TIMER_HNDL_CLOSE);
                }
            }
        }

        GivePlayerItem(client, WeaponName[CSW_HEGRENADE]);

        //Switch them back into hegrenade
        FakeClientCommand(client, "use %s", WeaponName[CSW_HEGRENADE]);

        if(NadeSmoke)
        {
            GivePlayerItem(client, WeaponName[CSW_SMOKEGRENADE]);
        }

        if(NadeFlash)
        {
            GivePlayerItem(client, WeaponName[CSW_FLASHBANG]);
        }

    /* No reason to give them knife again.  */
    } else if(WeapId != CSW_KNIFE) {
        GivePlayerItem(client, WeaponName[WeapId]);
    }
}

/**
 * This function was created because of the dynamic pricing that was updated in the
 * recent Source update. They are giving full ammo no matter if mp_dynamicpricing was 0 or 1.
 * So I had to delay reseting the hegrenade with glock to 50 bullets by 0.2
 */
public Action:DelayAmmoRemove(Handle:timer, Handle:data)
{
    new client = ReadPackCell(data);

    if(IsClientInGame(client))
    {
        HACK_RemoveAmmo(client, 90, ReadPackCell(data));
    }
}

public _BombState(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(IsActive && ObjectiveBonus && GameCommenced && RoundStarted)
    {
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

        if(client)
        {
            if(!ObjectiveBonusWin && PlayerLevel[client] >= WeaponOrderCount - 1)
            {
                return;
            }

            /* Give them a level if give level for objective */
            new oldLevel = PlayerLevel[client];
            new newLevel = UTIL_ChangeLevel(client, ObjectiveBonus);
            decl String:cname[MAX_NAME_SIZE];
            if ( client && IsClientConnected(client) && IsClientInGame(client) )
            {
                GetClientName(client, cname, sizeof(cname));
            }
            else
            {
                Format(cname, sizeof(cname), "[Client#%d]", client);
            }
            PrintLeaderToChat(client, oldLevel, newLevel, cname);

            PrintToChat(client, "%c[%cGunGame%c] You gained %c%d%c level by %s the bomb",
                GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, YELLOW, ObjectiveBonus, GREEN, (name[5] == 'p') ? "planting" : "defusing");
        }
    }
}

public _HostageKilled(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(IsActive && GameCommenced && RoundStarted)
    {
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

        if(client)
        {
            decl String:Name[MAX_NAME_SIZE];
            GetClientName(client, Name, sizeof(Name));

            new oldLevel = PlayerLevel[client];
            new newLevel = UTIL_ChangeLevel(client, -1);
            PrintLeaderToChat(client, oldLevel, newLevel, Name);
            
            new String:msg[MAX_CHAT_SIZE];
            Format(msg, sizeof(msg), "%c[%cGunGame%c] %c%s%c has lost a level by killing a hostage",
                GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, isColorMsg ? TEAMCOLOR : YELLOW, Name, GREEN);
            CHAT_SayText(0, client, msg);
        }
    }
}

stock ClientSuicide(client, const String:Name[])
{
    new String:msg[MAX_CHAT_SIZE];
    Format(msg, sizeof(msg), "%c[%cGunGame%c] %c%s%c has lost a level by suicided.",
        GREEN, isColorMsg ? YELLOW : TEAMCOLOR, GREEN, isColorMsg ? TEAMCOLOR : YELLOW, Name, GREEN);
    CHAT_SayText(0, client, msg);

    new oldLevel = PlayerLevel[client];
    new newLevel = UTIL_ChangeLevel(client, -1);
    PrintLeaderToChat(client, oldLevel, newLevel, Name);
}

public Action:RemoveBonus(Handle:timer, any:client)
{
    if(IsClientInGame(client) && IsPlayerAlive(client))
    {
        UTIL_SetClientGodMode(client, 0);
        SetEntDataFloat(client, OffsetMovement, 1.0);
    }
}

public DM_Handler(Handle:convar, const String:oldValue[], const String:newValue[])
{
    IsDmActive = (StringToInt(newValue) == 0) ? false : true;
}
