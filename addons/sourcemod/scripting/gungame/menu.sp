/**
 * Menu
 */

public CommandPanelHandler(Handle:menu, MenuAction:action, client, param2)
{
    if (action == MenuAction_Select)
    {
        switch(param2)
        {
            case 1: /* !level */
                CreateLevelPanel(client);
            case 2: /* !weapons */
                ShowWeaponLevelPanel(client);
            case 3: /* !score */
                ShowPlayerLevelMenu(client);
            case 4: /* !top10 */
                GG_DisplayTop10(client);
            case 5: /* !rules */
                ShowRulesMenu(client);
        }
    }
}

public ScoreCommandPanelHandler(Handle:menu, MenuAction:action, client, param2)
{
    if (action == MenuAction_Select)
    {
        switch(param2)
        {
            case 4: /* !score */
                ShowPlayerLevelMenu(client);
        }
    }
}

public EmptyHandler(Handle:menu, MenuAction:action, param1, param2)
{
    /* Don't care what they pressed. */
}

CreateLevelPanel(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];
    decl String:subtext[64];

    new Handle:LevelPanel = CreatePanel();
    Format(text, sizeof(text), "%t", "LevelPanel: Level Information");
    SetPanelTitle(LevelPanel, text);
    DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);

    new Level = PlayerLevel[client], Weapons:WeapId = WeaponOrderId[Level], killsPerLevel = CustomKillPerLevel[Level];
    if ( !killsPerLevel )
    {
        killsPerLevel = MinKillsPerLevel;
    }

    Format(text, sizeof(text), "%t", "LevelPanel: Level");
    DrawPanelItem(LevelPanel, text);
    Format(text, sizeof(text), "%t", "LevelPanel: You are on level",
        Level + 1, WeaponName[WeapId][7], CurrentKillsPerWeap[client], killsPerLevel);
    DrawPanelText(LevelPanel, text);

    if ( CurrentLeader == client )
    {
        Format(text, sizeof(text), "%t", "LevelPanel: You are currently the leader");
        DrawPanelText(LevelPanel, text);
        DrawPanelText(LevelPanel, BLANK_SPACE);
    } else {
        DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);
    }

    Format(text, sizeof(text), "%t", "LevelPanel: Wins");
    DrawPanelItem(LevelPanel, text);

    FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), GG_GetClientWins(client), "times");
    Format(text, sizeof(text), "%t", "LevelPanel: You have won times", subtext);
    DrawPanelText(LevelPanel, text);

    DrawPanelText(LevelPanel, BLANK_SPACE);

    Format(text, sizeof(text), "%t", "LevelPanel: Leader");
    DrawPanelItem(LevelPanel, text);

    if(CurrentLeader && IsClientInGame(CurrentLeader))
    {
        new level = PlayerLevel[CurrentLeader];

        if(level)
        {
            decl String:Name[64];
            GetClientName(CurrentLeader, Name, sizeof(Name));
            Format(text, sizeof(text), "%t", "LevelPanel: The current leader is on level", Name, level + 1);
            DrawPanelText(LevelPanel, text);
            if ( CurrentLeader != client )
            {
                if (level == Level)
                {
                    Format(text, sizeof(text), "%t", "LevelPanel: You have tied with the leader");
                    DrawPanelText(LevelPanel, text);
                }
                else if (level > Level)
                {
                    FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), level - Level, "levels");
                    CRemoveTags(subtext, sizeof(subtext));
                    Format(text, sizeof(text), "%t", "LevelPanel: You are levels from the leader", subtext);
                    DrawPanelText(LevelPanel, text);
                }
            }
        } else {
            Format(text, sizeof(text), "%t", "LevelPanel: There is currently no leader");
            DrawPanelText(LevelPanel, text);
        }
    } else {
        Format(text, sizeof(text), "%t", "LevelPanel: There is currently no leader");
        DrawPanelText(LevelPanel, text);
    }

    DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);
    SetPanelCurrentKey(LevelPanel, 4);
    Format(text, sizeof(text), "%t", "LevelPanel: Scores");
    DrawPanelItem(LevelPanel, text, ITEMDRAW_CONTROL);
    Format(text, sizeof(text), "%t", "LevelPanel: Press 4 to show scores");
    DrawPanelText(LevelPanel, text);
    
    DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);
    SetPanelCurrentKey(LevelPanel, 10);
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(LevelPanel, text, ITEMDRAW_CONTROL);

    SendPanelToClient(LevelPanel, client, ScoreCommandPanelHandler, GUNGAME_MENU_TIME);
    CloseHandle(LevelPanel);
}

