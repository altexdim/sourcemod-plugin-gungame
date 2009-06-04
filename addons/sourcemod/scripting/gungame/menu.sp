/**
 * ===============================================================
 * GunGame:SM, Copyright (C) 2007
 * All rights reserved.
 * ===============================================================
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * To view the latest information, see: http://www.hat-city.net/
 * Author(s): teame06
 *
 * This was also brought to you by faluco and the hat (http://www.hat-city.net/haha.jpg)
 *
 * Credit:
 * Original Idea and concepts of Gun Game was made by cagemonkey @ http://www.cagemonkey.org
 *
 * Especially would like to thank BAILOPAN for everything.
 * Also faluco for listening to my yapping.
 * Custom Mutliple Kills Per Level setting was an idea from XxAvalanchexX GunGame 1.6.
 * To the SourceMod Dev Team for making a nicely design system for this plugin to be recreated it.
 * FlyingMongoose for slaping my ideas away and now we have none left ... Geez.
 * I would also like to thank sawce with ^^.
 * Another person who I would like to thank is OneEyed.
 */

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
                DisplayMenu(RulesMenu, client, GUNGAME_MENU_TIME);
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
    decl String:Sombrero[128];
    new Handle:LevelPanel = CreatePanel();
    SetPanelTitle(LevelPanel, "[GunGame] Level Information.");
    DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);

    new Level = PlayerLevel[client], Weapons:WeapId = WeaponOrderId[Level], killsPerLevel = CustomKillPerLevel[Level];
    if ( !killsPerLevel )
    {
        killsPerLevel = MinKillsPerLevel;
    }

    DrawPanelItem(LevelPanel, "Level:");
    FormatEx(Sombrero, sizeof(Sombrero), "You are on level %d :: %s\nYou have made %d / %d of your required kills.",
        Level + 1, WeaponName[WeapId][7], CurrentKillsPerWeap[client], killsPerLevel);
    DrawPanelText(LevelPanel, Sombrero);

    if(CurrentLeader == client)
    {
        DrawPanelText(LevelPanel, "You are currently the leader.");
        DrawPanelText(LevelPanel, BLANK_SPACE);
    } else {
        DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);
    }

    DrawPanelItem(LevelPanel, "Wins:");
    FormatEx(Sombrero, sizeof(Sombrero), "You have won %d times.", GG_GetClientWins(client));
    DrawPanelText(LevelPanel, Sombrero);

    DrawPanelText(LevelPanel, BLANK_SPACE);

    DrawPanelItem(LevelPanel, "Leader:");

    if(CurrentLeader && IsClientInGame(CurrentLeader))
    {
        new level = PlayerLevel[CurrentLeader];

        if(level)
        {
            decl String:Name[64];
            GetClientName(CurrentLeader, Name, sizeof(Name));
            FormatEx(Sombrero, sizeof(Sombrero), "The current leader is %s on level %d.", Name, level + 1);
            DrawPanelText(LevelPanel, Sombrero);
            if ( CurrentLeader != client )
            {
                if (level == Level)
                {
                    FormatEx(Sombrero, sizeof(Sombrero), "You have tied with the leader.");
                    DrawPanelText(LevelPanel, Sombrero);
                }
                else if (level > Level)
                {
                    FormatEx(Sombrero, sizeof(Sombrero), "You are %d levels from the leader.", level - Level);
                    DrawPanelText(LevelPanel, Sombrero);
                }
            }
        } else {
            DrawPanelText(LevelPanel, "There is currently no leader.");
        }
    } else {
        DrawPanelText(LevelPanel, "There is currently no leader.");
    }

    DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);
    SetPanelCurrentKey(LevelPanel, 4);
    DrawPanelItem(LevelPanel, "Scores:", ITEMDRAW_CONTROL);
    DrawPanelText(LevelPanel, "Press 4 to show scores.");
    
    DrawPanelItem(LevelPanel, BLANK, ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);
    SetPanelCurrentKey(LevelPanel, 10);
    DrawPanelItem(LevelPanel, "Exit", ITEMDRAW_CONTROL);

    SendPanelToClient(LevelPanel, client, ScoreCommandPanelHandler, GUNGAME_MENU_TIME);
    CloseHandle(LevelPanel);
}

