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
    new oldTeam         = GetEventInt(event, "oldteam");
    new newTeam         = GetEventInt(event, "team");
    new bool:disconnect = GetEventBool(event, "disconnect");
    switch ( oldTeam )
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
    if ( !disconnect )
    {
        switch ( newTeam )
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

    if ( UnlimitedNadesMinPlayers )
    {
        UnlimitedNades = ( Tcount <= UnlimitedNadesMinPlayers || CTcount <= UnlimitedNadesMinPlayers );
    }

    /* If one of the counts goes to 0 that means game is not commenced any more */
    if ( !CTcount || !Tcount )
    {
        GameCommenced = false;
    }

    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    if ( client && !disconnect && (oldTeam >= 2) && (newTeam < 2) && IsClientInGame(client) && IsPlayerAlive(client) )
    {
        UTIL_RemoveClientDroppedWeapons(client, true);
        UTIL_StopTripleEffects(client);
    }
    if ( !client || disconnect || (oldTeam < 2) || (newTeam < 2) || !IsPlayerAlive(client) || (oldTeam == newTeam) )
    {
        return;
    }
    g_teamChange[client] = true;
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

            if ( GetEventInt(event, "reason") == 16 )
            {
                GameCommenced = true;
            }

            if ( WarmupEnabled && WarmupRandomWeaponMode == 2 )
            {
                WarmupRandomWeaponLevel = -1;
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
    UTIL_StopTripleEffects(Victim);
    
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
        if ( RoundStarted && WorldspawnSuicide )
        {
            ClientSuicide(Victim, vName);
        }
        return;
    }

    /* They killed themself by kill command or by hegrenade etc */
    if ( Victim == Killer ) 
    {
        /* (Weapon is event weapon name, can be 'world' or 'hegrenade' etc) */
        if ( CommitSuicide && ( RoundStarted || /* weapon is not 'world' (ie not kill command) */ Weapon[0] != 'w') && (!g_teamChange[Victim]) )
        {
            ClientSuicide(Victim, vName);
        }
        return;
    }

    // Victim > 0 && Killer > 0

    new bool:TeamKill = GetClientTeam(Victim) == GetClientTeam(Killer);
    new bool:ForwardTeamKill = !FFA && GetConVarInt(mp_friendlyfire) && TeamKill;

    new Weapons:WeaponIndex = UTIL_GetWeaponIndex(Weapon), ret;

    Call_StartForward(FwdDeath);
    Call_PushCell(Killer);
    Call_PushCell(Victim);
    Call_PushCell(WeaponIndex);
    Call_PushCell(ForwardTeamKill);
    Call_Finish(ret);

    if ( ret || TeamKill )
    {
        return;
    }

    new level = PlayerLevel[Killer], Weapons:WeaponLevel = WeaponOrderId[level];

    // FIXME: If KnifePro && KnifeProHE are enabled then we give extra grenade here, but it is a bug
    /* Give them another grenade if they killed another person with another weapon or hegrenade with the option enabled*/
    if ( WeaponLevel == CSW_HEGRENADE && WeaponIndex != CSW_HEGRENADE )
    {
        UTIL_GiveExtraNade(Killer);
    }

    if ( WarmupEnabled && WarmupReset )
    {
        if ( ReloadWeapon )
        {
            UTIL_ReloadActiveWeapon(Killer, WeaponIndex);
        }
        return;
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

            new ChangedLevel = UTIL_ChangeLevel(Victim, -1, true);
            if ( VictimLevel )
            {
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
                new killsPerLevel = CustomKillPerLevel[level];
                if ( !killsPerLevel )
                {
                    killsPerLevel = MinKillsPerLevel;
                }
                if ( killsPerLevel > 1 )
                {
                    break;
                }
            }

            if ( !KnifeProHE && WeaponLevel == CSW_HEGRENADE )
            {
                return;
            }

            new oldLevelKiller = level;
            level = UTIL_ChangeLevel(Killer, 1, true);
            if ( oldLevelKiller == level )
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
    
    if ( killsPerLevel > 1 )
    {
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
                    decl String:subtext[64];
                    FormatLanguageNumberTextEx(Killer, subtext, sizeof(subtext), killsPerLevel - kills, "points");
                    CPrintToChat(Killer, "%t", "You need kills to advance to the next level", subtext, kills, killsPerLevel);
                }
                UTIL_PlaySound(Killer, MultiKill);
                if ( ReloadWeapon )
                {
                    UTIL_ReloadActiveWeapon(Killer, WeaponLevel);
                }
                return;
            }
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
    if ( oldLevelKiller == level )
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
    if ( !IsActive )
    {
        return;
    }

    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if ( !client )
    {
        return;
    }
    
    g_teamChange[client] = false;
    
    new team = GetClientTeam(client);

    if ( team != TEAM_T && team != TEAM_CT )
    {
        return;
    }

    /* Reset Knife Elite state */
    if ( KnifeElite )
    {
        PlayerState[client] &= ~KNIFE_ELITE;
    }

    /* They are not alive don't proccess */
    if ( !IsPlayerAlive(client) )
    {
        return;
    }

    if ( !(PlayerState[client] & FIRST_JOIN) )
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
                ShowJoinMsgPanel(client);
            }
        }
    }

    /* Set armor to 100. */
    SetEntData(client, OffsetArmor, 100);
    /* Set user with helm. */
    SetEntData(client, OffsetHelm, 1);

    CurrentLevelPerRound[client] = 0;
    CurrentLevelPerRoundTriple[client] = 0;

    if ( team == TEAM_CT )
    {
        if ( MapStatus & OBJECTIVE_BOMB && !(MapStatus & OBJECTIVE_REMOVE_BOMB) )
        {
            // Give them a defuser if objective is not removed
            SetEntData(client, OffsetDefuser, 1);
        }
    }

    UTIL_ForceDropAllWeapon(client, true);

    /* A check to make sure player always has a knife because some maps do not give the knife. */
    new knife = GetPlayerWeaponSlot(client, _:Slot_Knife);
    if ( knife == -1 )
    {
        GivePlayerItemWrapper(client, "weapon_knife");
    }

    /* Many years ago something here was wrong */
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

            if ( UTIL_GiveWarmUpWeapon(client) )
            {
                return;
            }
        }
    }

    /* For deathmatch when they get respawn after round start freeze after game winner. */
    if ( GameWinner )
    {
        new flags = GetEntData(client, OffsetFlags) | FL_FROZEN;
        SetEntData(client, OffsetFlags, flags);
    }

    new Level = PlayerLevel[client];

    if ( Level >= WeaponOrderCount )
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
            decl String:subtext[64];
            FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), killsPerLevel - kills, "points");
            CPrintToChat(client, "%t", "You need kills to advance to the next level", subtext, kills, killsPerLevel);
        }
    }

    UTIL_GiveNextWeapon(client, Level, false);
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
            if ( newLevel == oldLevel )
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

            decl String:subtext[64];
            FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), ObjectiveBonus, "levels");
            if ( name[5] == 'p' )
            {
                CPrintToChat(client, "%t", "You gained level by planting the bomb", subtext);
            }
            else
            {
                CPrintToChat(client, "%t", "You gained level by defusing the bomb", subtext);
            }
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

ClientSuicide(client, const String:Name[])
{
    new oldLevel = PlayerLevel[client];
    new newLevel = UTIL_ChangeLevel(client, -1);
    if ( oldLevel == newLevel )
    {
        return;
    }
    CPrintToChatAllEx(client, "%t", "Has lost a level by suicided", Name);
    PrintLeaderToChat(client, oldLevel, newLevel, Name);
}

public _HeExplode(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    if ( !IsClientInGame(client) || !IsPlayerAlive(client) )
    {
        return;
    }

    if ( ( WarmupNades && WarmupEnabled )
         || ( WeaponOrderId[PlayerLevel[client]] == CSW_HEGRENADE && UnlimitedNades ) )
    {
        /* Do not give them another nade if they already have one */
        if ( UTIL_FindGrenadeByName(client, WeaponName[CSW_HEGRENADE]) == -1 )
        {
            GivePlayerItemWrapper(client, WeaponName[CSW_HEGRENADE]);
            FakeClientCommand(client, "use %s", WeaponName[CSW_HEGRENADE]);
        }
    }
}

