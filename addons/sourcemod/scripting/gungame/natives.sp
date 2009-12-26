OnCreateNatives()
{
    CreateNative("GG_GetClientLevel", __GetClientLevel);
    CreateNative("GG_GetMaxLevel", __GetMaxLevel);
    CreateNative("GG_SetMaxLevel", __SetMaxLevel);
    CreateNative("GG_AddAPoint", __AddAPoint);
    CreateNative("GG_RemoveAPoint", __RemoveAPoint);
    CreateNative("GG_GetClientPointLevel", __GetClientPointLevel);
    CreateNative("GG_GetClientMaxPointLevel", __GetClientMaxPointLevel);
    CreateNative("GG_AddALevel", __AddALevel);
    CreateNative("GG_RemoveALevel", __RemoveALevel);
    CreateNative("GG_GiveHandicapLevel", __GiveHandicapLevel);
    CreateNative("GG_IsClientCurrentWeapon", __IsClientCurrentWeapon);
    CreateNative("GG_SetWeaponLevel", __SetWeaponLevel);
    CreateNative("GG_SetWeaponLevelByName", __SetWeaponLevelByName);
    CreateNative("GG_GetWeaponIndex", __GetWeaponIndex);
    CreateNative("GG_IsGameCommenced", __IsGameCommenced);
}

public __IsGameCommenced(Handle:plugin, numParams)
{
    return GameCommenced;
}

public __SetMaxLevel(Handle:plugin, numParams)
{
    new level = GetNativeCell(1);

    if(level < 1 || level > GUNGAME_MAX_LEVEL)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Level out of range [%d]", level);
    }

    /* Error checking */

    if(!WeaponOrderName[level - 1][0])
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Level %d does not have a weapon set", level);
    }

    WeaponOrderCount = level;

    /* Clear any weapon index or name after the max level */
    for(new i = level; i < GUNGAME_MAX_LEVEL; i++)
    {
        WeaponOrderName[i][0] = '\0';
        WeaponOrderId[i] = Weapons:0;
    }

    return 1;
}

/**
 * Retrieve the weapon index for the weapon name.
 *
 * @param weapon        Name of weapon. short or long name.
 */
//native Weapons:GG_GetWeaponIndex(const String:weapon[]);
public __GetWeaponIndex(Handle:plugin, numParams)
{
    decl String:weapon[24];
    GetNativeString(1, weapon, sizeof(weapon));

    return _:UTIL_GetWeaponIndex(weapon);
}

public __GiveHandicapLevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new mode = GetNativeCell(2);

    if ( (client < 1) || (client > MaxClients) )
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    }

    if ( mode == 1 )
    {
        new Count = GetClientCount();

        if ( TotalLevel && Count )
        {   
            new level = TotalLevel / Count;
            if ( PlayerLevel[client] < level )
            {
                PlayerLevel[client] = level;
            }
        }
    }
    else if ( mode == 2 || mode == 3 )
    {
        new minimum = -1;
        new level = 0;
        for ( new i = 1; i <= MaxClients; i++ )
        {
            if ( IsClientInGame(i) )
            {
                if ( client == i || ( (mode == 3) && IsFakeClient(i) ) )
                {
                    continue;
                }
                level = PlayerLevel[i];
                if ( (minimum == -1) || (level < minimum) )
                {                 
                    minimum = level;
                }
            }
        }
        if ( (minimum != -1) && (PlayerLevel[client] < minimum) ) 
        {
            PlayerLevel[client] = minimum;
        }
    }
    
    return 1;
}

public __RemoveALevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    if(--CurrentLevelPerRound[client] < 0)
    {
        CurrentLevelPerRound[client] = 0;
    }
    CurrentLevelPerRoundTriple[client] = 0;
    
    new oldLevel = PlayerLevel[client];
    new level = UTIL_ChangeLevel(client, -1);
    if ( level == oldLevel )
    {
        return 0;
    }

    if(TurboMode)
    {
        UTIL_GiveNextWeapon(client, level, -1);
    }

    return 1;
}

public __AddALevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    /*  Do stuff */
    if(CurrentLevelPerRound[client] >= MaxLevelPerRound)
    {
        return 0;
    }
    
    CurrentLevelPerRound[client]++;

    new oldLevel = PlayerLevel[client];
    new level = UTIL_ChangeLevel(client, 1);
    if ( level == oldLevel )
    {
        return 0;
    }

    if(TurboMode)
    {
        UTIL_GiveNextWeapon(client, level);
    }

    CheckForTripleLevel(client);

    return level;
}

