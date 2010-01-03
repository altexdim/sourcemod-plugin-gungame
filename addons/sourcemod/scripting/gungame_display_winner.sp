#pragma semicolon 1

#include <sourcemod>
#include <gungame>
#include <gungame_st>

new String:LastKill[MAXPLAYERS+1][32];
new Handle:g_Cvar_Url;
new String:WinnerName[32];

public Plugin:myinfo =
{
    name = "GunGame:SM Display Winner",
    description = "Shows a MOTD window with the winner's information when the game is won.",
    author = GUNGAME_AUTHOR,
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
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

    decl String:victimName[32];
    GetClientName(victim, victimName, sizeof(victimName));

    LastKill[attacker] = victimName;
}

public GG_OnWinner(client, const String:weapon[])
{
    GetClientName(client, WinnerName, sizeof(WinnerName));
    // KLUGE: GG_OnWinner recalculates winners wins and place.
    // So ShowMotd must be called after that.
    CreateTimer(0.1, ShowMotd, client);
}

public Action:ShowMotd(Handle:timer, any:client)
{
    decl String:url[256];
    GetConVarString(g_Cvar_Url, url, sizeof(url));
    Format(url, sizeof(url), "%s?winnerName=%s&loserName=%s&wins=%i&place=%i&totalPlaces=%i", 
        url, 
        WinnerName, 
        LastKill[client], 
        GG_GetClientWins(client), /* HINT: gungame_stats */
        GG_GetPlayerPlaceInStat(client), /* HINT: gungame_stats */
        GG_CountPlayersInStat() /* HINT: gungame_stats */
    );
    for (new i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i))
        {
            ShowMOTDPanel(i, "", url, MOTDPANEL_TYPE_URL);
        }
    }
}
