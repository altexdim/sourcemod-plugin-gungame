UTIL_FindMapObjective()
{
    new i = FindEntityByClassname(-1, "func_bomb_target");
    
    if(i > MaxClients)
    {
        MapStatus |= OBJECTIVE_BOMB;
    } else {
        if((i = FindEntityByClassname(-1, "info_bomb_target")) > MaxClients)
        {
            MapStatus |= OBJECTIVE_BOMB;
        }
    }
    
    if((i = FindEntityByClassname((i = 0), "hostage_entity")) > MaxClients)
    {
        MapStatus |= OBJECTIVE_HOSTAGE;
    }
    
    HostageEntInfo = FindEntityByClassname(-1, "cs_player_manager");
}

stock UTIL_ConvertWeaponToIndex()
{
    for(new i, Weapons:b; i < WeaponOrderCount; i++)
    {
        /**
         * Found empty weapon name
         * Probably no more weapons since this one is empty.
         */
        if(!WeaponOrderName[i][0])
            break;

        UTIL_StringToLower(WeaponOrderName[i]);

        /* Future hash/tries or something lookup */
        if(!(b = UTIL_GetWeaponIndex(WeaponOrderName[i])))
        {
            LogMessage("[GunGame] *** FATAL ERROR *** Weapon Order has an invalid entry :: name %s :: level %d", WeaponOrderName[i], i + 1);
        }

        WeaponOrderId[i] = b;
    }
}

stock UTIL_PrintToClient(client, type, const String:szMsg[], any:...)
{
    if(client && IsFakeClient(client))
    {
        return;
    }

    decl String:Buffer[256];
    VFormat(Buffer, sizeof(Buffer), szMsg, 4);

    Buffer[192] = '\0';

    new String:MsgType[] = "TextMsg";
    new Handle:Chat = (!client) ? StartMessageAll(MsgType) : StartMessageOne(MsgType, client);

    if(Chat != INVALID_HANDLE)
    {
        BfWriteByte(Chat, type);
        BfWriteString(Chat, Buffer);
        EndMessage();
    }
}

UTIL_PrintToUpperLeft(r, g, b, const String:source[], any:...)
{
    decl String:Buffer[64];
    new Handle:Msg;
    for ( new i = 1; i <= MaxClients; i++ ) {
        if ( IsClientInGame(i) && !IsFakeClient(i) ) {
            SetGlobalTransTarget(i);
            VFormat(Buffer, sizeof(Buffer), source, 5);
            Msg = CreateKeyValues("msg");

            if ( Msg != INVALID_HANDLE ) {
                KvSetString(Msg, "title", Buffer);
                KvSetColor(Msg, "color", r, g, b, 255);
                KvSetNum(Msg, "level", 0);
                KvSetNum(Msg, "time", 20);

                CreateDialog(i, Msg, DialogType_Msg);

                CloseHandle(Msg);
            }
        }
    }
}

/* Weapon Index Lookup via KeyValue */
/* Figure out hash table later for lookup table */
/*
Weapons:UTIL_GetWeaponIndex(const String:Weapon[])
{
    new len;

    if(strlen(Weapon) > 7)
    {
        // Only check truncated weapon names
        len = (Weapon[6] == '_') ? 7 : 0;
    }

    if(WeaponOpen)
    {
        KvRewind(KvWeapon);

        if(KvJumpToKey(KvWeapon, Weapon[len]))
        {
            return Weapons:KvGetNum(KvWeapon, "index");
        }
    }

    return CSW_NONE;
}
*/

/* Weapon Index Lookup via Trie array */
Weapons:UTIL_GetWeaponIndex(const String:Weapon[])
{
    new len;

    if ( strlen(Weapon) > 7 )
    {
        /* Only check truncated weapon names */
        len = (Weapon[6] == '_') ? 7 : 0;
    }

    if ( WeaponOpen )
    {
        new Weapons:index;
        if ( GetTrieValue(TrieWeapon, Weapon[len], index) )
        {
            return index;
        }
    }

    return CSW_NONE;
}

stock UTIL_CopyC(String:Dest[], len, const String:Source[], ch)
{
    new i = -1;
    while(++i < len && Source[i] && Source[i] != ch)
    {
        Dest[i] = Source[i];
    }
}

UTIL_ChangeFriendlyFire(bool:Status)
{
    new flags = GetConVarFlags(mp_friendlyfire);

    SetConVarFlags(mp_friendlyfire, flags &= ~FCVAR_SPONLY|FCVAR_NOTIFY);
    SetConVarInt(mp_friendlyfire, Status ? 1 : 0);
    SetConVarFlags(mp_friendlyfire, flags);

    if ( Status ) {
        CPrintToChatAll("%t", "Friendly Fire has been disabled");
    } else {
        CPrintToChatAll("%t", "Friendly Fire has been enabled");
    }

    UTIL_PlaySound(0, AutoFF);
}

UTIL_SetClientGodMode(client, mode = 0)
{
    SetEntProp(client, Prop_Data, "m_takedamage", mode ? DAMAGE_NO : DAMAGE_YES, 1);
}

/**
 * Recalculate CurrentLeader.
 *
 * @param int client
 * @param int oldLevel
 * @param int newLevel
 * @return void
 */
