/**
 * Const
 */

/**
 * Maximum level in gungame.
 */
#define GUNGAME_MAX_LEVEL            32
                                        
/**
 * This is the maximum allow time for a menu to be !rules, !weapons, !score, !level is display for.
 */
#define GUNGAME_MENU_TIME 360

/**
 * Admin flag for admin commands
 */
#define GUNGAME_ADMINFLAG         ADMFLAG_RCON

stock const String:GUNGAME_AUTHOR[] = "teame06-hat, Liam, Otstrel.ru Team, bl4nk";
stock const String:GUNGAME_URL[] = "http://www.hat-city.net, http://otstrel.ru, http://forums.alliedmods.net";
stock const String:GUNGAME_VERSION[] = "1.0.5.19";
stock const String:BLANK[] = "";
stock const String:BLANK_SPACE[] = " ";

#define MAX_NAME_SIZE        64
#define MAX_CHAT_SIZE        192

#define YELLOW               0x01
#define NAME_TEAMCOLOR       0x02
#define TEAMCOLOR            0x03
#define GREEN                0x04

//RemoveObjectives / MapStatus
#define OBJECTIVE_REMOVE_BOMB       (1<<0)
#define OBJECTIVE_REMOVE_HOSTAGE    (1<<1)
#define OBJECTIVE_BOMB              (1<<2)
#define OBJECTIVE_HOSTAGE           (1<<3)

#define TEAM_UNASSIGN        0
#define TEAM_SPECTATOR       1
#define TEAM_T               2
#define TEAM_CT              3

#define MAXHOSTAGE           12
#define NULL                 0

// m_lifeState values
#define LIFE_ALIVE           0 // alive
#define LIFE_DYING           1 // playing death animation or still falling off of a ledge waiting to hit ground
#define LIFE_DEAD            2 // dead. lying still.
#define LIFE_RESPAWNABLE     3
#define LIFE_DISCARDBODY     4

// settings for m_takedamage
#define DAMAGE_NO            0
#define DAMAGE_EVENTS_ONLY   1      // Call damage functions, but don't modify health
#define DAMAGE_YES           2
#define DAMAGE_AIM           3

// AfkAction
#define AFK_KICK             1
#define AFK_SPECTATE         2

#define PRINT_NOTIFY         1
#define PRINT_CONSOLE        2
#define PRINT_TALK           3
#define PRINT_CENTER         4

#define GAME_START           1
#define MAP_START            2

#define INVALID_OFFSET      -1

enum Slots
{
    Slot_Primary = 0,
    Slot_Secondary,
    Slot_Knife,
    Slot_Grenade,
    Slot_C4,
    Slot_None /* Not used for anything but a marker for last slot*/
};

enum Weapons
{
    CSW_KNIFE = 1,
    // Secondary Weapon
    CSW_USP,
    CSW_GLOCK,
    CSW_P228,
    CSW_DEAGLE,
    CSW_FIVESEVEN,
    CSW_ELITE,
    // Primary weapon
    CSW_M3,
    CSW_XM1014,
    CSW_TMP,
    CSW_MAC10,
    CSW_MP5NAVY,
    CSW_UMP45,
    CSW_P90,
    CSW_GALIL,
    CSW_FAMAS,
    CSW_AK47,
    CSW_M4A1,
    CSW_SG552,
    CSW_AUG,
    CSW_SCOUT,
    CSW_SG550,
    CSW_AWP,
    CSW_G3SG1,
    CSW_M249,
    CSW_HEGRENADE,
    CSW_FLASHBANG,
    CSW_SMOKEGRENADE,

    // Do not delete line below
    MAXWEAPON
};

enum State
{
    CONFIG_STATE_NONE,
    CONFIG_STATE_CONFIG,
    CONFIG_STATE_EQUIP,
    CONFIG_STATE_KILLS,
    CONFIG_STATE_SOUNDS,
    CONFIG_STATE_SECONDARY_LIST
}

