//#define SQL_DEBUG

// non-threaded
SqlConnect()
{
    if ( g_DbConnection != INVALID_HANDLE )
    {
        return;
    }
    
    decl String:error[256];
    g_DbConnection = SQL_Connect("storage-local", false, error, sizeof(error));
    
    if ( g_DbConnection == INVALID_HANDLE )
    {
        SetFailState("Unable to connect to database (%s)", error);
        return;
    }
    
    new String:ident[16];
    SQL_ReadDriver(g_DbConnection, ident, sizeof(ident));
    #if defined MYSQL_SUPPORT
    if ( strcmp(ident, "mysql", false) != 0 )
    #endif
    #if defined SQLITE_SUPPORT
    if ( strcmp(ident, "sqlite", false) != 0 )
    #endif
    {
        CloseHandle(g_DbConnection);
        g_DbConnection = INVALID_HANDLE;
        SetFailState("Invalid DB-Type (%s)", ident);
        return;
    }
    
    SQL_LockDatabase(g_DbConnection);
    
    new bool:tableExists = false;
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", g_sql_checkTableExists);
    #endif
    new Handle:result = SQL_Query(g_DbConnection, g_sql_checkTableExists);
    if ( result == INVALID_HANDLE )
    {
        SQL_GetError(g_DbConnection, error, sizeof(error));
        LogError("Failed to check table exists (error: %s)", error);
        SQL_UnlockDatabase(g_DbConnection);
        return;
    } else {
        tableExists = bool:SQL_GetRowCount(result);
        CloseHandle(result);
    }
    
    if ( !tableExists )
    {
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", g_sql_createPlayerTable);
        #endif
        if ( !SQL_FastQuery(g_DbConnection, g_sql_createPlayerTable) )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Could not create players table (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            return;
        }
        #if defined SQLITE_SUPPORT
            #if defined SQL_DEBUG
                LogError("[DEBUG-SQL] %s", g_sql_createPlayerTableIndex1);
            #endif
            if ( !SQL_FastQuery(g_DbConnection, g_sql_createPlayerTableIndex1) )
            {
                SQL_GetError(g_DbConnection, error, sizeof(error));
                LogError("Could not create players table index 1 (error: %s)", error);
                SQL_UnlockDatabase(g_DbConnection);
                return;
            }
            #if defined SQL_DEBUG
                LogError("[DEBUG-SQL] %s", g_sql_createPlayerTableIndex2);
            #endif
            if ( !SQL_FastQuery(g_DbConnection, g_sql_createPlayerTableIndex2) )
            {
                SQL_GetError(g_DbConnection, error, sizeof(error));
                LogError("Could not create players table index 2 (error: %s)", error);
                SQL_UnlockDatabase(g_DbConnection);
                return;
            }
        #endif
    }
    SQL_UnlockDatabase(g_DbConnection);
}

// threaded
SavePlayerData(client)
{
    new wins = PlayerWinsData[client];
    if ( !wins )
    {
        return;
    }
    
    decl String:auth[64], String:name[MAX_NAME_SIZE];
    GetClientAuthString(client, auth, sizeof(auth));
    GetClientName(client, name, sizeof(name));

    /* Create enough space to make sure our string is quoted properly  */
    new bufferLen = strlen(name) * 2 + 1;
    new String:newName[bufferLen];
 
    /* Ask the SQL driver to make sure our string is safely quoted */
    SQL_EscapeString(g_DbConnection, name, newName, bufferLen);
        
    decl String:query[1024];
    Format(query, sizeof(query), wins == 1 ? g_sql_insertPlayer : g_sql_updatePlayerByAuth, wins, name, auth);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    SQL_TQuery(g_DbConnection, T_SavePlayerData, query);
}

// threaded
public T_SavePlayerData(Handle:owner, Handle:result, const String:error[], any:data)
{
    if ( result == INVALID_HANDLE )
    {
        LogError("Failed to save player data (error: %s)", error);
        return;
    }

    // Reload top10 data after winner has beed updated in the database
    LoadRank();
}

