#pragma semicolon 1

#include <sourcemod>
#include <gungame>

#define PLUGIN_VERSION "1.0.0"

new String:LastKill[MAXPLAYERS+1][32];
new Hanlde:g_Cvar_Url;

public Plugin:myinfo =
{
	name = "GunGame Winner",
	author = "bl4nk",
	description = "Shows a MOTD window with the winner's information when the game is won",
	version = PLUGIN_VERSION,
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

	decl String:victimName[32];
	GetClientName(victim, victimName, sizeof(victimName));

	LastKill[attacker] = victimName;
}

public GG_OnWinner(client, const String:weapon[])
{
	decl String:name[32], String:url[256];
	GetClientName(client, name, sizeof(name));

	GetConVarString(g_Cvar_Url, url, sizeof(url));
	Format(url, sizeof(url), "%s?winnerName=%s&loserName=%s&wins=%i&place=%s&totalPlaces=%s", url, name, LastKill[client], GG_GetClientWins(client), GG_GetPlayerPlaceInStat(client), GG_CountPlayersInStat());
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			ShowMOTDPanel(i, "", url, MOTDPANEL_TYPE_URL);
		}
	}
}
