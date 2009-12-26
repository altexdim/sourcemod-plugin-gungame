#pragma semicolon 1
#include <sourcemod>
#include <gungame>

/**
 * This is a plugin for hlstatx logging of the winner of the gungame current level.
 */

public Plugin:myinfo =
{
    name = "GunGame:SM Winner Logger",
    author = GUNGAME_AUTHOR,
    description = "Logging of winner for external stats plugin",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public GG_OnWinner(client, const String:Weapon[])
{
    LogEventToGame("gg_win", client);
}

public GG_OnLeaderChange(client, level, totalLevels)
{
    if ( client && IsClientInGame(client) )
    {
        LogEventToGame("gg_leader", client);
    }
}

public Action:GG_OnClientLevelChange(client, level, difference, bool:steal, bool:last)
{
    if ( !difference )
    {
        return;
    }
    if ( difference > 0 )
    {
        if ( steal )
        {
            LogEventToGame("gg_knife_steal", client);
        }
        LogEventToGame("gg_levelup", client);
        if ( last )
        {
            LogEventToGame("gg_knife_level", client);
        }
    }
    else
    {
        LogEventToGame("gg_leveldown", client);
    }
}

LogEventToGame(const String:event[], client)
{
    decl String:Name[64], String:Auth[64];

    GetClientName(client, Name, sizeof(Name));
    GetClientAuthString(client, Auth, sizeof(Auth));

    new team = GetClientTeam(client), UserId = GetClientUserId(client);
    LogToGame("\"%s<%d><%s><%s>\" triggered \"%s\"", Name, UserId, Auth, (team == TEAM_T) ? "TERRORIST" : "CT", event);
}
   
