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
    HookEvent("hegrenade_detonate",_HeExplode);

    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    //HookUserMessage(VGUIMenu, _VGuiMenu);
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
    UnhookEvent("hegrenade_detonate",_HeExplode);

    // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
    //UnhookUserMessage(VGUIMenu, _VGuiMenu);
}

// TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
/*
public Action:_VGuiMenu(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
    // Check if init is always false after the first call.
    if(!IsActive || IsIntermissionCalled || !IntermissionCalcWinner)
    {
        return;
    }

    decl String:Type[24];
    BfReadString(bf, Type, sizeof(Type));

    if(BfReadByte(bf) == 1 && BfReadByte(bf) == 0 && strcmp(Type, "scores", false) == 0)
    {
        IsIntermissionCalled =  true;

        // Do intermission calculation if a winner wasn't declared by completing the weapon order.
        if(!GameWinner)
        {
            // No decisive winner has completed the game.
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
                    // No real player was found
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
                        new g =  team == TEAM_CT ? 128 : (team == TEAM_T ? 0 : 255);
                        new b = (team == TEAM_CT ? 255 : 0);
                        UTIL_PrintToUpperLeft(0, r, g, b, "%t", "Has won", Name);
                    }

                    Call_StartForward(FwdWinner);
                    Call_PushCell(GameWinner);
                    Call_PushString(WeaponName[WeaponOrderId[level]][7]);
                    Call_Finish();

                    UTIL_PlaySound(0, Winner);
                    if ( AlltalkOnWin )
                    {
                        new Handle:sv_alltalk = FindConVar("sv_alltalk");
                        if ( sv_alltalk != INVALID_HANDLE )
                        {
                            SetConVarInt(sv_alltalk,1);
                        }
                    }
                }
            }
            // else no leader was found so no winner.
        }
    }
}
*/

public _ItemPickup(Handle:event, const String:name[], bool:dontBroadcast)
{
    if ( !IsActive )
    {
        return;
    }

    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if ( KnifeElite )
    {
        if ( client && PlayerState[client] & KNIFE_ELITE )
        {
            UTIL_ForceDropAllWeapon(client);
        }
    }

    if ( StripDeadPlayersWeapon && !g_IsInGiveCommand )
    {
        decl String:Weapon[24];
        GetEventString(event, "item", Weapon, sizeof(Weapon));
        new Weapons:WeapId = UTIL_GetWeaponIndex(Weapon);
        if ( WeapId != Weapons:0 )
        {
            new Slots:slot = WeaponSlot[WeapId];
            if ( slot == Slot_Primary || slot == Slot_Secondary ) 
            {
                g_ClientSlotEnt[client][slot] = GetPlayerWeaponSlot(client, _:slot);
            }
        }
    }
}

public _BombPickup(Handle:event, const String:name[], bool:dontBroadcast)
{
    if(IsActive && MapStatus & OBJECTIVE_REMOVE_BOMB)
    {
        new client = GetClientOfUserId(GetEventInt(event, "userid"));

        if(client)
        {
            UTIL_ForceDropWeaponBySlot(client, Slot_C4);
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
                SetConVarInt(mp_restartgame, 1);
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

            if( (edict > 0) && IsValidEntity(edict) )
            {
                RemoveEdict(edict);
                SetEntData(HostageEntInfo, OffsetHostage + (i * 4), 0, _, true);

            } else {
                break;
            }
        }
    }
}