/**
 * Forwards
 */

/**
 * Called when gungame is enabled
 *
 * @param Command       True if gungame was enabled by command.
 * @noreturn
 */
forward GG_OnStartup(bool:Command);

/**
 * Called when gungame is disabled.
 *
 * @param Command       True if gungame was disabled by command.
 * @noreturn
 */
forward GG_OnShutdown(bool:Command);

/**
 * Called when the player level changed.
 *
 * @param client        Player index.
 * @param level     Player current level (starting from 0). 
 * @param difference    The difference in the level change.
 * @param steal     true if it was a knife steal otherwise false
 * @param last      true if player reached last level.
 * @param knife     true if player reached knife level.
 * @return          Plugin_Handled; to stop the level change.
 */
forward Action:GG_OnClientLevelChange(client, level, difference, bool:steal, bool:last, bool:knife);

/**
 * Called when the player point per level changed.
 *
 * @param client        Player index.
 * @param point     Player current point per level.
 * @param difference    The difference in point change.
 * @return          Plugin_Handled; to stop the level change.
 */
forward Action:GG_OnClientPointChange(client, point, difference);

/**
 * Called when a client won the game.
 *
 * @param client        Player index.
 * @param Weapon        The player weapon they won with.
 * @noreturn
 */
forward GG_OnWinner(client, const String:Weapon[]);

/**
 * Called when a client triple leveled.
 *
 * @param client        Player index.
 * @noreturn
 */
forward GG_OnTripleLevel(client);

/**
 * Called when warmup has ended.
 *
 * @noreturn
 */
forward GG_OnWarmupEnd();

/**
 * Called when the leader change player.
 *
 * @param client        Player index.
 * @param level         The player current level (starting from 0).
 * @param totalLevels   Total levels
 * @noreturn
 */
forward GG_OnLeaderChange(client, level, totalLevels);

/**
 * Called news section of the config reader changes
 *
 * @param NewSection        The news section of the config file.
 * @noreturn
 */
forward GG_ConfigNewSection(const String:name[]);

/**
 * Called when the leader change player.
 *
 * @param Key           Key of cvar (Think of a better description)
 * @param Value     Value of setting
 * @noreturn
 */
forward GG_ConfigKeyValue(const String:key[], const String:value[]);

/**
 * Called when a file is fully parsed.
 *
 * @noparam
 * @noreturn
 */
forward GG_ConfigParseEnd();

/**
 * Called when all the config file are fully parsed.
 *
 * @noparam
 * @noreturn
 */
forward GG_ConfigEnd();

/**
 * Called when to start the map voting for next map
 *
 * @noparam
 * @noreturn
 */
forward GG_OnStartMapVote();

/**
 * Called when a player died.
 *
 * @param killer        Killer's index.
 * @param victim        Victim's index.
 * @param WeaponId      The weapon index the player was killed with.
 * @param TeamKilled    True if they were killed by a team mate.
 */
forward Action:GG_OnClientDeath(killer, victim, Weapons:WeaponId, bool:TeamKilled);

/**
 * Show the top10 to the client
 *
 * @param client        Player index.
 * @noreturn
 */
native GG_DisplayTop10(client);

/**
 * Gives the client the average/minimum level of all players in the server.
 *
 * Handicap mode: 
 *    1 - Average level
 *    2 - Minimum level
 *
 * @param client        Player index.
 * @param mode          Handicap mode.
 * @noreturn
 */
native GG_GiveHandicapLevel(client, mode);

/**
 * Return current player's place in stat.
 *
 * @param client        Player index
 * @return int
 */
native GG_GetPlayerPlaceInStat(client);

/**
 * Count number of winners in stat.
 *
 * @return int
 */
native GG_CountPlayersInStat();

/**
 * Retrieves player current total wins
 *
 * @param client        Player index
 * @return int          Total player wins
 */