public __IsClientCurrentWeapon(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    decl String:Weapon[24];
    GetNativeString(2, Weapon, sizeof(Weapon));

    if(strcmp(Weapon, WeaponName[WeaponOrderId[PlayerLevel[client]]], false) == 0)
    {
        return 1;
    }

    return 0;
}

public __GetClientLevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return PlayerLevel[client] + 1;

}
public __GetMaxLevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return WeaponOrderCount;
}

public __AddAPoint(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    new level = PlayerLevel[client],
        killsPerLevel = CustomKillPerLevel[level],
        point = ++CurrentKillsPerWeap[client];
    if ( !killsPerLevel )
    {
        killsPerLevel = MinKillsPerLevel;
    }

    if(point < killsPerLevel)
    {
        return point;
    } /* They leveled up.*/

    if(CurrentLevelPerRound[client] >= MaxLevelPerRound)
    {
        return 0;
    }

    CurrentLevelPerRound[client]++;

    new oldLevel = PlayerLevel[client];
    level = UTIL_ChangeLevel(client, 1);
    if ( level == oldLevel )
    {
        return 0;
    }

    if(TurboMode)
    {
        UTIL_GiveNextWeapon(client, level);
    }

    CheckForTripleLevel(client);

    return 0;
}

public __RemoveAPoint(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    new level = PlayerLevel[client], 
        killsPerLevel = CustomKillPerLevel[level],
        point = --CurrentKillsPerWeap[client];
    if ( !killsPerLevel )
    {
        killsPerLevel = MinKillsPerLevel;
    }

    if(point >= 0)
    {
        return point;
    } else {
        CurrentKillsPerWeap[client] = killsPerLevel - 1;

        if(--CurrentLevelPerRound[client] < 0)
        {
            CurrentLevelPerRound[client] = 0;
        }
        CurrentLevelPerRoundTriple[client] = 0;
    }

    new oldLevel = PlayerLevel[client];
    level = UTIL_ChangeLevel(client, -1);
    if ( oldLevel == level )
    {
        return 0;
    }

    /* They lost a level if turbo mode is enabled return them back to the previous weapon */
    if(TurboMode)
    {
        UTIL_GiveNextWeapon(client, level, -1);
    }

    return killsPerLevel - 1;
}
public __GetClientPointLevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    return CurrentKillsPerWeap[client];
}
public __GetClientMaxPointLevel(Handle:plugin, numParams)
{
    new client = GetNativeCell(1);
    new maxslots = GetMaxClients( );

    if(client < 1 || client > maxslots)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
    } else if(!IsClientInGame(client)) {
        return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
    }

    new level = PlayerLevel[client], killsPerLevel = CustomKillPerLevel[level];

    return killsPerLevel ? killsPerLevel : MinKillsPerLevel;
}

public __SetWeaponLevel(Handle:plugin, numParams)
{
    new level = GetNativeCell(1);

    if(level < 1 || level > GUNGAME_MAX_LEVEL)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Level out of range [%d]", level);
    }

    new Weapons:weap = Weapons:GetNativeCell(2);

    if(weap < CSW_KNIFE || weap > CSW_SMOKEGRENADE)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Weapon index out of range [%d]", weap);
    }

    strcopy(WeaponOrderName[level - 1], sizeof(WeaponOrderName[]), WeaponName[weap]);
    WeaponOrderId[level - 1] = weap;

    return 1;
}

public __SetWeaponLevelByName(Handle:plugin, numParams)
{
    new level = GetNativeCell(1);

    if(level < 1 || level > GUNGAME_MAX_LEVEL)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Level out of range [%d]", level);
    }

    decl String:weapon[24];
    GetNativeString(2, weapon, sizeof(weapon));

    new Weapons:weap = Weapons:UTIL_GetWeaponIndex(weapon);

    if(weap < CSW_KNIFE || weap > CSW_SMOKEGRENADE)
    {
        return ThrowNativeError(SP_ERROR_NATIVE, "Weapon name is invalid [%s]", weapon);
    }

    strcopy(WeaponOrderName[level - 1], sizeof(WeaponOrderName[]), WeaponName[weap]);
    WeaponOrderId[level - 1] = weap;

    return 1;
}