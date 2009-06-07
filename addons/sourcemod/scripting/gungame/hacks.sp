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

OnHackStart()
{
    GameConf = LoadGameConfigFile("gungame.games");

    CreateEndMultiplayerGame();
    CreateRemoveHack();
    CreateDropHack();
    CreateGiveAmmoHack();
    CreateGetAmmoTypeHack();
    CreateRemoveAmmoHack();
    CreateGetSlotHack();

    #if defined HACKS
    SDKTools_GameConf = LoadGameConfigFile("sdktools.games");

    //CreateRemovePlayerItem();
    //CreateGiveNamedItem();
    //CreateHackWeapon_GetSlot();
    //CreateGameEndHack();
    //CreateRemoveAllAmmo();
    CreateRespawnHack();
    //CreateDeleteHack();
    CloseHandle(SDKTools_GameConf);

    RegConsoleCmd("run", CmdRun);
    #endif

    CloseHandle(GameConf);
}
#if defined HACKS
public Action:CmdRun(client, args)
{
    new ent = GetPlayerWeaponSlot(client, _:Slot_Secondary);

    if(ent != -1)
    {
        PrintToChat(client, "Found Glock");

        new iAmmo = HACK_GetAmmoType(ent);

        if(iAmmo != -1)
        {
            PrintToChat(client, "Found AmmoType");

            HACK_RemoveAmmo(client, 70, iAmmo);
        }
    }
    return Plugin_Handled;
}

CreateDeleteHack()
{
    StartPrepSDKCall(SDKCall_Entity);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "Delete");
    Delete = EndPrepSDKCall();

    if(Delete == INVALID_HANDLE)
    {
        SetFailState("Virtual CBaseCombatWeapon::Delete failed. Please contact the author");
    }
}

CreateRemovePlayerItem()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(SDKTools_GameConf, SDKConf_Virtual, "RemovePlayerItem");
    PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
    _RemovePlayerItem = EndPrepSDKCall();

    if(_RemovePlayerItem == INVALID_HANDLE)
    {
        SetFailState("Virtual CBasePlayer::RemovePlayerItem failed. Please contact the author");
    }
}

CreateRespawnHack()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "RoundRespawn");
    RoundRespawn = EndPrepSDKCall();
}

CreateRemoveAllAmmo()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "RemoveAllAmmo");
    RemoveAllAmmo = EndPrepSDKCall();
}

CreateHackWeapon_GetSlot()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "Weapon_GetSlot");
    PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    Weapon_GetSlot = EndPrepSDKCall();

    if(Weapon_GetSlot == INVALID_HANDLE)
    {
        SetFailState("Signature CBaseCombatCharacter::Weapon_GetSlot Failed. Please contact the author.");
    }
}

CreateGiveNamedItem()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "GiveNamedItem");
    PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    GiveNamedItem = EndPrepSDKCall();

    if(GiveNamedItem == INVALID_HANDLE)
    {
        SetFailState("Signature CBasePlayer::GiveNamedItem Failed. Please contact the author.");
    }
}

CreateGameEndHack()
{
    StartPrepSDKCall(SDKCall_Static);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "InputGameEnd");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    InputGameEnd = EndPrepSDKCall();

    if(InputGameEnd == INVALID_HANDLE)
    {
        SetFailState("Signature CGameEnd::InputGameEnd Failed. Please contact the author.");
    }
}
#endif

CreateGetSlotHack()
{
    StartPrepSDKCall(SDKCall_Entity);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "GetSlot");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    GetSlot = EndPrepSDKCall();

    if(GetSlot == INVALID_HANDLE)
    {
        SetFailState("Virtual CBaseCombatWeapon::GetSlot Failed. Please contact the author.");
    }
}

HACK_GetSlot(entity)
{
    return SDKCall(GetSlot, entity);
}

CreateEndMultiplayerGame()
{
    StartPrepSDKCall(SDKCall_GameRules);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "EndMultiplayerGame");
    EndMultiplayerGame = EndPrepSDKCall();

    if(EndMultiplayerGame == INVALID_HANDLE)
    {
        SetFailState("Virtual CGameRules::EndMultiplayerGame Failed. Please contact the author.");
    }
}

