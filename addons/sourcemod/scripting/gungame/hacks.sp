OnHackStart() {
    GameConf = LoadGameConfigFile("gungame.games");

    CreateEndMultiplayerGame();
    CreateGetSlotHack();
    
    CloseHandle(GameConf);
}

CreateGetSlotHack() {
    StartPrepSDKCall(SDKCall_Entity);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "GetSlot");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    GetSlot = EndPrepSDKCall();

    if(GetSlot == INVALID_HANDLE)
    {
        SetFailState("Virtual CBaseCombatWeapon::GetSlot Failed. Please contact the author.");
    }
}

HACK_GetSlot(entity) {
    return SDKCall(GetSlot, entity);
}

CreateEndMultiplayerGame() {
    StartPrepSDKCall(SDKCall_GameRules);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "EndMultiplayerGame");
    EndMultiplayerGame = EndPrepSDKCall();

    if (EndMultiplayerGame == INVALID_HANDLE) {
        SetFailState("Virtual CGameRules::EndMultiplayerGame Failed. Please contact the author.");
    }
}

/**
 * Forces multiplayer game to end so it can go threw intermission and map change.
 *
 * @noparam
 * @noreturn
 */
HACK_EndMultiplayerGame() {
    SDKCall(EndMultiplayerGame);
}