UTIL_RecalculateLeader(client, oldLevel, newLevel)
{
    if ( newLevel == oldLevel )
    {
        return;
    }
    if ( newLevel < oldLevel )
    {
        if ( !CurrentLeader )
        {
            return;
        }
        if ( client == CurrentLeader )
        {
            // was the leader
            CurrentLeader = FindLeader();
            if ( CurrentLeader != client )
            {
                Call_StartForward(FwdLeader);
                Call_PushCell(CurrentLeader);
                Call_PushCell(newLevel);
                Call_PushCell(WeaponOrderCount);
                Call_Finish();
                UTIL_PlaySoundForLeaderLevel();
            }
            return;
        }
        // was not a leader
        return;
    }
    // newLevel > oldLevel
    if ( !CurrentLeader )
    {
        CurrentLeader = client;
        Call_StartForward(FwdLeader);
        Call_PushCell(CurrentLeader);
        Call_PushCell(newLevel);
        Call_PushCell(WeaponOrderCount);
        Call_Finish();
        UTIL_PlaySoundForLeaderLevel();
        return;
    }
    if ( CurrentLeader == client )
    {
        // still leading
        UTIL_PlaySoundForLeaderLevel();
        return;
    }
    // CurrentLeader != client
    if ( newLevel < PlayerLevel[CurrentLeader] )
    {
        // not leading
        return;
    }
    if ( newLevel > PlayerLevel[CurrentLeader] )
    {
        CurrentLeader = client;
        Call_StartForward(FwdLeader);
        Call_PushCell(CurrentLeader);
        Call_PushCell(newLevel);
        Call_PushCell(WeaponOrderCount);
        Call_Finish();
        // start leading
        UTIL_PlaySoundForLeaderLevel();
        return;
    }
    // new level == leader level
    // tied to the lead
    UTIL_PlaySoundForLeaderLevel();
}

UTIL_PlaySoundForLeaderLevel()
{
    if ( !CurrentLeader )
    {
        return;
    }
    new Weapons:WeapId = WeaponOrderId[PlayerLevel[CurrentLeader]];
    if ( WeapId == CSW_HEGRENADE )
    {
        UTIL_PlaySound(0, Nade);
        return;
    }
    if ( WeapId == CSW_KNIFE )
    {
        UTIL_PlaySound(0, Knife);
        return;
    }
}

UTIL_ChangeLevel(client, difference, bool:KnifeSteal = false)
{
    if ( !difference || !IsActive || WarmupEnabled || GameWinner )
    {
        return PlayerLevel[client];
    }
    
    new oldLevel = PlayerLevel[client], Level = oldLevel + difference;

    if ( Level < 0 ) {
        Level = 0;
    } else if ( Level > WeaponOrderCount ) {
        Level = WeaponOrderCount;
    }

    new ret;

    Call_StartForward(FwdLevelChange);
    Call_PushCell(client);
    Call_PushCell(Level);
    Call_PushCell(difference);
    Call_PushCell(KnifeSteal);
    Call_PushCell(Level == (WeaponOrderCount - 1));
    Call_PushCell(CSW_KNIFE == WeaponOrderId[Level]);
    Call_Finish(ret);

    if ( ret )
    {
        return PlayerLevel[client] = oldLevel;
    }

    if ( !BotCanWin && IsFakeClient(client) && (Level >= WeaponOrderCount) )
    {
        /* Bot can't win so just keep them at the last level */
        return oldLevel;
    }

    // Client got new level
    PlayerLevel[client] = Level;
    if ( KnifeSteal && g_Cfg_KnifeProRecalcPoints && (oldLevel != Level) ) {
        CurrentKillsPerWeap[client] = CurrentKillsPerWeap[client] * UTIL_GetCustomKillPerLevel(Level) / UTIL_GetCustomKillPerLevel(oldLevel);
    } else {
        CurrentKillsPerWeap[client] = 0;
    }
    
    if ( difference < 0 )
    {
        UTIL_PlaySound(client, Down);
    }
    else 
    {
        if ( KnifeSteal )
        {
            UTIL_PlaySound(client, Steal);
        }
        else
        {
            UTIL_PlaySound(client, Up);
        }
    }

    if ( !IsVotingCalled && Level >= WeaponOrderCount - VoteLevelLessWeaponCount )
    {
        IsVotingCalled = true;
        Call_StartForward(FwdVoteStart);
        Call_Finish();
    }

    if ( g_cfgDisableRtvLevel && !g_isCalledDisableRtv && Level >= g_cfgDisableRtvLevel )
    {
        g_isCalledDisableRtv = true;
        Call_StartForward(FwdDisableRtv);
        Call_Finish();
    }
    
    if ( g_cfgEnableFriendlyFireLevel && !g_isCalledEnableFriendlyFire && Level >= g_cfgEnableFriendlyFireLevel )
    {
        g_isCalledEnableFriendlyFire = true;
        if ( g_cfgFriendlyFireOnOff ) {
            UTIL_ChangeFriendlyFire(true);
        } else {
            UTIL_ChangeFriendlyFire(false);
        }
    }
    
    /* WeaponOrder count is the last weapon. */
    if ( Level >= WeaponOrderCount )
    {
        /* Winner Winner Winner. They won the prize of gaben plus a hat. */
        decl String:Name[MAX_NAME_SIZE];
        GetClientName(client, Name, sizeof(Name));

        new team = GetClientTeam(client);
        new r = (team == TEAM_T ? 255 : 0);
        new g =  team == TEAM_CT ? 128 : (team == TEAM_T ? 0 : 255);
        new b = (team == TEAM_CT ? 255 : 0);
        UTIL_PrintToUpperLeft(r, g, b, "%t", "Has won", Name);

        Call_StartForward(FwdWinner);
        Call_PushCell(client);
        Call_PushString(WeaponOrderName[Level - 1]);
        Call_Finish();

        GameWinner = client;

        UTIL_FreezeAllPlayer();
        UTIL_ForceMapChange();

        new result;
        Call_StartForward(FwdSoundWinner);
        Call_PushCell(client);
        Call_Finish(result);

        if ( !result ) {
            UTIL_PlaySound(0, Winner);
        }

        if ( AlltalkOnWin )
        {
            new Handle:sv_alltalk = FindConVar("sv_alltalk");
            if ( sv_alltalk != INVALID_HANDLE )
            {
                SetConVarInt(sv_alltalk,1);
            }
        }
        PlayerLevel[client] = oldLevel;
        return oldLevel;
    }
    UTIL_RecalculateLeader(client, oldLevel, Level);
    UTIL_UpdatePlayerScoreLevel(client);

    return Level;
}

