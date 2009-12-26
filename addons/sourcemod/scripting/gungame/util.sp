/**
 * ===============================================================
 * GunGame:SM, Copyright (C) 2007
 * All rights reserved.
 * ===============
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

UTIL_FindMapObjective()
{
    new i = FindEntityByClassname(-1, "func_bomb_target");
    new maxslots = GetMaxClients( );
    
    if(i > maxslots)
    {
        MapStatus |= OBJECTIVE_BOMB;
    } else {
        if((i = FindEntityByClassname(-1, "info_bomb_target")) > maxslots)
        {
            MapStatus |= OBJECTIVE_BOMB;
        }
    }
    
    if((i = FindEntityByClassname((i = 0), "hostage_entity")) > maxslots)
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

UTIL_PrintToUpperLeft(client, r, g, b, const String:source[], any:...)
{
    if(client && IsFakeClient(client))
    {
        return;
    }

    decl String:Buffer[53];
    VFormat(Buffer, sizeof(Buffer), source, 6);

    new Handle:Msg = CreateKeyValues("msg");

    if(Msg != INVALID_HANDLE)
    {
        KvSetString(Msg, "title", Buffer);
        KvSetColor(Msg, "color", r, g, b, 255);
        KvSetNum(Msg, "level", 0);
        KvSetNum(Msg, "time", 20);

        if(client == 0)
        {
            new maxslots = GetMaxClients( );

            for(new i = 1; i <= maxslots; i++)
            {
                if(IsClientInGame(i))
                {
                    CreateDialog(i, Msg, DialogType_Msg);
                }
            }
        } else {
            CreateDialog(client, Msg, DialogType_Msg);
        }

        CloseHandle(Msg);
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

    return Weapons:0;
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

    return Weapons:0;
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
    if ( !difference || !IsActive || (WarmupEnabled && WarmupReset) )
    {
        return PlayerLevel[client];
    }
    
    new oldLevel = PlayerLevel[client], Level = oldLevel + difference;

    if ( Level < 0 )
    {
        Level = 0;
    }
    else if ( Level > WeaponOrderCount )
    {
        Level = WeaponOrderCount;
    }

    new ret;

    Call_StartForward(FwdLevelChange);
    Call_PushCell(client);
    Call_PushCell(Level);
    Call_PushCell(difference);
    Call_PushCell(KnifeSteal);
    Call_PushCell(Level == (WeaponOrderCount - 1));
    Call_Finish(ret);

    if ( ret )
    {
        PlayerLevel[client] = oldLevel;
        return oldLevel;
    }

    if ( !BotCanWin && IsFakeClient(client) && (Level >= WeaponOrderCount) )
    {
        /* Bot can't win so just keep them at the last level */
        return oldLevel;
    }

    // Client got new level
    CurrentKillsPerWeap[client] = NULL;
    PlayerLevel[client] = Level;
    UTIL_RecalculateLeader(client, oldLevel, Level);
    
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

    TotalLevel += difference;

    if ( TotalLevel < 0 )
    {
        TotalLevel = NULL;
    }

    if ( GameWinner )
    {
        return Level;
    }

    if( !IsVotingCalled && Level >= WeaponOrderCount - VoteLevelLessWeaponCount )
    {
        /* Call map voting */
        IsVotingCalled = true;

        Call_StartForward(FwdVoteStart);
        Call_Finish();
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
        UTIL_PrintToUpperLeft(0, r, g, b, "%t", "Has won", Name);

        Call_StartForward(FwdWinner);
        Call_PushCell(client);
        Call_PushString(WeaponName[WeaponOrderId[Level - 1]][7]);
        Call_Finish();

        // TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
        // IsIntermissionCalled = true;
        GameWinner = client;

        UTIL_FreezeAllPlayer();
        ForceMapChange();
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

    return Level;
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
    new maxslots = GetMaxClients( );

    for(new i = 1, b; i <= maxslots; i++)
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
UTIL_FindGrenadeByName(client, const String:Grenade[], bool:drop = false, bool:remove = false)
{
    decl String:Class[64];
    new maxslots = GetMaxClients( );

    for(new i = 0, ent; i < 128; i += 4)
    {
        ent = GetEntDataEnt2(client, m_hMyWeapons + i);

        if(ent > maxslots && HACK_GetSlot(ent) == _:Slot_Grenade)
        {
            GetEdictClassname(ent, Class, sizeof(Class));

            if(strcmp(Class, Grenade, false) == 0)
            {
                if(drop)
                {
                    if ( remove )
                    {
                        RemovePlayerItem(client, ent);
                        RemoveEdict(ent);
                        return -1;
                    }
                    else
                    {
                        HACK_CSWeaponDrop(client, ent);
                    }
                }

                return ent;
            }
        }
    }

    return -1;
}

UTIL_GiveNextWeapon(client, level, diff = 1)
{
    if ( WarmupEnabled && WarmupKnifeOnly )
    {
        return;
    }

    new Weapons:WeapId = WeaponOrderId[level], Slots:slot = WeaponSlot[WeapId];
    if ( slot == Slot_Knife )
    {
        UTIL_ForceDropWeaponBySlot(client, Slot_Primary);
        UTIL_ForceDropWeaponBySlot(client, Slot_Secondary);
        FakeClientCommand(client, "use %s", WeaponName[WeapId]);
        return;
    }
    if ( slot == Slot_Grenade )
    {
        UTIL_ForceDropWeaponBySlot(client, Slot_Primary);
        UTIL_ForceDropWeaponBySlot(client, Slot_Secondary);
        if (NadeBonusWeaponId)
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
                new iAmmo = HACK_GetAmmoType(ent);

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
            GivePlayerItemWrapper(client, WeaponName[CSW_SMOKEGRENADE]);
        }
        if ( NadeFlash )
        {
            GivePlayerItemWrapper(client, WeaponName[CSW_FLASHBANG]);
        }
    }
    // slot == Slot_Primary || slot == Slot_Secondary 
    else
    {
        UTIL_ForceDropWeaponBySlot(client, slot);
        level = level - diff;
        if ( level > 0 )
        {
            new Weapons:LastWeapId = WeaponOrderId[level], Slots:Lastslot = WeaponSlot[LastWeapId];
            if ( (slot != Lastslot) && (Lastslot == Slot_Primary || Lastslot == Slot_Secondary) )
            {
                UTIL_ForceDropWeaponBySlot(client, Lastslot);
            }
        }
    }
    /* Give new weapon */
    new ent = GivePlayerItemWrapper(client, WeaponName[WeapId]);
    if ( slot == Slot_Primary || slot == Slot_Secondary ) 
    {
        g_ClientSlotEnt[client][slot] = ent;
    }
    FakeClientCommand(client, "use %s", WeaponName[WeapId]);
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
        SetEntProp(
            GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"), 
            Prop_Send, "m_iClip1", WeaponAmmo[WeaponId]
        );
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

        g_ClientSlotEnt[client][Slot_Primary] = -1;
        g_ClientSlotEnt[client][Slot_Secondary] = -1;
    }
}
