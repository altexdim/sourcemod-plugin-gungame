#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>
#include <gungame_stats>

new String:g_looserName[MAXPLAYERS+1][32];
new Handle:g_Cvar_Url;
new String:g_winnerName[32];
new bool:g_showMotdOnRankUpdate = false;
new g_winner;

public Plugin:myinfo =
{
    name = "GunGame:SM Display Winner",
    description = "Shows a MOTD window with the winner's information when the game is won.",
    author = "bl4nk",
    version = GUNGAME_VERSION,
    url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
    g_Cvar_Url = CreateConVar("sm_gungame_display_winner_url", "http://gungame5.com/gg5_win.php", "URL to display in MOTD window.");
    HookEvent("player_death", Event_PlayerDeath);
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
    new victim = GetClientOfUserId(GetEventInt(event, "userid"));
    new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
    GetClientName(victim, g_looserName[attacker], sizeof(g_looserName[]));
}

public GG_OnWinner(client, const String:weapon[])
{
    GetClientName(client, g_winnerName, sizeof(g_winnerName));
    g_showMotdOnRankUpdate = true;
    g_winner = client;
}

public Action:GG_OnLoadRank()
{
    g_showMotdOnRankUpdate = false;
    decl String:url[256];
    GetConVarString(g_Cvar_Url, url, sizeof(url));
    Format(url, sizeof(url), "%s?winnerName=%s&loserName=%s&wins=%i&place=%i&totalPlaces=%i", 
        url, 
        g_winnerName, 
        g_looserName[g_winner], 
        GG_GetClientWins(g_winner),         /* HINT: gungame_stats */
        GG_GetPlayerPlaceInStat(g_winner),  /* HINT: gungame_stats */
        GG_CountPlayersInStat()             /* HINT: gungame_stats */
    );
    for ( new i = 1; i <= MaxClients; i++ )
    {
        if ( IsClientInGame(i) )
        {
            ShowMOTDPanel(i, "", url, MOTDPANEL_TYPE_URL);
        }
    }
}

