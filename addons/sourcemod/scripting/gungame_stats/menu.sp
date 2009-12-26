Handle:CreateTop10Panel()
{
    decl String:Key[74];
    new Handle:Top10 = CreatePanel();

    SetPanelTitle(Top10, "[GunGame] Top10");
    DrawPanelText(Top10, BLANK_SPACE);

    if(!HasRank)
    {
        DrawPanelText(Top10, "There are currently no players in the top10");
    } else {
        for(new i = 0; i < MAX_RANK; i++)
        {
            if(PlayerWins[i])
            {
                FormatEx(Key, sizeof(Key), "%d. %s - Wins %i", i + 1, PlayerName[i], PlayerWins[i]);
                DrawPanelText(Top10, Key);
            }
        }
    }

    DrawPanelText(Top10, BLANK_SPACE);
    DrawPanelItem(Top10, "Exit", ITEMDRAW_CONTROL);
    return Top10;
}

public EmptyHandler(Handle:menu, MenuAction:action, param1, param2)
{
    /* Don't care what they pressed. */
}