UTIL_ForceMapChange() {
    if ( g_Cfg_ChangeLevelTime > 0 ) {
        CreateTimer(g_Cfg_ChangeLevelTime, UTIL_Timer_ForceMapChange);
    } else {
        ForceMapChange();
    }
}

public Action:UTIL_Timer_ForceMapChange(Handle:timer, Handle:data) {
    ForceMapChange();
}

ForceMapChange()
{
    /* Force intermission change map. */
    #if 0
    HACK_ForceGameEnd();
    #endif
    HACK_EndMultiplayerGame();
}

UTIL_FreezeAllPlayer()
{
    for(new i = 1, b; i <= MaxClients; i++)
    {
        if(IsClientInGame(i))
        {
            b = GetEntData(i, OffsetFlags)|FL_FROZEN;
            SetEntData(i, OffsetFlags, b);
        }
    }
}

/**
 * Force drop a weapon by a slot
 *
 * @param client        Player index.
 * @param slot            The player weapon slot. Look at enum Slots.
 * @return            Return entity index or -1 if not found
 */
UTIL_ForceDropWeaponBySlot(client, Slots:slot)
{
    if(slot == Slot_Grenade)
    {
        ThrowError("You must use UTIL_FindGrenadeByName to drop a grenade");
        return -1;
    }

    if ( slot == Slot_Primary || slot == Slot_Secondary )
    {
        g_ClientSlotEnt[client][slot] = -1;
    }

    new ent = GetPlayerWeaponSlot(client, _:slot);
    if ( ent > 0 )
    {
        // TODO: test and find out which is correct method
        // native bool:RemovePlayerItem(client, item);
        // or removeedict ?

        // TODO: find out is HACK_CSWeaponDrop needed here
        // HACK_CSWeaponDrop(client, ent);
        
        // I believe that it is more correct than using HACK_CSWeaponDrop
        if ( slot == Slot_C4 )
        {
            HACK_CSWeaponDrop(client, ent);
            HACK_Remove(ent);
        }
        else
        {
            RemovePlayerItem(client, ent);
            RemoveEdict(ent);
        }
        return -1;
    }

    return -1;
}

/**
 * @param client        Player index
 * @param remove        Remove weapon on drop
 * @param DropKnife        Allow knife drop
 * @param DropBomb        Allow bomb drop. Will only work after event bomb_pickup is called.
 * @noreturn
 */
UTIL_ForceDropAllWeapon(client, bool:remove = false, bool:DropKnife = false, bool:DropBomb = false)
{
    for(new Slots:i = Slot_Primary, ent; i < Slot_None; i++)
    {
        if(i == Slot_Grenade)
        {
            UTIL_DropAllGrenades(client, remove);
            continue;
        }

        if ( i == Slot_Primary || i == Slot_Secondary )
        {
            g_ClientSlotEnt[client][i] = -1;
        }

        ent = GetPlayerWeaponSlot(client, _:i);
        if ( ent > 0 )
        {
            if(i == Slot_Knife && !DropKnife || i == Slot_C4 && !DropBomb)
            {
                continue;
            }

            if ( remove )
            {
                RemovePlayerItem(client, ent);
                RemoveEdict(ent);
            }
            else
            {
                HACK_CSWeaponDrop(client, ent);
            }
        }
    }
}

/**
 * @client        Player index
 * @remove        Remove grenade on drop
 * @noreturn
 */
UTIL_DropAllGrenades(client, bool:remove = false)
{
    for(new i = 0, ent; i , i < 4; i++)
    {
        ent = GetPlayerWeaponSlot(client, _:Slot_Grenade);
        if ( ent < 1 )
        {
            break;
        }

        if ( remove )
        {
            RemovePlayerItem(client, ent);
            RemoveEdict(ent);
        }
        else
        {
            HACK_CSWeaponDrop(client, ent);
        }
    }
    if ( StripDeadPlayersWeapon ) {
        g_ClientSlotEntHeGrenade[client] = -1;
        g_ClientSlotEntSmoke[client] = -1;
        UTIL_ClearFlashCounter(client);
    }
}

/**
 *
 * @param client    Player client
 * @param Grenade    Grenade weapon name. ie weapon_hegrenade
 * @param drop        Drop the grenade
 * @param remove    Removes the weapon from the world
 *
 * @return        -1 if not found or you drop the grenade otherwise will return the Entity index.
 */
