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
    CreateDropHack();
    CreateGetAmmoTypeHack();
    CreateRemoveAmmoHack();
    CreateGetSlotHack();
    CreateRemoveHack();
    
    CloseHandle(GameConf);
}

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

/**
 *@param client     client index
 *@param weapon         CBaseCombatWeapon entity index.
 */
HACK_CSWeaponDrop(client, weapon)
{
    SDKCall(CSWeaponDrop, client, weapon, true, false);
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