public _PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
    // Player has died.
    if ( !IsActive )
    {
        return;
    }
    
    new Victim = GetClientOfUserId(GetEventInt(event, "userid"));
    UTIL_RemoveClientDroppedWeapons(Victim);
    
    /* They change team at round end don't punish them. */
    if ( !RoundStarted && !AllowLevelUpAfterRoundEnd )
    {
        return;
    }
    
    new Killer = GetClientOfUserId(GetEventInt(event, "attacker"));
    decl String:Weapon[24], String:vName[MAX_NAME_SIZE], String:kName[MAX_NAME_SIZE];

    GetEventString(event, "weapon", Weapon, sizeof(Weapon));
    GetClientName(Victim, vName, sizeof(vName));
    GetClientName(Killer, kName, sizeof(kName));

    /* Kill self with world spawn */
    if ( Victim && !Killer )
    {
        if ( WorldspawnSuicide )
        {
            ClientSuicide(Victim, vName);
        }
        return;
    }

    /* They killed themself by kill command or by hegrenade etc */
    if ( Victim == Killer ) 
    {
        /* (Weapon is event weapon name, can be 'world' or 'hegrenade' etc) */
        if ( CommitSuicide && ( RoundStarted || /* weapon is not 'world' (ie not kill command) */ Weapon[0] != 'w') )
        {
            ClientSuicide(Victim, vName);
        }
        return;
    }

    // Victim > 0 && Killer > 0

    new bool:TeamKill;

    if ( GetConVarInt(mp_friendlyfire) && GetClientTeam(Victim) == GetClientTeam(Killer) )
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

    if ( ret || TeamKill )
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
    if ( ExtraNade && WeaponLevel == CSW_HEGRENADE && WeaponIndex != CSW_HEGRENADE )
    {
        /* Do not give them another nade if they already have one */
        if ( UTIL_FindGrenadeByName(Killer, WeaponName[CSW_HEGRENADE]) == -1 )
        {
            GivePlayerItemWrapper(Killer, WeaponName[CSW_HEGRENADE]);
        }
    }

    if ( MaxLevelPerRound && CurrentLevelPerRound[Killer] >= MaxLevelPerRound )
    {
        return;
    }

    /**
     * Steal level from other player.
     */
    if ( KnifePro && WeaponIndex == CSW_KNIFE )
    {
        new KnifeLevel = (WeaponLevel == CSW_KNIFE);
        for (;;)
        {
            if ( !KnifeProHE && WeaponLevel == CSW_HEGRENADE && !CanLevelDownOnGrenade )
            {
                return;
            }

            new VictimLevel = PlayerLevel[Victim];

            if ( VictimLevel < KnifeProMinLevel )
            {
                CPrintToChatEx(Killer, Victim, "%t", "Is lower than the minimum knife stealing level", vName, KnifeProMinLevel);
                if ( KnifeLevel ) {
                    break;
                } else {
                    return;
                }
            }

            if ( !VictimLevel && !CanStealFirstLevel )
            {
                /* They are at level 1. Internally it is set at 0 for starting
                 * Levels only can be stolen if victim is level greater than 1.
                 */
                CPrintToChatEx(Killer, Victim, "%t", "Has no levels to be stolen", vName);
                if ( KnifeLevel ) {
                    break;
                } else {
                    return;
                }
            }

            if ( VictimLevel )
            {
                new ChangedLevel = UTIL_ChangeLevel(Victim, -1, true);
                if ( ChangedLevel == VictimLevel )
                {
                    if ( KnifeLevel ) {
                        break;
                    } else {
                        return;
                    }
                }

                CPrintToChatAllEx(Killer, "%t", "Has stolen a level from", kName, vName);
            }

            if ( KnifeLevel )
            {
                break;
            }

            if ( !KnifeProHE && WeaponLevel == CSW_HEGRENADE )
            {
                return;
            }

            new oldLevelKiller = level;
            level = UTIL_ChangeLevel(Killer, 1, true);

            if ( oldLevelKiller == level || GameWinner )
            {
                return;
            }

            PrintLeaderToChat(Killer, oldLevelKiller, level, kName);
            CurrentLevelPerRound[Killer]++;
                   
            if ( TurboMode )
            {
                UTIL_GiveNextWeapon(Killer, level);
            }

            CheckForTripleLevel(Killer);

            return;
        }
    }

    /* They didn't kill with the weapon required */
    if ( WeaponIndex != WeaponLevel )
    {
        return;
    }
    
    new killsPerLevel = CustomKillPerLevel[level];
    if ( !killsPerLevel )
    {
        killsPerLevel = MinKillsPerLevel;
    }
    new kills = ++CurrentKillsPerWeap[Killer], Handled;

    if ( kills <= killsPerLevel )
    {
        Call_StartForward(FwdPoint);
        Call_PushCell(Killer);
        Call_PushCell(kills);
        Call_PushCell(1);
        Call_Finish(Handled);

        if ( Handled )
        {
            CurrentKillsPerWeap[Killer]--;
            return;
        }

        if ( kills < killsPerLevel )
        {
            if ( MultiKillChat )
            {
                CPrintToChat(Killer, "%t", "You need kills to advance to the next level", killsPerLevel - kills, kills, killsPerLevel);
            }
            UTIL_PlaySound(Killer, MultiKill);
            if ( ReloadWeapon )
            {
                UTIL_ReloadActiveWeapon(Killer, WeaponLevel);
            }
            return;
        }
    }
    
    // reload weapon
    if ( !TurboMode && ReloadWeapon )
    {
        UTIL_ReloadActiveWeapon(Killer, WeaponLevel);
    }
    
    if ( KnifeElite )
    {
        PlayerState[Killer] |= KNIFE_ELITE;
    }

    new oldLevelKiller = level;
    level = UTIL_ChangeLevel(Killer, 1);

    if ( oldLevelKiller == level || GameWinner )
    {
        return;
    }

    CurrentLevelPerRound[Killer]++;

    PrintLeaderToChat(Killer, oldLevelKiller, level, kName);

    if ( TurboMode )
    {
        UTIL_GiveNextWeapon(Killer, level);
    }

    CheckForTripleLevel(Killer);
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

    CurrentLevelPerRound[client] = 0;
    CurrentLevelPerRoundTriple[client] = 0;

    if(team == TEAM_CT)
    {
        if(MapStatus & OBJECTIVE_BOMB && !(MapStatus & OBJECTIVE_REMOVE_BOMB))
        {
            // Give them a defuser if objective is not removed
            SetEntData(client, OffsetDefuser, 1);
        }
    }

    UTIL_ForceDropAllWeapon(client, true);

    /* A check to make sure player always has a knife because some maps do not give the knife. */
    new knife = GetPlayerWeaponSlot(client, _:Slot_Knife);

    if(knife == -1)
    {
        GivePlayerItemWrapper(client, "weapon_knife");
    }

    /* Something here is wrong */
    if ( WarmupEnabled )
    {
        // Disable warmup
        if ( DisableWarmupOnRoundEnd )
        {
            WarmupEnabled = false;
            DisableWarmupOnRoundEnd = false;
        }
        else
        {
            if ( !WarmupInitialized )
            {
                CPrintToChat(client, "%t", "Warmup round has not started yet");
            }
            else
            {
                CPrintToChat(client, "%t", "Warmup round is in progress");
            }

            if ( WarmupNades )
            {
                GivePlayerItemWrapper(client, WeaponName[CSW_HEGRENADE]);

                //Switch them back into hegrenade
                FakeClientCommand(client, "use %s", WeaponName[CSW_HEGRENADE]);
            }
            
            if ( WarmupNades || WarmupKnifeOnly )
            {
                return;
            }
        }
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

    new Weapons:WeapId = WeaponOrderId[Level], killsPerLevel = CustomKillPerLevel[Level];
    
    if ( !killsPerLevel )
    {
        killsPerLevel = MinKillsPerLevel;
    }

    if ( !WarmupEnabled || !WarmupReset )
    {
        CPrintToChat(client, "%t", "You are on level", Level + 1, WeaponName[WeapId][7]);
    }

    if ( killsPerLevel > 1 )
    {
        new kills = CurrentKillsPerWeap[client];
        if ( MultiKillChat )
        {
            CPrintToChat(client, "%t", "You need kills to advance to the next level", killsPerLevel - kills, kills, killsPerLevel);
        }
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
            CPrintToChatAll("%t", "Friendly Fire has been enabled");

            UTIL_PlaySound(0, AutoFF);
        }

        if ( NadeBonusWeaponId )
        {
            new ent = GivePlayerItemWrapper(client, WeaponName[NadeBonusWeaponId]);
            new Slots:slot = WeaponSlot[NadeBonusWeaponId];
            if ( slot == Slot_Primary || slot == Slot_Secondary ) 
            {
                g_ClientSlotEnt[client][slot] = ent;
            }
            // Remove bonus weapon ammo! So player can not reload weapon!
            if ( (ent != -1) && RemoveBonusWeaponAmmo ) 
            {
                new iAmmo = HACK_GetAmmoType(ent);

                if(iAmmo != -1)
                {
                    new Handle:Info = CreateDataPack();
                    WritePackCell(Info, client);
                    WritePackCell(Info, iAmmo);
                    ResetPack(Info);

                    CreateTimer(0.1, UTIL_DelayAmmoRemove, Info, TIMER_HNDL_CLOSE);
                }
            }
        }

        GivePlayerItemWrapper(client, WeaponName[CSW_HEGRENADE]);

        //Switch them back into hegrenade
        FakeClientCommand(client, "use %s", WeaponName[CSW_HEGRENADE]);

        if(NadeSmoke)
        {
            GivePlayerItemWrapper(client, WeaponName[CSW_SMOKEGRENADE]);
        }

        if(NadeFlash)
        {
            GivePlayerItemWrapper(client, WeaponName[CSW_FLASHBANG]);
        }

    /* No reason to give them knife again.  */
    } else if(WeapId != CSW_KNIFE) {
        new ent = GivePlayerItemWrapper(client, WeaponName[WeapId]);
        new Slots:slot = WeaponSlot[WeapId];
        if ( slot == Slot_Primary || slot == Slot_Secondary ) 
        {
            g_ClientSlotEnt[client][slot] = ent;
        }
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
            if ( newLevel == oldLevel) 
            {
                return;
            }
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

            CPrintToChat(client, "%t", "You gained level by the bomb", ObjectiveBonus, (name[5] == 'p') ? "planting" : "defusing");
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
            if ( oldLevel == newLevel )
            {
                return;
            }
            PrintLeaderToChat(client, oldLevel, newLevel, Name);
            
            CPrintToChatAllEx(client, "%t", "Has lost a level by killing a hostage", Name);
        }
    }
}

