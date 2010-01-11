#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>
#include <gungame_stats>
#include <url>

new String:g_looserName[MAXPLAYERS+1][MAX_NAME_SIZE];
new Handle:g_Cvar_Url;
new String:g_winnerName[MAX_NAME_SIZE];
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
    if ( IsFakeClient(client) )
    {
        return;
    }
    GetClientName(client, g_winnerName, sizeof(g_winnerName));
    g_showMotdOnRankUpdate = true;
    g_winner = client;
}

public GG_OnLoadRank()
{
    if ( !g_showMotdOnRankUpdate )
    {
        return;
    }
    g_showMotdOnRankUpdate = false;

    decl String:url[256];
    GetConVarString(g_Cvar_Url, url, sizeof(url));
    decl String:winnerNameUrlEncoded[sizeof(g_winnerName)*3+1];
    decl String:looserNameUrlEncoded[sizeof(g_looserName[])*3+1];
    url_encode(g_winnerName, sizeof(g_winnerName), winnerNameUrlEncoded, sizeof(winnerNameUrlEncoded));
    url_encode(g_looserName[g_winner], sizeof(g_looserName[]), looserNameUrlEncoded, sizeof(looserNameUrlEncoded));
    Format(url, sizeof(url), "%s?winnerName=%s&loserName=%s&wins=%i&place=%i&totalPlaces=%i", 
        url, 
        winnerNameUrlEncoded, 
        looserNameUrlEncoded, 
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