UTIL_FindGrenadeByName(client, const String:Grenade[], bool:drop = false, bool:remove = false) {
    decl String:Class[64];

    for ( new i = 0, ent; i < 128; i += 4 ) {
        ent = GetEntDataEnt2(client, m_hMyWeapons + i);

        if ( ent > MaxClients && HACK_GetSlot(ent) == _:Slot_Grenade ) {
            GetEdictClassname(ent, Class, sizeof(Class));

            if ( strcmp(Class, Grenade, false) == 0 ) {
                if ( drop ) {
                    if ( remove ) {
                        RemovePlayerItem(client, ent);
                        RemoveEdict(ent);
                        if ( StripDeadPlayersWeapon ) {
                            if ( StrEqual(Grenade, WeaponName[CSW_HEGRENADE]) ) {
                                g_ClientSlotEntHeGrenade[client] = -1;
                            } else if ( StrEqual(Grenade, WeaponName[CSW_SMOKEGRENADE]) ) {
                                g_ClientSlotEntSmoke[client] = -1;
                            } else if ( StrEqual(Grenade, WeaponName[CSW_FLASHBANG]) ) {
                                UTIL_UpdateFlashCounter(client);
                            }
                        }
                        return -1;
                    } else {
                        HACK_CSWeaponDrop(client, ent);
                    }
                }

                return ent;
            }
        }
    }

    return -1;
}

UTIL_CheckForFriendlyFire(client, Weapons:WeapId)
{
    if ( !AutoFriendlyFire )
    {
        return;
    }
    new pState = PlayerState[client];
    if ( (pState & GRENADE_LEVEL) && (WeapId != CSW_HEGRENADE) )
    {
        PlayerState[client] &= ~GRENADE_LEVEL;

        if ( --PlayerOnGrenade < 1 )
        {
            if ( g_cfgFriendlyFireOnOff ) {
                UTIL_ChangeFriendlyFire(false);
            } else {
                UTIL_ChangeFriendlyFire(true);
            }
        }
        return;
    }
    if ( !(pState & GRENADE_LEVEL) && (WeapId == CSW_HEGRENADE) )
    {
        PlayerOnGrenade++;
        PlayerState[client] |= GRENADE_LEVEL;
            
        if ( !GetConVarInt(mp_friendlyfire) )
        {
            if ( g_cfgFriendlyFireOnOff ) {
                UTIL_ChangeFriendlyFire(true);
            } else {
                UTIL_ChangeFriendlyFire(false);
            }
        }
        return;
    }
}

UTIL_GiveNextWeapon(client, level, bool:drop = true, bool:knife = false) {
    new Handle:data = CreateDataPack();
    WritePackCell(data, client);
    WritePackCell(data, level);
    WritePackCell(data, _:drop);
    WritePackCell(data, _:knife);
       
    CreateTimer(0.1, UTIL_Timer_GiveNextWeapon, data);
}

public Action:UTIL_Timer_GiveNextWeapon(Handle:timer, Handle:data) {
    new client, level, bool:drop, bool:knife;

    ResetPack(data);
    client = ReadPackCell(data);
    level = ReadPackCell(data);
    drop = bool:ReadPackCell(data);
    knife = bool:ReadPackCell(data);
    CloseHandle(data);

    if ( !IsClientInGame(client) || !IsPlayerAlive(client) ) {
        return;
    }

    UTIL_GiveNextWeaponReal(client, level, drop, knife);
}

UTIL_GiveNextWeaponReal(client, level, bool:drop = true, bool:knife = false) {
    if ( g_Cfg_BlockWeaponSwitchIfKnife && knife ) {
        g_BlockSwitch[client] = true;
    }
    new Weapons:WeapId = WeaponOrderId[level], Slots:slot = WeaponSlot[WeapId];
    
    UTIL_CheckForFriendlyFire(client, WeapId);

    if ( drop )
    {
        UTIL_ForceDropAllWeapon(client, true);
    }

    if ( slot == Slot_Grenade )
    {
        if ( NumberOfNades )
        {
            g_NumberOfNades[client] = NumberOfNades - 1;
        }
        if ( NadeBonusWeaponId )
        {
            new ent = GivePlayerItemWrapper(client, WeaponName[NadeBonusWeaponId]);
            new Slots:slotBonus = WeaponSlot[NadeBonusWeaponId];
            if ( slotBonus == Slot_Primary || slotBonus == Slot_Secondary ) 
            {
                g_ClientSlotEnt[client][slotBonus] = ent;
            }
            // Remove bonus weapon ammo! So player can not reload weapon!
            if ( (ent != -1) && RemoveBonusWeaponAmmo )
            {
                new iAmmo = UTIL_GetAmmoType(ent);

                if ( iAmmo != -1 )
                {
                    new Handle:Info = CreateDataPack();
                    WritePackCell(Info, client);
                    WritePackCell(Info, iAmmo);
                    ResetPack(Info);

                    CreateTimer(0.1, UTIL_DelayAmmoRemove, Info, TIMER_HNDL_CLOSE);
                }
            }
        }
        if ( NadeSmoke )
        {
            new ent = GivePlayerItemWrapper(client, WeaponName[CSW_SMOKEGRENADE]);
            g_ClientSlotEntSmoke[client] = ent;
        }
        if ( NadeFlash )
        {
            new ent = GivePlayerItemWrapper(client, WeaponName[CSW_FLASHBANG]);
            UTIL_FlashCounterAdd(client, ent);
        }
    }
    if ( slot == Slot_Knife )
    {
        if ( g_Cfg_KnifeSmoke )
        {
            new ent = GivePlayerItemWrapper(client, WeaponName[CSW_SMOKEGRENADE]);
            g_ClientSlotEntSmoke[client] = ent;
        }
        if ( g_Cfg_KnifeFlash )
        {
            new ent = GivePlayerItemWrapper(client, WeaponName[CSW_FLASHBANG]);
            UTIL_FlashCounterAdd(client, ent);
        }
    }
    else
    {
        /* Give new weapon */
        new ent = GivePlayerItemWrapper(client, WeaponName[WeapId]);
        if ( slot == Slot_Primary || slot == Slot_Secondary ) {
            g_ClientSlotEnt[client][slot] = ent;
        } else if ( slot == Slot_Grenade ) {
            if ( WeapId == CSW_HEGRENADE ) {
                g_ClientSlotEntHeGrenade[client] = ent;
            } else if ( WeapId == CSW_SMOKEGRENADE ) {
                g_ClientSlotEntSmoke[client] = ent;
            } else if ( WeapId == CSW_FLASHBANG ) {
                UTIL_FlashCounterAdd(client, ent);
            }
        }

    }

    if ( g_Cfg_BlockWeaponSwitchIfKnife && knife ) {
        g_BlockSwitch[client] = false;
    } else {
        FakeClientCommand(client, "use %s", WeaponName[WeapId]);
    }
}