// non-threaded
GetPlayerPlaceInStat(client)
{
    // get from cache
    if ( !PlayerWinsData[client] || PlayerPlaceData[client] )
    {
        return PlayerPlaceData[client];
    }
    // get from database
    PlayerPlaceData[client] = GetPlayerPlace(client);
    return PlayerPlaceData[client];
}

// non-threaded
GetPlayerPlace(client)
{
    decl String:query[1024];
    Format(query, sizeof(query), g_sql_getPlayerPlaceByWins, PlayerWinsData[client]);
    SQL_LockDatabase(g_DbConnection);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    new Handle:result = SQL_Query(g_DbConnection, query);
    if ( result == INVALID_HANDLE )
    {
        new String:error[255];
        SQL_GetError(g_DbConnection, error, sizeof(error));
        LogError("Failed get player place in stats (error: %s)", error);
        SQL_UnlockDatabase(g_DbConnection);
        return 0;
    }
    SQL_UnlockDatabase(g_DbConnection);
    new place;
    if ( SQL_FetchRow(result) )
    {
        place = SQL_FetchInt(result, 0) + 1;
    }
    CloseHandle(result);
    return place;
}

CountPlayersInStat()
{
    return TotalWinners;
}

// threaded
CountWinners()
{
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", g_sql_getPlayersCount);
    #endif
    SQL_TQuery(g_DbConnection, T_CountWinners, g_sql_getPlayersCount);
}

public T_CountWinners(Handle:owner, Handle:result, const String:error[], any:data)
{
    if ( result == INVALID_HANDLE )
    {
        LogError("Failed to count players in stat (error: %s)", error);
        return;
    }
    new count = 0;
    if ( SQL_FetchRow(result) )
    {
        count = SQL_FetchInt(result, 0);
    }
    TotalWinners = count;
}

// threaded
RetrieveKeyValues(client, const String:auth[])
{
    if ( auth[0] == 'B' )
    {
        return;
    }
    decl String:query[1024];
    Format(query, sizeof(query), g_sql_getPlayerByAuth, auth);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    SQL_TQuery(g_DbConnection, T_RetrieveKeyValues, query, client);
}

public T_RetrieveKeyValues(Handle:owner, Handle:result, const String:error[], any:client)
{
    /* Make sure the client didn't disconnect while the thread was running */
    if ( !IsClientConnected(client) )
    {
        return;
    }
    if ( result == INVALID_HANDLE )
    {
        LogError("Failed to retrieve player by auth (error: %s)", error);
        return;
    }
    if ( SQL_FetchRow(result) )
    {
        new id = SQL_FetchInt(result, 0);
        PlayerWinsData[client] = SQL_FetchInt(result, 1);
        
        // update player timestamp
        decl String:query[1024];
        Format(query, sizeof(query), g_sql_updatePlayerTsById, id);
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", query);
        #endif
        SQL_TQuery(g_DbConnection, T_FastQueryResult, query);
    }
}

public T_FastQueryResult(Handle:owner, Handle:result, const String:error[], any:data)
{
    if ( result == INVALID_HANDLE )
    {
        LogError("Fast query failed (error: %s)", error);
        return;
    }
    // reqest was successfull
}

// threaded
SavePlayerDataInfo()
{
    decl String:query[1024];
    #if defined MYSQL_SUPPORT
        Format(query, sizeof(query), g_sql_prunePlayers, Prune);
    #endif
    #if defined SQLITE_SUPPORT
        Format(query, sizeof(query), g_sql_prunePlayers, GetTime() - Prune*86400);
    #endif
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    SQL_TQuery(g_DbConnection, T_SavePlayerDataInfo, query);
}

public T_SavePlayerDataInfo(Handle:owner, Handle:result, const String:error[], any:data)
{
    if ( result == INVALID_HANDLE )
    {
        LogError("Could not prune players (error: %s)", error);
        return;
    }
}