ShowPlayerLevelMenu(client)
{
    new Handle:menu = CreateMenu(PlayerLevelHandler);
    decl String:Key[100], String:Name[64];

    SetMenuTitle(menu, "[GunGame] Players level information");

    new first = true;
    for(new i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i))
        {
            GetClientName(i, Name, sizeof(Name));
            FormatEx(Key, sizeof(Key), "Level %d :: %d Wins :: %s", PlayerLevel[i] + 1, GG_GetClientWins(i), Name);

            AddMenuItem(menu, BLANK, Key, first?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
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
Handle:CreateJoinMsgPanel()
{
    new Handle:faluco = CreatePanel(), Count;

    SetPanelTitle(faluco, "This server is running the GunGame:SM");
    DrawPanelText(faluco, BLANK_SPACE);

    if(BotCanWin)
    {
        DrawPanelText(faluco, "Bots can win the game is ENABLED!!");
        Count++;
    }

    if(TurboMode)
    {
        DrawPanelText(faluco, "Turbo Mode is ENABLED!!");
        Count++;
    }

    if(KnifePro)
    {
        DrawPanelText(faluco, "Knife Pro is ENABLED!!");
        Count++;
    }

    if(KnifeElite)
    {
        DrawPanelText(faluco, "Knife Elite is ENABLED!!");
        Count++;
    }

    if(MinKillsPerLevel > 1)
    {
        DrawPanelText(faluco, "Multikill Mode is ENABLED!!");
        Count++;
    }

    if(Count)
    {
        DrawPanelText(faluco, BLANK_SPACE);
    }

    DrawPanelText(faluco, "Type !rules for instructions on how to play");
    DrawPanelText(faluco, "Type !level to get your level info and who is leading");
    DrawPanelText(faluco, "Type !score to get a list of all players scores and winnings.");
    DrawPanelText(faluco, "Type !commands to get a full list of gungame commands");

    DrawPanelText(faluco, BLANK_SPACE);
    DrawPanelItem(faluco, "Exit", ITEMDRAW_CONTROL);
    return faluco;
}

Handle:CreateCommandPanel()
{
    new Handle:Ham = CreatePanel();
    SetPanelTitle(Ham, "[GunGame] Command list information");
    DrawPanelText(Ham, BLANK_SPACE);
    DrawPanelItem(Ham, "!level to see your current level and who is winning.");
    DrawPanelItem(Ham, "!weapons to see the weapon order.");
    DrawPanelItem(Ham, "!score to see all player current scores.");
    DrawPanelItem(Ham, "!top10 to see the top 10 winners on the server.");
    DrawPanelItem(Ham, "!rules to see the rules and how to play.\n");
    DrawPanelItem(Ham, BLANK, ITEMDRAW_SPACER);

    SetPanelCurrentKey(Ham, 10);
    DrawPanelItem(Ham, "Exit");

    return Ham;
}

ShowWeaponLevelPanel(client)
{
    ClientOnPage[client] = NULL;
    DisplayWeaponLevelPanel(client);
}

DisplayWeaponLevelPanel(client)
{
    decl String:Key[64];
    new Handle:Ham = CreatePanel(), i = ClientOnPage[client] * 7, end = i + 7;

    SetPanelTitle(Ham, "[GunGame] Weapon Levels");
    DrawPanelText(Ham, BLANK_SPACE);

    for(; i < end; i++)
    {
        if(i < WeaponOrderCount)
        {
            FormatEx(Key, sizeof(Key), "%d. %s", i + 1, WeaponName[WeaponOrderId[i]][7]);
            DrawPanelText(Ham, Key);
        }
    }

    DrawPanelText(Ham, BLANK_SPACE);
    SetPanelCurrentKey(Ham, 8);

    DrawPanelItem(Ham, "Back", ITEMDRAW_CONTROL);
    DrawPanelItem(Ham, "Next", ITEMDRAW_CONTROL);
    DrawPanelItem(Ham, "Exit", ITEMDRAW_CONTROL);

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

Handle:CreateRulesMenu()
{
    new Handle:menu = CreateMenu(EmptyHandler);

    if(menu == INVALID_HANDLE)
    {
        return INVALID_HANDLE;
    }

    SetMenuPagination(menu, 6);
    SetMenuTitle(menu, "[GunGame] Rules information");

    decl String:Rules[128];
    FormatEx(Rules, sizeof(Rules), "You must get %d kills with your current weapon to level up", MinKillsPerLevel);
    AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);

    FormatEx(Rules, sizeof(Rules), "If you get a kill with a weapon out of order. It does not count towards your level");
    AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);

    /**
     * How to propertly explain Custom Weapon Level to the player?
     * If a custom minimum kill has been set for a perticular weapon. You need to need to kill x number of players with that weapon before you can level.
     * To wordy? Bad Sentence? Think of a shorter and clearer sentence.
     */

    if(ObjectiveBonus)
    {
        FormatEx(Rules, sizeof(Rules), "You can gain %d level by PLANTING or DEFUSING the bomb", ObjectiveBonus);
        AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);
    }

    if(AutoFriendlyFire)
    {
        FormatEx(Rules, sizeof(Rules), "Friendly Fire is automatically turned ON when someone reaches GRENADE level");
        AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);
    }

    if(MaxLevelPerRound > 1)
    {
        FormatEx(Rules, sizeof(Rules), "You CAN gained more than one level per round");
        AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);
    }

    if(KnifePro)
    {
        FormatEx(Rules, sizeof(Rules), "You can steal a level from an opponent by knifing them");
        AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);
    }

    if(KnifeElite)
    {
        FormatEx(Rules, sizeof(Rules), "After you levelup, you will only have a knife until the next round starts");
        AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);
    }

    if(TurboMode)
    {
        FormatEx(Rules, sizeof(Rules), "You will receive your next weapon immediately when you level up");
        AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);
    }

    FormatEx(Rules, sizeof(Rules), "If you commit suicide you will lose a level");
    AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);

    FormatEx(Rules, sizeof(Rules), "There is a grace period at the end of each round to allow players to switch teams");
    AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);

    FormatEx(Rules, sizeof(Rules), "Type !commands to see the list of gungame commands.");
    AddMenuItem(menu, BLANK, Rules, ITEMDRAW_DISABLED);

    return menu;
}