/**
 * This function was created because of the dynamic pricing that was updated in the
 * recent Source update. They are giving full ammo no matter if mp_dynamicpricing was 0 or 1.
 * So I had to delay reseting the hegrenade with glock to 50 bullets by 0.2
 */
public Action:UTIL_DelayAmmoRemove(Handle:timer, Handle:data)
{
    new client = ReadPackCell(data);

    if(IsClientInGame(client))
    {
        HACK_RemoveAmmo(client, 90, ReadPackCell(data));
    }
}

UTIL_PlaySound(client, Sounds:type)
{
    if ( !EventSounds[type][0] )
    {
        return;
    }
    if ( client && !IsClientInGame(client) )
    {
        return;
    }
    if ( !client ) {
        EmitSoundToAll(EventSounds[type]);
    } else {
        EmitSoundToClient(client, EventSounds[type]);
    }
}

UTIL_RemoveBuyZones()
{
    new index = -1;
    new found = -1;
    while ( (index = FindEntityByClassname(index, "func_buyzone")) > 0 )
    {
        if ( found > 0 ) RemoveEdict(found);
        found = index;
    }
    if ( found > 0 ) RemoveEdict(found);
}

UTIL_ReloadActiveWeapon(client, Weapons:WeaponId)
{
    new Slots:slot = WeaponSlot[WeaponId];
    if ( (slot == Slot_Primary || slot == Slot_Secondary) )
    {
        new ent = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
        if ( ent > -1 ) {
            SetEntProp(ent, Prop_Send, "m_iClip1", WeaponAmmo[WeaponId]);
        }
    }
}

GivePlayerItemWrapper(client, const String:item[])
{
    g_IsInGiveCommand = true;
    new ent = GivePlayerItem(client, item);
    g_IsInGiveCommand = false;
    return ent;
}

UTIL_RemoveClientDroppedWeapons(client, bool:disconnect = false)
{
    if ( StripDeadPlayersWeapon )
    {
        new ent = g_ClientSlotEnt[client][Slot_Primary];
        if ( ent >= 0 && IsValidEdict(ent) && IsValidEntity(ent) && (GetEntDataEnt2(ent, OffsetWeaponParent) == -1 || disconnect) )
        {
            RemoveEdict(ent);
        }
        ent = g_ClientSlotEnt[client][Slot_Secondary];
        if ( ent >= 0 && IsValidEdict(ent) && IsValidEntity(ent) && (GetEntDataEnt2(ent, OffsetWeaponParent) == -1 || disconnect) )
        {
            RemoveEdict(ent);
        }
        ent = g_ClientSlotEntHeGrenade[client];
        if ( ent >= 0 && IsValidEdict(ent) && IsValidEntity(ent) && (GetEntDataEnt2(ent, OffsetWeaponParent) == -1 || disconnect) )
        {
            RemoveEdict(ent);
        }
        ent = g_ClientSlotEntSmoke[client];
        if ( ent >= 0 && IsValidEdict(ent) && IsValidEntity(ent) && (GetEntDataEnt2(ent, OffsetWeaponParent) == -1 || disconnect) )
        {
            RemoveEdict(ent);
        }
        for ( new i = 0; i < sizeof(g_ClientSlotEntFlash[]); i++ ) {
            ent = g_ClientSlotEntFlash[client][i];
            if ( ent >= 0 && IsValidEdict(ent) && IsValidEntity(ent) && (GetEntDataEnt2(ent, OffsetWeaponParent) == -1 || disconnect) )
            {
                RemoveEdict(ent);
            }
        }

        g_ClientSlotEnt[client][Slot_Primary] = -1;
        g_ClientSlotEnt[client][Slot_Secondary] = -1;
        g_ClientSlotEntHeGrenade[client] = -1;
        g_ClientSlotEntSmoke[client] = -1;
        UTIL_ClearFlashCounter(client);
    }
}

