public GG_OnWinner(client, const String:Weapon[])
{
    if(IsClientInGame(client) && !IsFakeClient(client))
    {
        ++PlayerWinsData[client];
        SavePlayerData(client);
        #if !defined SQL_SUPPORT
            CheckRank(client);
        #endif
    }
}

GetPlayerPlaceInTop10(const String:Auth[])
{
    for(new i = 0; i < MAX_RANK; i++)
    {
        if(strcmp(Auth, PlayerAuthid[i]) == 0)
        {
            return i;
        }
    }

    return -1;
}

#if !defined SQL_SUPPORT
CheckRank(client)
{
    new Wins = PlayerWinsData[client];
    decl String:Authid[64];
    GetClientAuthString(client, Authid, sizeof(Authid));

    new location = GetPlayerPlaceInTop10(Authid);

    // if client is not present in top 10
    for ( new i = 0; i < MAX_RANK; i++ )
    {
        if ( Wins > PlayerWins[i] )
        {
            /**
             * Winner Winner Winner
             */
            RankChange = true;
            if ( location != -1 ) // if client is present in top 10
            {
                PlayerWins[location] = Wins;
                if ( location != i )
                {
                    SwitchRanks(client, i, location, Authid);
                }
                else
                {
                    /* Update player name in the top10 */
                    GetClientName(client, PlayerName[location], sizeof(PlayerName[]));
                }
            }
            else // if client is not present in top 10
            {
                // Let shift old ranks up.
                ShiftRanksUp(client, Wins, i, Authid);
            }
            return;
        }
    }
}

SwitchRanks(client, New, Old, const String:Auth[64])
{
    new TempWins = PlayerWins[Old];

    PlayerWins[Old] = PlayerWins[New];
    PlayerName[Old] = PlayerName[New];
    PlayerAuthid[Old] = PlayerAuthid[New];

    /* Update player name in the top10 */
    GetClientName(client, PlayerName[New], sizeof(PlayerName[]));
    PlayerWins[New] = TempWins;
    PlayerAuthid[New] = Auth;
}

ShiftRanksUp(client, Wins, RankToReplace, const String:Auth[64])
{
    new b = MAX_RANK - 1, c;

    while(--b >= RankToReplace)
    {
        /* Makes sure there a rank in the slot before shift up otherwise stop */
        if((c = PlayerWins[b]) != 0)
        {
            PlayerWins[b + 1] = c;
            PlayerAuthid[b + 1] = PlayerAuthid[b];
            PlayerName[b + 1] = PlayerName[b];
        }
    }

    PlayerWins[RankToReplace] = Wins;
    GetClientName(client, PlayerName[RankToReplace], sizeof(PlayerName[]));
    PlayerAuthid[RankToReplace] = Auth;
}
#endif

