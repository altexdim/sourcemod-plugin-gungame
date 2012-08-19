OnHackStart()
{
    GameConf = LoadGameConfigFile("gungame.games");

    CreateEndMultiplayerGame();
    CreateDropHack();
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

CreateRemoveAmmoHack() {
    if (g_GameName == GameName:Css) {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "RemoveAmmo");
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        RemoveAmmo = EndPrepSDKCall();

        if (RemoveAmmo == INVALID_HANDLE) {
            SetFailState("Signature CBaseCombatCharacter::RemoveAmmo Failed. Please contact the author.");
        }
    }
}

HACK_RemoveAmmo(client, iCount, iAmmoIndex, weapon) {
    if (g_GameName == GameName:Css) {
        SDKCall(RemoveAmmo, client, iCount, iAmmoIndex);
    } else if (g_GameName == GameName:Csgo) {
        UTIL_RemoveAmmoNew(client, weapon);
    }
}

CreateDropHack() {
#if defined ENABLE_DISABLED_HACKS
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "CSWeaponDrop");
    PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    CSWeaponDrop = EndPrepSDKCall();

    if ( CSWeaponDrop == INVALID_HANDLE ) {
        new Handle:CssdmConf;
        CssdmConf = LoadGameConfigFile("cssdm.games");
        if ( CssdmConf != INVALID_HANDLE ) {
            StartPrepSDKCall(SDKCall_Entity);
            PrepSDKCall_SetFromConf(CssdmConf, SDKConf_Virtual, "CSWeaponDropPatch");
            PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
            PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
            PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
            CSWeaponDrop = EndPrepSDKCall();
            CloseHandle(CssdmConf);
        }
    }

    if(CSWeaponDrop == INVALID_HANDLE)
    {
        SetFailState("Signature CSSPlayer::CSWeaponDrop Failed. Please contact the author.");
    }
#endif
}

/**
 *@param client  client index
 *@param weapon      CBaseCombatWeapon entity index.
 */
HACK_CSWeaponDrop(client, weapon) {
    CS_DropWeapon(client, weapon, false, false);

#if defined ENABLE_DISABLED_HACKS
    SDKCall(CSWeaponDrop, client, weapon, true, false);
#endif
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

CreateRemoveHack() {
#if defined ENABLE_DISABLED_HACKS
    StartPrepSDKCall(SDKCall_Static);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Signature, "UTIL_Remove");
    PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
    UTILRemove = EndPrepSDKCall();

    if(UTILRemove == INVALID_HANDLE)
    {
        SetFailState("Signature CBaseEntity::UTIL_Remove Failed. Please contact author");
    }
#endif
}

/**
 * Removes from the world.
 *
 * @param entity        entity index
 * @noreturn
 */
HACK_Remove(entity) {
    if (entity) {
        AcceptEntityInput(entity, "Kill");
    }

#if defined ENABLE_DISABLED_HACKS
        /* Just incase 0 get passed */
        if(entity)
        {
            SDKCall(UTILRemove, entity);
        }
    }
#endif

}