UTIL_StartTripleEffects(client)
{
    if ( g_tripleEffects[client] ) {
        return;
    }
    g_tripleEffects[client] = 1;
    if ( TripleLevelBonusGodMode ) {
        UTIL_SetClientGodMode(client, 1);
    }
    if ( g_Cfg_TripleLevelBonusGravity ) {
        SetEntityGravity(client, g_Cfg_TripleLevelBonusGravity);
    }
    if ( g_Cfg_TripleLevelBonusSpeed ) {
        SetEntDataFloat(client, OffsetMovement, g_Cfg_TripleLevelBonusSpeed);
    }
    if ( EventSounds[Triple][0] ) {
        EmitSoundToAll(EventSounds[Triple], client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL);
    }
    if ( g_Cfg_TripleLevelEffect ) {
        UTIL_StartEffectClient(client);
    }
}

UTIL_StopTripleEffects(client)
{
    if ( !g_tripleEffects[client] ) {
        return;
    }
    g_tripleEffects[client] = 0;
    if ( TripleLevelBonusGodMode ) {
        UTIL_SetClientGodMode(client, 0);
    }
    if ( g_Cfg_TripleLevelBonusGravity ) {
        SetEntityGravity(client, 1.0);
    }
    if ( g_Cfg_TripleLevelBonusSpeed ) {
        SetEntDataFloat(client, OffsetMovement, 1.0);
    }
    if ( EventSounds[Triple][0] ) {
        EmitSoundToAll(EventSounds[Triple], client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_STOPLOOPING, SNDVOL_NORMAL, SNDPITCH_NORMAL);
    }
    if ( g_Cfg_TripleLevelEffect ) {
        UTIL_StopEffectClient(client);
    }
}

/**
 * Return current leader client.
 *
 * Return 0 if no leaders found.
 *
 * @param bool DisallowBot
 * @return int
 */
FindLeader(bool:DisallowBot = false)
{
    new leaderId      = 0;
    new leaderLevel   = 0;
    new currentLevel  = 0;

    for (new i = 1; i <= MaxClients; i++)
    {
        if ( DisallowBot && IsClientInGame(i) && IsFakeClient(i) )
        {
            continue;
        }

        currentLevel = PlayerLevel[i];

        if ( currentLevel > leaderLevel )
        {
            leaderLevel = currentLevel;
            leaderId = i;
        }
    }

    return leaderId;
}

CheckForTripleLevel(client)
{
    CurrentLevelPerRoundTriple[client]++;
    if ( TripleLevelBonus && CurrentLevelPerRoundTriple[client] == g_Cfg_MultiLevelAmount )
    {
        decl String:Name[MAX_NAME_SIZE];
        GetClientName(client, Name, sizeof(Name));

        decl String:subtext[64];
        for ( new i = 1; i <= MaxClients; i++ )
        {
            if ( IsClientInGame(i) )
            {
                SetGlobalTransTarget(i);
                FormatLanguageNumberTextEx(i, subtext, sizeof(subtext), g_Cfg_MultiLevelAmount, "leveled times");
                CPrintToChatEx(i, client, "%t", "Player has been leveled many times", Name, subtext);
            }
        }

        UTIL_StartTripleEffects(client);
        CreateTimer(10.0, RemoveBonus, client);

        Call_StartForward(FwdTripleLevel);
        Call_PushCell(client);
        Call_Finish();
    }
}

public Action:RemoveBonus(Handle:timer, any:client)
{
    CurrentLevelPerRoundTriple[client] = 0;
    if ( IsClientInGame(client) )
    {
        UTIL_StopTripleEffects(client);
    }
}

/**
 * Stocks
 */

stock UTIL_StringToLower(String:Source[])
{
    new len = strlen(Source);

    for(new i = 0; i <= len; i++)
    {
        if(IsCharUpper(Source[i]))
        {
            Source[i] |= (1<<5);
        }
    }

    return 1;
}

stock UTIL_StringToUpper(String:Source[])
{
    new len = strlen(Source);

    /* Should this be i <= len */
    for(new i = 0; i <= len; i++)
    {
        if(IsCharLower(Source[i]))
        {
            Source[i] &= ~(1<<5);
        }
    }

    return 1;
}

UTIL_GiveWarmUpWeapon(client)
{
    if ( WarmupRandomWeaponMode )
    {   
        if ( WarmupRandomWeaponMode == 1 || WarmupRandomWeaponMode == 2 )
        {
            if ( WarmupRandomWeaponLevel == -1 )
            {
                WarmupRandomWeaponLevel = UTIL_GetRandomInt(0, WeaponOrderCount-1);
            }
            UTIL_GiveNextWeapon(client, WarmupRandomWeaponLevel, false);
        }
        else if ( WarmupRandomWeaponMode == 3 )
        {
            UTIL_GiveNextWeapon(client, UTIL_GetRandomInt(0, WeaponOrderCount-1), false);
        }
        return;
    }
    if ( WarmupNades ) {
        new ent = GivePlayerItemWrapper(client, WeaponName[CSW_HEGRENADE]);
        g_ClientSlotEntHeGrenade[client] = ent;
        FakeClientCommand(client, "use %s", WeaponName[CSW_HEGRENADE]);
        return;
    }
    if ( g_Cfg_WarmupWeapon && g_Cfg_WarmupWeapon != CSW_KNIFE )
    {
        GivePlayerItemWrapper(client, WeaponName[g_Cfg_WarmupWeapon]);
        FakeClientCommand(client, "use %s", WeaponName[g_Cfg_WarmupWeapon]);
        return;
    }
    FakeClientCommand(client, "use %s", WeaponName[CSW_KNIFE]);
}