ShowPlayerLevelMenu(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];
    decl String:subtext[64];

    new Handle:menu = CreateMenu(PlayerLevelHandler);
    decl String:Name[64];

    Format(text, sizeof(text), "%t", "PlayersLevelPanel: Players level information");
    SetMenuTitle(menu, text);

    new first = true;
    for(new i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i))
        {
            GetClientName(i, Name, sizeof(Name));
            FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), GG_GetClientWins(i), "wins");
            Format(text, sizeof(text), "%t", "PlayersLevelPanel: Level Wins Name", PlayerLevel[i] + 1, subtext, Name);
            AddMenuItem(menu, BLANK, text, first?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
            first = false;
        }
    }

    if(menu != INVALID_HANDLE)
    {
        DisplayMenu(menu, client, GUNGAME_MENU_TIME);
    }
}

public PlayerLevelHandler(Handle:menu, MenuAction:action, param1, param2)
{
    if(action == MenuAction_End)
    {
        CloseHandle(menu);
    }
}


/* Move into a real menu */
ShowJoinMsgPanel(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];
    new Handle:faluco = CreatePanel(), Count;

    Format(text, sizeof(text), "%t", "JoinPanel: This server is running the GunGame:SM");
    SetPanelTitle(faluco, text);
    DrawPanelText(faluco, BLANK_SPACE);

    if(BotCanWin)
    {
        Format(text, sizeof(text), "%t", "JoinPanel: Bots can win the game is ENABLED!!");
        DrawPanelText(faluco, text);
        Count++;
    }

    if(TurboMode)
    {
        Format(text, sizeof(text), "%t", "JoinPanel: Turbo Mode is ENABLED!!");
        DrawPanelText(faluco, text);
        Count++;
    }

    if(KnifePro)
    {
        Format(text, sizeof(text), "%t", "JoinPanel: Knife Pro is ENABLED!!");
        DrawPanelText(faluco, text);
        Count++;
    }

    if(KnifeElite)
    {
        Format(text, sizeof(text), "%t", "JoinPanel: Knife Elite is ENABLED!!");
        DrawPanelText(faluco, text);
        Count++;
    }

    if(MinKillsPerLevel > 1)
    {
        Format(text, sizeof(text), "%t", "JoinPanel: Multikill Mode is ENABLED!!");
        DrawPanelText(faluco, text);
        Count++;
    }

    if(Count)
    {
        DrawPanelText(faluco, BLANK_SPACE);
    }

    Format(text, sizeof(text), "%t", "JoinPanel: Type !rules for instructions on how to play");
    DrawPanelText(faluco, text);
    Format(text, sizeof(text), "%t", "JoinPanel: Type !level to get your level info and who is leading");
    DrawPanelText(faluco, text);
    Format(text, sizeof(text), "%t", "JoinPanel: Type !score to get a list of all players scores and winnings");
    DrawPanelText(faluco, text);
    Format(text, sizeof(text), "%t", "JoinPanel: Type !commands to get a full list of gungame commands");
    DrawPanelText(faluco, text);

    DrawPanelText(faluco, BLANK_SPACE);
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(faluco, text, ITEMDRAW_CONTROL);
    
    SendPanelToClient(faluco, client, EmptyHandler, GUNGAME_MENU_TIME);
    CloseHandle(faluco);
}

ShowCommandPanel(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];
    new Handle:Ham = CreatePanel();
    Format(text, sizeof(text), "%t", "CommandPanel: [GunGame] Command list information");
    SetPanelTitle(Ham, text);
    DrawPanelText(Ham, BLANK_SPACE);
    Format(text, sizeof(text), "%t", "CommandPanel: !level to see your current level and who is winning");
    DrawPanelItem(Ham, text);
    Format(text, sizeof(text), "%t", "CommandPanel: !weapons to see the weapon order");
    DrawPanelItem(Ham, text);
    Format(text, sizeof(text), "%t", "CommandPanel: !score to see all player current scores");
    DrawPanelItem(Ham, text);
    Format(text, sizeof(text), "%t", "CommandPanel: !top10 to see the top 10 winners on the server");
    DrawPanelItem(Ham, text);
    Format(text, sizeof(text), "%t", "CommandPanel: !rules to see the rules and how to play");
    DrawPanelItem(Ham, text);
    DrawPanelItem(Ham, BLANK, ITEMDRAW_SPACER);

    SetPanelCurrentKey(Ham, 10);
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(Ham, text);

    SendPanelToClient(Ham, client, CommandPanelHandler, GUNGAME_MENU_TIME);
    CloseHandle(Ham);
}

ShowWeaponLevelPanel(client)
{
    ClientOnPage[client] = NULL;
    DisplayWeaponLevelPanel(client);
}