OnCreateKeyValues()
{
    SqlConnect();
    LoadRank();
}
// non-threaded
public Action:_CmdImport(client, args)
{
    decl String:EsFile[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, EsFile, sizeof(EsFile), "data/gungame/es_gg_winners_db.txt");

    if ( !FileExists(EsFile) )
    {
        ReplyToCommand(client, "[GunGame] es_gg_winners_db.txt does not exists to be imported.");
        return Plugin_Handled;
    }

    new Handle:KvGunGame = CreateKeyValues("gg_winners", BLANK, BLANK);
    FileToKeyValues(KvGunGame, EsFile);

    /* Go to first SubKey */
    if ( !KvGotoFirstSubKey(KvGunGame) )
    {
        ReplyToCommand(client, "[GunGame] You have no player data to import.");
        return Plugin_Handled;
    }

    decl String:query[1024], String:error[255];
    decl Wins, String:Name[64];
    decl ImportedWins, String:Auth[64];

    do
    {
        KvGetSectionName(KvGunGame, Auth, sizeof(Auth));
        ImportedWins = KvGetNum(KvGunGame, "wins");

        if ( !ImportedWins || Auth[0] != 'S' )
        {
            continue;
        }

        // Load player data        
        SQL_LockDatabase(g_DbConnection);
        Format(query, sizeof(query), g_sql_getPlayerByAuth, Auth);
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", query);
        #endif
        new Handle:result = SQL_Query(g_DbConnection, query);
        if ( result == INVALID_HANDLE )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Failed to get player (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            ReplyToCommand(client, "[GunGame] Import finished with sql error");
            CloseHandle(KvGunGame);
            return Plugin_Handled;
        }
        SQL_UnlockDatabase(g_DbConnection);
        if ( SQL_FetchRow(result) )
        {
            Wins = SQL_FetchInt(result, 1);
            SQL_FetchString(result, 2, Name, sizeof(Name));
        }
        else
        {
            Wins = 0;
        }
        CloseHandle(result);
        
        if ( Wins ) {
            Format(query, sizeof(query), g_sql_updatePlayerByAuth, Wins + ImportedWins, Name, Auth);
        } else {
            KvGetString(KvGunGame, "name", Name, sizeof(Name));
            Format(query, sizeof(query), g_sql_insertPlayer, ImportedWins, Name, Auth);
        }

        // SavePlayerData
        SQL_LockDatabase(g_DbConnection);
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", query);
        #endif
        if ( !SQL_FastQuery(g_DbConnection, query) )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Could not save player (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            ReplyToCommand(client, "[GunGame] Import finished with sql error");
            CloseHandle(KvGunGame);
            return Plugin_Handled;
        }
        SQL_UnlockDatabase(g_DbConnection);
    }
    while(KvGotoNextKey(KvGunGame));

    CloseHandle(KvGunGame);
    
    /* Reload the players wins in memory */
    for ( new i = 1; i <= MaxClients; i++ )
    {
        if ( IsClientAuthorized(i) )
        {
            GetClientAuthString(i, Auth, sizeof(Auth));
            RetrieveKeyValues(i, Auth);
        }
    }

    ReplyToCommand(client, "[GunGame] Import of es player data completed. Please run gg_rebuild to update the top10.");

    return Plugin_Handled;
}