UTIL_GetRandomInt(start, end)
{
    new rand;
    #if defined URANDOM_SUPPORT
        // if sourcemod version >= 1.3.0
        rand = GetURandomInt();
    #else
        new Float:frand = GetEngineTime() + GetRandomFloat();
        rand = RoundFloat( ( frand - RoundToZero(frand) ) * 1000000 ) + GetTime();
    #endif
    return ( rand % (1 + end - start) ) + start;
}

UTIL_GiveExtraNade(client, bool:knife)
{
    /* Give them another grenade if they killed another person with another weapon or hegrenade with the option enabled*/
    if ( ExtraNade )
    {
        /* Do not give them another nade if they already have one */
        if ( UTIL_FindGrenadeByName(client, WeaponName[CSW_HEGRENADE]) == -1 )
        {
            if ( g_Cfg_BlockWeaponSwitchIfKnife && knife ) {
                g_BlockSwitch[client] = true;
            }
            new ent = GivePlayerItemWrapper(client, WeaponName[CSW_HEGRENADE]);
            g_ClientSlotEntHeGrenade[client] = ent;

            if ( g_Cfg_BlockWeaponSwitchIfKnife && knife ) {
                g_BlockSwitch[client] = false;
            }
        }
    }
}

UTIL_SetClientScoreAndDeaths(client, score, deaths = -1)
{
    SetEntProp(client, Prop_Data, "m_iFrags", score);
    if ( deaths >= 0 )
    {
        SetEntProp(client, Prop_Data, "m_iDeaths", deaths);
    }
}

UTIL_UpdatePlayerScoreLevel(client)
{
    if ( WarmupEnabled && !DisableWarmupOnRoundEnd )
    {
        return;
    }
    if ( g_Cfg_LevelsInScoreboard && client && IsClientInGame(client) )
    {
        UTIL_SetClientScoreAndDeaths(client, PlayerLevel[client] + 1, g_Cfg_ScoreboardClearDeaths? 0: -1);
    }
}

UTIL_UpdatePlayerScoreDelayed(client)
{
    if ( g_Cfg_LevelsInScoreboard && client && IsClientInGame(client) )
    {
        CreateTimer(0.1, UTIL_Timer_UpdatePlayerScore, client);
    }
}

public Action:UTIL_Timer_UpdatePlayerScore(Handle:timer, any:client)
{
    UTIL_UpdatePlayerScoreLevel(client);
}

UTIL_ShowHintTextMulti(client, const String:textHint[], times, Float:time)
{
    if ( IsFakeClient(client) )
    {
        return;
    }
    
    new Handle:data = CreateDataPack();
    WritePackCell(data, times);
    WritePackCell(data, client);
    WritePackString(data, textHint);
    
    new Handle:timer = CreateTimer(time, UTIL_Timer_ShowHintText, data, TIMER_REPEAT);
    CreateTimer(0.1, UTIL_Timer_ShowHintTextFirst, timer);
}

public Action:UTIL_Timer_ShowHintTextFirst(Handle:timer, any:data)
{
    TriggerTimer(data);
}

public Action:UTIL_Timer_ShowHintText(Handle:timer, any:data)
{
    new client, String:textHint[512], times;
    
    ResetPack(data);
    times = ReadPackCell(data);
    client = ReadPackCell(data);
    ReadPackString(data, textHint, sizeof(textHint));
    
    if ( !IsClientInGame(client) )
    {
        CloseHandle(data);
        return Plugin_Stop;
    }
    
    PrintHintText(client, textHint);
    if ( --times <= 0 )
    {
        CloseHandle(data);
        return Plugin_Stop;
    }
    else
    {
        SetPackPosition(data, 0);
        WritePackCell(data, times);
        return Plugin_Continue;
    }
}

UTIL_ArrayIntRand(array[], size)
{
    if ( size < 2 )
    {
        return;
    }
    new tmpIndex, tmpValue;
    for ( new i = 0; i < size-1; i++ )
    {
        tmpIndex = UTIL_GetRandomInt(i, size-1);
        if ( tmpIndex == i )
        {
            continue;
        }
        tmpValue = array[tmpIndex];
        
        array[tmpIndex] = array[i];
        array[i] = tmpValue;
    }
}

UTIL_GetCustomKillPerLevel(level)
{
    new killsPerLevel = CustomKillPerLevel[level];
    return killsPerLevel ? killsPerLevel : MinKillsPerLevel;
}

UTIL_GetHandicapLevel(skipClient = 0, aboveLevel = -1)
{
    new level;
    if ( HandicapMode == 1 ) {
        level = UTIL_GetAverageLevel(g_Cfg_HandicapSkipBots, aboveLevel, skipClient);
    } else if ( HandicapMode == 2 ) {
        level = UTIL_GetMinimumLevel(g_Cfg_HandicapSkipBots, aboveLevel, skipClient);
    }
    if ( level == -1 ) {
        return 0;
    }
    level -= g_Cfg_HandicapLevelSubstract;
    if ( g_Cfg_MaxHandicapLevel && g_Cfg_MaxHandicapLevel < level ) {
        level = g_Cfg_MaxHandicapLevel;
    }
    if ( level < 1 ) {
        return 0;
    }
    return level;
}

