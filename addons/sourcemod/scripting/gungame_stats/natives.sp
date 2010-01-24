OnCreateNatives()
{
    CreateNative("GG_DisplayTop", __DisplayTop);
    CreateNative("GG_GetClientWins", __GetPlayerWins);
    CreateNative("GG_CountPlayersInStat", __CountPlayersInStat);
    CreateNative("GG_GetPlayerPlaceInStat", __GetPlayerPlaceInStat);
    CreateNative("GG_GetPlayerPlaceInTop10", __GetPlayerPlaceInTop10);
    CreateNative("GG_ShowRank", __ShowRank);
}

public __DisplayTop(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > MaxClients)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    ShowTopMenu(client);
    return 1;
}

public __ShowRank(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > MaxClients)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    ShowRank(client);
    return 1;
}

public __GetPlayerPlaceInStat(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > MaxClients)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return GetPlayerPlaceInStat(client);
}

public __CountPlayersInStat(Handle:plugin, numParams)
{
    return CountPlayersInStat();
}

public __GetPlayerWins(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);

    if(client < 1 || client > MaxClients)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return PlayerWinsData[client];
}

public __GetPlayerPlaceInTop10(Handle:plugin, numParams)
{
    new String:auth[64];
    GetNativeString(1, auth, sizeof(auth));
    return GetPlayerPlaceInTop10(auth);
}