stock ClientSuicide(client, const String:Name[])
{
    CPrintToChatAllEx(client, "%t", "Has lost a level by suicided", Name);

    new oldLevel = PlayerLevel[client];
    new newLevel = UTIL_ChangeLevel(client, -1);
    PrintLeaderToChat(client, oldLevel, newLevel, Name);
}

public Action:RemoveBonus(Handle:timer, any:client)
{
    CurrentLevelPerRoundTriple[client] = 0;
    if(IsClientInGame(client) && IsPlayerAlive(client))
    {
        UTIL_SetClientGodMode(client, 0);
        SetEntDataFloat(client, OffsetMovement, 1.0);
    }
}

public _HeExplode(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    new level = PlayerLevel[client];
    new Weapons:WeaponLevel = WeaponOrderId[level];
    new String:weaponName[24];
    strcopy(weaponName, sizeof(weaponName), WeaponName[CSW_HEGRENADE]);
    
    if ( !IsClientInGame(client) || !IsPlayerAlive(client) )
    {
        return;
    }

    if ( (UnlimitedNades && WeaponLevel == CSW_HEGRENADE) 
        || (WarmupNades && WarmupEnabled) )
    {
        /* Do not give them another nade if they already have one */
        if ( UTIL_FindGrenadeByName(client, weaponName) == -1 )
        {
            GivePlayerItemWrapper(client, weaponName);
            FakeClientCommand(client, "use %s", weaponName);
        }
    }
}

CheckForTripleLevel(client)
{
    CurrentLevelPerRoundTriple[client]++;
    if ( TripleLevelBonus && CurrentLevelPerRoundTriple[client] == 3 )
    {
        decl String:Name[MAX_NAME_SIZE];
        GetClientName(client, Name, sizeof(Name));

        CPrintToChatAllEx(client, "%t", "Triple leveled", Name);

        CreateTimer(10.0, RemoveBonus, client);
        UTIL_SetClientGodMode(client, 1);
        SetEntDataFloat(client, OffsetMovement, 1.5);

        EmitSoundToAll(EventSounds[Triple], client, SNDCHAN_BODY);
    }
}