UTIL_GetMinimumLevel(bool:skipBots = false, aboveLevel = -1, skipClient = 0)
{
    new minimum = -1;
    new level = 0;
    for ( new i = 1; i <= MaxClients; i++ )
    {
        if ( IsClientInGame(i) && ( g_Cfg_HandicapUseSpectators || GetClientTeam(i) > 1 ) )
        {
            if ( ( skipBots && IsFakeClient(i) ) 
                || ( GetClientTeam(i) < 2 )
                || ( skipClient == i ) )
            {
                continue;
            }
            level = PlayerLevel[i];
            if ( aboveLevel >= level ) {
                continue;
            }
            if ( (minimum == -1) || (level < minimum) )
            {                 
                minimum = level;
            }
        }
    }
    return minimum;
}

UTIL_GetAverageLevel(bool:skipBots = false, aboveLevel = -1, skipClient = 0)
{
    new count, level, tmpLevel;
    for ( new i = 1; i <= MaxClients; i++ )
    {
        if ( IsClientInGame(i) && ( g_Cfg_HandicapUseSpectators || GetClientTeam(i) > 1 ) )
        {
            if ( ( skipBots && IsFakeClient(i) ) 
                || ( GetClientTeam(i) < 2 )
                || ( skipClient == i ) )
            {
                continue;
            }
            tmpLevel = PlayerLevel[i];
            if ( aboveLevel >= tmpLevel ) {
                continue;
            }
            level += tmpLevel;
            count++;
        }
    }
    if ( !count ) {
        return -1;
    }
    level /= count;
    return level;
}

bool:UTIL_SetHandicapForClient(client)
{
    if ( g_Cfg_HandicapTimesPerMap )
    {
        decl String:auth[64];
        GetClientAuthString(client, auth, sizeof(auth));

        new times = 0;
        if ( !GetTrieValue(PlayerHandicapTimes, auth, times) ) {
            times = 0;
        }

        if ( times >= g_Cfg_HandicapTimesPerMap ) {
            return false;
        }

        times++;
        SetTrieValue(PlayerHandicapTimes, auth, times);
    }
    
    return bool:GG_GiveHandicapLevel(client);
}

UTIL_GetAmmoType(weapon) {
    return GetEntData(weapon, g_iOffs_iPrimaryAmmoType, 1);
}

UTIL_StartEffectClient(client) {
    if ( g_Ent_Effect[client]  > -1 ) {
        return 0;
    }
    g_Ent_Effect[client] = UTIL_CreateEffect(client);
    return 1;
}

UTIL_StopEffectClient(client) {
    if ( g_Ent_Effect[client] < 0 ) {
        return;
    }
    if ( IsValidEdict(g_Ent_Effect[client]) ) {
        RemoveEdict(g_Ent_Effect[client]);
    }
    g_Ent_Effect[client] = -1;
}

UTIL_CreateEffect(client) {
    new ent = CreateEntityByName("env_spritetrail");
    new String:target[32];
    Format(target, sizeof(target), "target%i", client);
    
    DispatchKeyValue(client, "targetname", target);
    DispatchKeyValue(ent, "parentname", target);
    DispatchKeyValue(ent, "lifetime", "1.0");
    DispatchKeyValue(ent, "endwidth", "1.0");
    DispatchKeyValue(ent, "startwidth", "20.0");
    //DispatchKeyValue(ent, "spritename", "materials/sprites/bluelaser1.vmt");
    DispatchKeyValue(ent, "spritename", "materials/sprites/crystal_beam1.vmt");
    DispatchKeyValue(ent, "renderamt", "255");
    //DispatchKeyValue(ent, "rendercolor", "0 128 255");
    DispatchKeyValue(ent, "rendercolor", "255 128 0");
    DispatchKeyValue(ent, "rendermode", "5");
    
    DispatchSpawn(ent);
    
    new Float:Client_Origin[3];
    GetClientAbsOrigin(client,Client_Origin);
    Client_Origin[2] += 20.0; //Beam clips into the floor without this
    TeleportEntity(ent, Client_Origin, NULL_VECTOR, NULL_VECTOR);
    
    SetVariantString(target);
    AcceptEntityInput(ent, "SetParent");
    return ent;
}

UTIL_UpdateFlashCounter(client) {
    decl String:Class[64];
    new index = 0;

    UTIL_ClearFlashCounter(client);

    for ( new i = 0, ent; i < 128; i += 4 ) {
        ent = GetEntDataEnt2(client, m_hMyWeapons + i);

        if ( ent > MaxClients && HACK_GetSlot(ent) == _:Slot_Grenade ) {
            GetEdictClassname(ent, Class, sizeof(Class));

            if ( StrEqual(Class, WeaponName[CSW_FLASHBANG], false) ) {
                g_ClientSlotEntFlash[client][index++] = ent;
            }
        }
    }
}

UTIL_ClearFlashCounter(client) {
    for ( new i = 0; i < sizeof(g_ClientSlotEntFlash[]); i++ ) {
        g_ClientSlotEntFlash[client][i] = -1;
    }
}

UTIL_FlashCounterAdd(client, ent) {
    for ( new i = 0; i < sizeof(g_ClientSlotEntFlash[]); i++ ) {
        if ( g_ClientSlotEntFlash[client][i] == -1 ) {
            g_ClientSlotEntFlash[client][i] = ent;
            return;
        }
    }
}
