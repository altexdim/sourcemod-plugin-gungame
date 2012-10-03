WinnerEffectsStart(winner) {
    if (g_Cfg_WinnerEffect == 1) {
        WinnerEffect(winner);
    } else {
        UTIL_FreezeAllPlayer();
    }
}

WinnerEffectsStartOne(winner, client) {
    if (g_Cfg_WinnerEffect == 1) {
        WinnerEffectOne(winner, client);
    } else {
        UTIL_FreezePlayer(client);
    }
}


WinnerEffect(winner) {
    for (new i=1; i <= MaxClients; i++) {
        if (IsClientInGame(i) && IsPlayerAlive(i)) {
            WinnerEffectOne(winner, i);
        }
    }
}

WinnerEffectOne(winner, client) {
    SetPlayerWinnerEffectAll(client);
    if (winner==client) {
        SetPlayerWinnerEffectWinner(client);
    }
}

SetPlayerWinnerEffectAll(client) {
    // fly
    SetEntityGravity(client, 0.001);

    new Float:pos[3], Float:vel[3];
    GetClientEyePosition(client, pos);

    vel[0] = GetRandomFloat(-10.0, 10.0);
    vel[1] = GetRandomFloat(-10.0, 10.0);
    vel[2] = GetRandomFloat(70.0, 120.0);

    TeleportEntity(client, pos, NULL_VECTOR, vel);
}

SetPlayerWinnerEffectWinner(client) {
    SetPlayerWinnerEffectWinnerRepeate(client);
}

SetPlayerWinnerEffectWinnerRepeate(client) {
    CreateTimer(0.1, Timer_SetPlayerWinnerEffectWinner, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Timer_SetPlayerWinnerEffectWinner(Handle:timer, any:data) {
    if (!IsClientInGame(data)||!IsPlayerAlive(data)) {
        return Plugin_Stop;
    }
    SetPlayerWinnerEffectWinnerReal(data);
    return Plugin_Continue;
}

SetPlayerWinnerEffectWinnerReal(client) {
    // shine    
    new Float:vec[3];
    GetClientAbsOrigin(client, vec);
    vec[2] += 35;

    TE_SetupGlowSprite(vec, g_GlowSprite, 0.5, 4.0, 70);
    TE_SendToAll();
}

OnMapStartEffects() {
    if (g_GameName == GameName:Csgo) {
        g_GlowSprite = PrecacheModel("sprites/ledglow.vmt");
    } else {
        g_GlowSprite = PrecacheModel("sprites/orangeglow1.vmt");
    }
}
