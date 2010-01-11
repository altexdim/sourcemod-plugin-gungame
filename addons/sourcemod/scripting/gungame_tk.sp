#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>
#include <colors>

/**
 * This is a meant to make the tk optional where you lose a level by team killing another teammate.
 */

public Plugin:myinfo =
{
    name = "GunGame:SM TK Management",
    author = GUNGAME_AUTHOR,
    description = "Team Killed Management System",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public OnPluginStart()
{
    LoadTranslations("gungame_tk");
}

public Action:GG_OnClientDeath(Killer, Victim, Weapons:WeaponId, bool:TeamKilled)
{
    if ( TeamKilled )
    {
        /* Tk a player */
        if ( !GG_RemoveALevel(Killer) )
        {
            return Plugin_Continue;
        }

        decl String:kName[MAX_NAME_SIZE], String:vName[MAX_NAME_SIZE];
        GetClientName(Killer, kName, sizeof(kName));
        GetClientName(Victim, vName, sizeof(vName));

        CPrintToChatAllEx(Killer, "%t", "Has lost a level due to team kill", kName, vName);

        return Plugin_Handled;
    }

    return Plugin_Continue;
}