// non-threaded
public Action:_CmdImportDb(client, args)
{
    decl String:File[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, File, sizeof(File), "data/gungame/playerdata.txt");

    if ( !FileExists(File) )
    {
        ReplyToCommand(client, "[GunGame] playerdata.txt does not exists to be imported.");
        return Plugin_Handled;
    }

    new Handle:KvGunGame = CreateKeyValues("gg_PlayerData", BLANK, BLANK);
    FileToKeyValues(KvGunGame, File);

    /* Go to first SubKey */
    if ( !KvGotoFirstSubKey(KvGunGame) )
    {
        ReplyToCommand(client, "[GunGame] You have no player data to import.");
        return Plugin_Handled;
    }

    decl String:query[1024], String:error[255];
    decl Wins, String:Name[64];
    decl ImportedWins, String:Auth[64];

    do
    {
        KvGetSectionName(KvGunGame, Auth, sizeof(Auth));
        ImportedWins = KvGetNum(KvGunGame, "Wins");

        if ( !ImportedWins || Auth[0] != 'S' )
        {
            continue;
        }

        // Load player data        
        SQL_LockDatabase(g_DbConnection);
        Format(query, sizeof(query), g_sql_getPlayerByAuth, Auth);
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", query);
        #endif
        new Handle:result = SQL_Query(g_DbConnection, query);
        if ( result == INVALID_HANDLE )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Failed to get player (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            ReplyToCommand(client, "[GunGame] Import finished with sql error");
            CloseHandle(KvGunGame);
            return Plugin_Handled;
        }
        SQL_UnlockDatabase(g_DbConnection);
        if ( SQL_FetchRow(result) )
        {
            Wins = SQL_FetchInt(result, 1);
            SQL_FetchString(result, 2, Name, sizeof(Name));
        }
        else
        {
            Wins = 0;
        }
        CloseHandle(result);
        
        if ( Wins ) {
            Format(query, sizeof(query), g_sql_updatePlayerByAuth, Wins + ImportedWins, Name, Auth);
        } else {
            KvGetString(KvGunGame, "Name", Name, sizeof(Name));
            Format(query, sizeof(query), g_sql_insertPlayer, ImportedWins, Name, Auth);
        }

        // SavePlayerData
        SQL_LockDatabase(g_DbConnection);
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", query);
        #endif
        if ( !SQL_FastQuery(g_DbConnection, query) )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Could not save player (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            ReplyToCommand(client, "[GunGame] Import finished with sql error");
            CloseHandle(KvGunGame);
            return Plugin_Handled;
        }
        SQL_UnlockDatabase(g_DbConnection);
    }
    while(KvGotoNextKey(KvGunGame));

    CloseHandle(KvGunGame);
    
    /* Reload the players wins in memory */
    for ( new i = 1; i <= MaxClients; i++ )
    {
        if ( IsClientAuthorized(i) )
        {
            GetClientAuthString(i, Auth, sizeof(Auth));
            RetrieveKeyValues(i, Auth);
        }
    }

    ReplyToCommand(client, "[GunGame] Import of player data completed. Please run gg_rebuild to update the top10.");

    return Plugin_Handled;
}

// threaded
public Action:_CmdRebuild(client, args)
{
    LoadRank();
    ReplyToCommand(client, "[GunGame] Top10 has been rebuilt");
    return Plugin_Handled;
}

// non-threaded
public Action:_CmdReset(client, args)
{
    decl String:error[256];
    SQL_LockDatabase(g_DbConnection);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", g_sql_dropPlayerTable);
    #endif
    if ( !SQL_FastQuery(g_DbConnection, g_sql_dropPlayerTable) )
    {
        SQL_GetError(g_DbConnection, error, sizeof(error));
        LogError("Could not drop players table (error: %s)", error);
        SQL_UnlockDatabase(g_DbConnection);
        ReplyToCommand(client, "[GunGame] Error reseting stats.");
        return Plugin_Handled;
    }
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", g_sql_createPlayerTable);
    #endif
    if ( !SQL_FastQuery(g_DbConnection, g_sql_createPlayerTable) )
    {
        SQL_GetError(g_DbConnection, error, sizeof(error));
        LogError("Could not create players table (error: %s)", error);
        SQL_UnlockDatabase(g_DbConnection);
        ReplyToCommand(client, "[GunGame] Error reseting stats.");
        return Plugin_Handled;
    }
    #if defined SQLITE_SUPPORT
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", g_sql_createPlayerTableIndex1);
        #endif
        if ( !SQL_FastQuery(g_DbConnection, g_sql_createPlayerTableIndex1) )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Could not create players table index 1 (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            return Plugin_Handled;
        }
        #if defined SQL_DEBUG
            LogError("[DEBUG-SQL] %s", g_sql_createPlayerTableIndex2);
        #endif
        if ( !SQL_FastQuery(g_DbConnection, g_sql_createPlayerTableIndex2) )
        {
            SQL_GetError(g_DbConnection, error, sizeof(error));
            LogError("Could not create players table index 2 (error: %s)", error);
            SQL_UnlockDatabase(g_DbConnection);
            return Plugin_Handled;
        }
    #endif
    SQL_UnlockDatabase(g_DbConnection);
    ReplyToCommand(client, "[GunGame] Stats has been reseted.");
    
    // reset current players data
    for (new i = 1; i <= MAXPLAYERS; i++)
    {
        PlayerWinsData[i] = 0;
        PlayerPlaceData[i] = 0;
    }
    
    // reset top 10 data
    HasRank = false;
    TotalWinners = 0;
    for (new i = 0; i < MAX_RANK; i++)
    {
        PlayerWins[i] = 0;
    }
    
    return Plugin_Handled;
}