native GG_GetClientWins(client);

/**
 * Get the player current level.
 *
 * @param client        Player index
 * @return          The player current level (starting from 1).
 */
native GG_GetClientLevel(client);

/**
 * Retrieves the client max level.
 *
 * @param client        Player index.
 * @param return        The client max level (starting from 1).
 */
native GG_GetClientMaxLevel(client);

/**
 * Add a level to the player current level.
 * This does not tell the client that they have leveled.
 *
 * @param client        Player index.
 * @return          The player current level.
 */
native GG_AddALevel(client);

/**
 * Remove a level from the player current level.
 *
 * This does not tell the client that they have lost a level.
 * This also obeys the max level per round.
 *
 * @param client        Player index.
 * @return          The player current level.
 */
native GG_RemoveALevel(client);

/**
 * Add a point to the player point per level.
 *
 * This does not tell the client if they gain a point
 * nor does it tell the client that they leveled due to reaching the max point.
 *
 * @param client        Player index.
 * @return          The current player point per level or 0 if they leveled.
 */
native GG_AddAPoint(client);

/**
 * Removes a point to the player point per level.
 *
 * This does not tell the client if they lost a point
 * nor does it tell the client that they lost a level.
 *
 * @param client        Player index.
 * @return          The current player point per level or GG_GetClientMaxPointLevel() - 1 if they lost a level.
 */
native GG_RemoveAPoint(client);

/**
 * Retrieves the client current point per level.
 *
 * @param client        Player index.
 * @return          The current player point per level.
 */
native GG_GetClientPointLevel(client);

/**
 * Retrieves the client max point per level.
 *
 * @param client        Player index.
 * @return          The player max point per level.
 */
native GG_GetClientMaxPointLevel(client);

/**
 * Set the level weapon by weapon index.
 *
 * @param level     The weapon level (starting from 1)
 * @param weapon        The weapon index
 * @noreturn
 */
native GG_SetWeaponLevel(level, Weapons:weapon);

/**
 * Set the level weapon by weapon name.
 *
 * @param level     The weapon level (starting from 1)
 * @param weapon        The weapon name
 */
native GG_SetWeaponLevelByName(level, const String:weapon[]);

/**
 * Set the maximum level the player can achieve to win the game.
 *
 * @param level     The level (starting from 1)
 * @noreturn
 * @error               If level is greater than the define maximum.
 *
 */
native GG_SetMaxLevel(level);

/**
 * Retrieves the weapon index from weapon name.
 *
 * @param weapon        The short weapon name. ie awp, glock.
 * @return          0 if weapon is not found or the CSW_* weapon index.
 */
native Weapons:GG_GetWeaponIndex(const String:weapon[]);

/**
 * Retrieves if the game is commenced.
 *
 * @noparam
 * @return          Return true if game is commenced otherwise false.
 */
native bool:GG_IsGameCommenced();

/**
 * Get weapon name from level.
 *
 * @param level         The current level (starting from 1).
 * @param weapon        The weapon name to get.
 * @param maxlength     Max length of weapon String.
 * @noreturn
 */
native GG_GetLevelWeaponName(level, String:weapon[], maxlength);

/**
 * Stocks
 */

stock UTIL_StringToLower(String:Source[])
{
    new len = strlen(Source);

    for(new i = 0; i <= len; i++)
    {
        if(IsCharUpper(Source[i]))
        {
            Source[i] |= (1<<5);
        }
    }

    return 1;
}

stock UTIL_StringToUpper(String:Source[])
{
    new len = strlen(Source);

    /* Should this be i <= len */
    for(new i = 0; i <= len; i++)
    {
        if(IsCharLower(Source[i]))
        {
            Source[i] &= ~(1<<5);
        }
    }

    return 1;
}

/* Do not edit the code below. */
public SharedPlugin:__pl_gungame =
{
    name = "gungame",
    file = "gungame.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};