DisplayWeaponLevelPanel(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];
    new Handle:Ham = CreatePanel(), i = ClientOnPage[client] * 7, end = i + 7;

    Format(text, sizeof(text), "%t", "WeaponLevelPanel: [GunGame] Weapon Levels");
    SetPanelTitle(Ham, text);
    DrawPanelText(Ham, BLANK_SPACE);

    for(; i < end; i++)
    {
        if(i < WeaponOrderCount)
        {
            Format(text, sizeof(text), "%t", "WeaponLevelPanel: Order Weapon", i + 1, WeaponName[WeaponOrderId[i]][7]);
            DrawPanelText(Ham, text);
        }
    }

    DrawPanelText(Ham, BLANK_SPACE);
    SetPanelCurrentKey(Ham, 8);

    Format(text, sizeof(text), "%t", "Panel: Back");
    DrawPanelItem(Ham, text, ITEMDRAW_CONTROL);
    Format(text, sizeof(text), "%t", "Panel: Next");
    DrawPanelItem(Ham, text, ITEMDRAW_CONTROL);
    Format(text, sizeof(text), "%t", "Panel: Exit");
    DrawPanelItem(Ham, text, ITEMDRAW_CONTROL);

    SendPanelToClient(Ham, client, WeaponMenuHandler, GUNGAME_MENU_TIME);
    CloseHandle(Ham);
}

public WeaponMenuHandler(Handle:menu, MenuAction:action, param1, param2)
{
    if(action == MenuAction_Select)
    {
        switch(param2)
        {
            case 8:
            {
                if(--ClientOnPage[param1] < 0)
                {
                    ClientOnPage[param1] = WeaponLevelPages - 1;
                }

                DisplayWeaponLevelPanel(param1);
            }
            case 9:
            {
                if(++ClientOnPage[param1] >= WeaponLevelPages)
                {
                    ClientOnPage[param1] = NULL;
                }

                DisplayWeaponLevelPanel(param1);
            }
        }
    }
}

ShowRulesMenu(client)
{
    SetGlobalTransTarget(client);
    decl String:text[256];
    decl String:subtext[64];
    new Handle:menu = CreateMenu(EmptyHandler);

    if(menu == INVALID_HANDLE)
    {
        return;
    }

    SetMenuPagination(menu, 6);
    Format(text, sizeof(text), "%t", "RulesPanel: [GunGame] Rules information");
    SetMenuTitle(menu, text);

    FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), MinKillsPerLevel, "points");
    CRemoveTags(subtext, sizeof(subtext));
    Format(text, sizeof(text), "%t", "RulesPanel: You must get kills with your current weapon to level up", subtext);
    AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);

    Format(text, sizeof(text), "%t", "RulesPanel: If you get a kill with a weapon out of order. It does not count towards your level");
    AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);

    /**
     * How to propertly explain Custom Weapon Level to the player?
     * If a custom minimum kill has been set for a perticular weapon. You need to need to kill x number of players with that weapon before you can level.
     * To wordy? Bad Sentence? Think of a shorter and clearer sentence.
     */

    if(ObjectiveBonus)
    {
        FormatLanguageNumberTextEx(client, subtext, sizeof(subtext), ObjectiveBonus, "levels");
        Format(text, sizeof(text), "%t", "RulesPanel: You can gain %d level by PLANTING or DEFUSING the bomb", subtext);
        AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);
    }

    if(AutoFriendlyFire)
    {
        Format(text, sizeof(text), "%t", "RulesPanel: Friendly Fire is automatically turned ON when someone reaches GRENADE level");
        AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);
    }

    if(MaxLevelPerRound > 1)
    {
        Format(text, sizeof(text), "%t", "RulesPanel: You CAN gained more than one level per round");
        AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);
    }

    if(KnifePro)
    {
        Format(text, sizeof(text), "%t", "RulesPanel: You can steal a level from an opponent by knifing them");
        AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);
    }

    if(KnifeElite)
    {
        Format(text, sizeof(text), "%t", "RulesPanel: After you levelup, you will only have a knife until the next round starts");
        AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);
    }

    if(TurboMode)
    {
        Format(text, sizeof(text), "%t", "RulesPanel: You will receive your next weapon immediately when you level up");
        AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);
    }

    Format(text, sizeof(text), "%t", "RulesPanel: If you commit suicide you will lose a level");
    AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);

    Format(text, sizeof(text), "%t", "RulesPanel: There is a grace period at the end of each round to allow players to switch teams");
    AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);

    Format(text, sizeof(text), "%t", "RulesPanel: Type !commands to see the list of gungame commands");
    AddMenuItem(menu, BLANK, text, ITEMDRAW_DISABLED);

    DisplayMenu(menu, client, GUNGAME_MENU_TIME);
    CloseHandle(menu);
}
