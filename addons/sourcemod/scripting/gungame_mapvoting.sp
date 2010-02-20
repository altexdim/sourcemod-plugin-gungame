#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>

public Plugin:myinfo =
{
    name = "GunGame:SM Map Vote Starter",
    author = GUNGAME_AUTHOR,
    description = "Start the map voting for next map",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

public GG_OnStartMapVote()
{
    InsertServerCommand("exec gungame\\gungame.mapvote.cfg");
}

public GG_OnDisableRtv()
{
    InsertServerCommand("exec gungame\\gungame.disable_rtv.cfg");
}

public GG_OnEnableFriendlyFire()
{
    InsertServerCommand("exec gungame\\gungame.enable_friendly_fire.cfg");
}