CreateRemoveAmmoHack()
{

    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "RemoveAmmo");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    RemoveAmmo = EndPrepSDKCall();

    if(RemoveAmmo == INVALID_HANDLE)
    {
        SetFailState("Signature CBaseCombatCharacter::RemoveAmmo Failed. Please contact the author.");
    }
}

HACK_RemoveAmmo(client, iCount, iAmmoIndex)
{
    SDKCall(RemoveAmmo, client, iCount, iAmmoIndex);
}

CreateGetAmmoTypeHack()
{
    StartPrepSDKCall(SDKCall_Entity);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "GetPrimaryAmmoType");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    GetAmmoType = EndPrepSDKCall();

    if(GetAmmoType == INVALID_HANDLE)
    {
        SetFailState("Virtual CBaseCombatWeapon::GetPrimaryAmmoType Failed. Please contact the author.");
    }
}

CreateGiveAmmoHack()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "GiveAmmo");
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    GiveAmmo = EndPrepSDKCall();

    if(GiveAmmo == INVALID_HANDLE)
    {
        SetFailState("Virtual CBaseCombatCharacter::GiveAmmo Failed. Please contact the author.");
    }
}

CreateRemoveHack()
{
    StartPrepSDKCall(SDKCall_Static);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "UTIL_Remove");
    PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
    UTILRemove = EndPrepSDKCall();

    if(UTILRemove == INVALID_HANDLE)
    {
        SetFailState("Signature CBaseEntity::UTIL_Remove Failed. Please contact author");
    }
}

CreateDropHack()
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "CSWeaponDrop");
    PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    CSWeaponDrop = EndPrepSDKCall();

    if(CSWeaponDrop == INVALID_HANDLE)
    {
        SetFailState("Signature CSSPlayer::CSWeaponDrop Failed. Please contact the author.");
    }
}

#if defined HACKS
/**
 * Force the game to end and change map with intermission.
 *
 * @noparam
 * @noreturn
 */
HACK_ForceGameEnd()
{
    SDKCall(InputGameEnd, 0);
}

/**
 * Give ammo to a client.
 *
 * @param client        player index
 * @param iCount        Ammo amount
 * @param iAmmoIndex    Ammo type index (use HACK_GetAmmoType() to get the ammo type)
 * @param bSuppressSound    Allow the ammo pickup sound or not
 *
 * @noreturn
 *
 */
HACK_GiveAmmo(client, iCount, iAmmoIndex, bool:bSuppressSound = false)
{
    SDKCall(GiveAmmo, client, iCount, iAmmoIndex, bSuppressSound);
}


HACK_GiveNamedItem(client, const String:item[])
{
    return SDKCall(GiveNamedItem, client, item, 0);
}

HACK_Weapon_GetSlot(client, slot)
{
    return SDKCall(Weapon_GetSlot, client, slot);
}


HACK_RemovePlayerItem(client, ent)
{
    SDKCall(_RemovePlayerItem, client, ent);
}

HACK_Respawn(client)
{
    SDKCall(RoundRespawn, client);
}

HACK_RemoveAllAmmo(client)
{
    SDKCall(RemoveAllAmmo, client);
}

HACK_Delete(ent)
{
    SDKCall(Delete, ent);
}
#endif

/**
 *@param client     client index
 *@param weapon         CBaseCombatWeapon entity index.
 */
HACK_CSWeaponDrop(client, weapon)
{
    SDKCall(CSWeaponDrop, client, weapon, true, false);
}

/**
 * Removes from the world.
 *
 * @param entity        entity index
 * @noreturn
 */
HACK_Remove(entity)
{
    /* Just incase 0 get passed */
    if(entity)
    {
        SDKCall(UTILRemove, entity);
    }
}

/**
 * Returns the ammo type for the weapon
 *
 * @param weapon        Weapon entity index
 * @return          Ammo Type index
 */
HACK_GetAmmoType(weapon)
{
    return SDKCall(GetAmmoType, weapon);
}

/**
 * Forces multiplayer game to end so it can go threw intermission and map change.
 *
 * @noparam
 * @noreturn
 */
HACK_EndMultiplayerGame()
{
    SDKCall(EndMultiplayerGame);
}