#if !defined SQL_SUPPORT
ShowTopMenu(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];

    new Handle:Top = CreatePanel();

    Format(text, sizeof(text), "%t", "TopPanel: Top short");
    SetPanelTitle(Top, text);
    DrawPanelText(Top, BLANK_SPACE);

    if ( !HasRank )
    {
        Format(text, sizeof(text), "%t", "TopPanel: There are currently no players in the top");
        DrawPanelText(Top, text);
    } else {
        decl String:subtext[64];
        for(new i = 0; i < MAX_RANK; i++)
        {
            if(PlayerWins[i])
            {
                FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), PlayerWins[i], "wins");
                Format(text, sizeof(text), "%t", "TopPanel: Place Name Wins", i + 1, PlayerName[i], subtext);
                DrawPanelText(Top, text);
            }
        }
    }

    DrawPanelText(Top, BLANK_SPACE);
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(Top, text, ITEMDRAW_CONTROL);
    SendPanelToClient(Top, client, EmptyHandler, GUNGAME_MENU_TIME);
    CloseHandle(Top);
}

public EmptyHandler(Handle:menu, MenuAction:action, param1, param2)
{
    /* Don't care what they pressed. */
}
#endif

#if defined SQL_SUPPORT
// threaded
DisplayTopMenu(client)
{
    new offset, itemsOnPage = 10;
    offset = ClientOnPage[client] * itemsOnPage;

    if ( ( offset < 0 ) || ( offset >= TotalWinners ) ) {
        offset = 0;
        ClientOnPage[client] = 0;
    }
    decl String:query[1024];
    Format(query, sizeof(query), g_sql_getTopPlayers, itemsOnPage, offset);
    #if defined SQL_DEBUG
        LogError("[DEBUG-SQL] %s", query);
    #endif
    SQL_TQuery(g_DbConnection, T_DisplayTopMenu, query, client);
}

public T_DisplayTopMenu(Handle:owner, Handle:result, const String:error[], any:client)
{
    if ( !IsClientConnected(client) )
    {
        return;
    }
    if ( result == INVALID_HANDLE )
    {
        LogError("Failed to retrieve top players (error: %s)", error);
        return;
    }
    
    new offset, itemsOnPage = 10;
    offset = ClientOnPage[client] * itemsOnPage;

    if ( ( offset < 0 ) || ( offset >= TotalWinners ) ) {
        offset = 0;
        ClientOnPage[client] = 0;
    }
        
    new end, pages;
    end = offset + itemsOnPage;
    if ( end > TotalWinners ) {
        end = TotalWinners;
    }
    pages = RoundToCeil(Float:TotalWinners/Float:itemsOnPage);

    SetGlobalTransTarget(client);
    decl String:text[256];
    
    new Handle:menu = CreatePanel();

    if ( TotalWinners )
    {
        Format(text, sizeof(text), "%t", "TopPanel: Top", offset + 1, end, TotalWinners);
        SetPanelTitle(menu, text);
        DrawPanelText(menu, BLANK_SPACE);
    
        Format(text, sizeof(text), "%t", "Panel: Page", ClientOnPage[client] + 1, pages);
        DrawPanelText(menu, text);
        DrawPanelText(menu, BLANK_SPACE);
        
        new i = offset;
        decl String:name[MAX_NAME_SIZE], String:subtext[64];
        new wins;
        while ( SQL_FetchRow(result) )
        {
            wins = SQL_FetchInt(result, 1);
            SQL_FetchString(result, 2, name, sizeof(name));
            FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), wins, "wins");
            if ( ++i < 4 )
            {
                Format(text, sizeof(text), "%t", "TopPanel: Name Wins", name, subtext);
                DrawPanelItem(menu, text);
            }
            else
            {
                Format(text, sizeof(text), "%t", "TopPanel: Place Name Wins", i, name, subtext);
                DrawPanelText(menu, text);
            }
        }
    }
    else
    {
        Format(text, sizeof(text), "%t", "TopPanel: Top short");
        SetPanelTitle(menu, text);
        DrawPanelText(menu, BLANK_SPACE);
        
        Format(text, sizeof(text), "%t", "TopPanel: There are currently no players in the top");
        DrawPanelItem(menu, text);
    }
   
    DrawPanelText(menu, BLANK_SPACE);
    SetPanelCurrentKey(menu, 8);

    if ( offset == 0 ) {
        SetPanelCurrentKey(menu, 9);
    } else {
        Format(text, sizeof(text), "%t", "Panel: Back");
        DrawPanelItem(menu, text, ITEMDRAW_CONTROL);
    }
    if ( end == TotalWinners ) {
        SetPanelCurrentKey(menu, 10);
    } else {
        Format(text, sizeof(text), "%t", "Panel: Next");
        DrawPanelItem(menu, text, ITEMDRAW_CONTROL);
    }
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(menu, text, ITEMDRAW_CONTROL);

    SendPanelToClient(menu, client, TopMenuHandler, GUNGAME_MENU_TIME);
    CloseHandle(menu);
}

public TopMenuHandler(Handle:menu, MenuAction:action, client, param2)
{
    if ( action == MenuAction_Select )
    {
        switch(param2)
        {
            case 8:
            {
                --ClientOnPage[client];
                DisplayTopMenu(client);
            }
            case 9:
            {
                ++ClientOnPage[client];
                DisplayTopMenu(client);
            }
        }
    }
}


ShowTopMenu(client)
{
    ClientOnPage[client] = 0;
    DisplayTopMenu(client);
}
#endif