// threaded
LoadRank()
{
    // reset top 10 data
    HasRank = false;
    TotalWinners = 0;
    for (new i = 0; i < MAX_RANK; i++)
    {
        PlayerWins[i] = 0;
    }
    
    CountWinners();
    LoadTop10Data();
}

// threaded
LoadTop10Data()
{
    decl String:query[1024];
    Format(query, sizeof(query), g_sql_getTop10Players, 10, 0);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    SQL_TQuery(g_DbConnection, T_LoadTop10Data, query);
}

public T_LoadTop10Data(Handle:owner, Handle:result, const String:error[], any:data)
{
    if ( result == INVALID_HANDLE )
    {
        LogError("Failed to load rank data (error: %s)", error);
        return;
    }
    
    new i = 0;
    HasRank = bool:SQL_GetRowCount(result);
    while ( SQL_FetchRow(result) )
    {
        PlayerWins[i] = SQL_FetchInt(result, 1);
        SQL_FetchString(result, 2, PlayerName[i], sizeof(PlayerName[]));
        SQL_FetchString(result, 3, PlayerAuthid[i], sizeof(PlayerAuthid[]));
        i++;
    }
}

// threaded
ShowRank(client)
{
    new wins = PlayerWinsData[client];
    if ( !wins || PlayerPlaceData[client] )
    {
        ShowRankInChat(client);
        return;
    }
    
    decl String:query[1024];
    Format(query, sizeof(query), g_sql_getPlayerPlaceByWins, wins);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    SQL_TQuery(g_DbConnection, T_ShowRank, query, client);
}

public T_ShowRank(Handle:owner, Handle:result, const String:error[], any:client)
{
    /* Make sure the client didn't disconnect while the thread was running */
    if ( !IsClientConnected(client) )
    {
        return;
    }
    if ( result == INVALID_HANDLE )
    {
        LogError("Failed to retrieve player place by wins (error: %s)", error);
        return;
    }
    if ( SQL_FetchRow(result) )
    {
        PlayerPlaceData[client] = SQL_FetchInt(result, 0) + 1;
        ShowRankInChat(client);
    }
}

ShowRankInChat(client)
{
    decl String:name[MAX_NAME_SIZE];
    GetClientName(client, name, sizeof(name));
    if ( !PlayerPlaceData[client] )
    {
        CPrintToChatAllEx(client, "%t", "Rank: not ranked", name);
    }
    else
    {
        for ( new i = 1; i <= MaxClients; i++ )
        {
            if ( IsClientInGame(i) && !IsFakeClient(i) )
            {
                decl String:subtext[64];
                SetGlobalTransTarget(i);
                FormatLanguageNumberTextEx(i, subtext, sizeof(subtext), PlayerWinsData[client], "with wins");
                CPrintToChatEx(i, client, "%t", "Rank: rank", name, PlayerPlaceData[client], subtext, TotalWinners);
            }
        }
    }
}

