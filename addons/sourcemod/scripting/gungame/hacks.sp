OnHackStart() {
    GameConf = LoadGameConfigFile("gungame.games");

    CreateEndMultiplayerGame();
    CreateGetSlotHack();
    
    CloseHandle(GameConf);
}

CreateGetSlotHack() {
#if defined DISABLED_HACKS
    StartPrepSDKCall(SDKCall_Entity);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "GetSlot");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    GetSlot = EndPrepSDKCall();

    if(GetSlot == INVALID_HANDLE)
    {
        SetFailState("Virtual CBaseCombatWeapon::GetSlot Failed. Please contact the author.");
    }
#endif
}

stock HACK_GetSlot(entity) {
#if defined DISABLED_HACKS
    return SDKCall(GetSlot, entity);
#endif
}

CreateEndMultiplayerGame() {
#if defined DISABLED_HACKS
    StartPrepSDKCall(SDKCall_GameRules);
    PrepSDKCall_SetFromConf(GameConf, SDKConf_Virtual, "EndMultiplayerGame");
    EndMultiplayerGame = EndPrepSDKCall();

    if (EndMultiplayerGame == INVALID_HANDLE) {
        SetFailState("Virtual CGameRules::EndMultiplayerGame Failed. Please contact the author.");
    }
#endif
}

/**
 * Forces multiplayer game to end so it can go threw intermission and map change.
 *
 * @noparam
 * @noreturn
 */
HACK_EndMultiplayerGame() {
#if defined DISABLED_HACKS
    SDKCall(EndMultiplayerGame);
#endif
    new ent = CreateEntityByName("game_end");
    DispatchSpawn(ent);
    AcceptEntityInput(ent, "EndGame");
}
