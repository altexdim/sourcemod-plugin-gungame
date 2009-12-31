Handle:CreateTop10Panel()
{
    decl String:text[128];

    new Handle:Top10 = CreatePanel();

    Format(text, sizeof(text), "%t", "Top10Panel: [GunGame] Top10");
    SetPanelTitle(Top10, text);
    DrawPanelText(Top10, BLANK_SPACE);

    if(!HasRank)
    {
        Format(text, sizeof(text), "%t", "Top10Panel: There are currently no players in the top10");
        DrawPanelText(Top10, text);
    } else {
        decl String:subtext[64];
        for(new i = 0; i < MAX_RANK; i++)
        {
            if(PlayerWins[i])
            {
                FormatLanguageNumberText(subtext, sizeof(subtext), PlayerWins[i], "wins");
                Format(text, sizeof(text), "%t", "Top10Panel: Place Name Wins", i + 1, PlayerName[i], subtext);
                DrawPanelText(Top10, text);
            }
        }
    }

    DrawPanelText(Top10, BLANK_SPACE);
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(Top10, text, ITEMDRAW_CONTROL);
    return Top10;
}

public EmptyHandler(Handle:menu, MenuAction:action, param1, param2)
{
    /* Don't care what they pressed. */
}