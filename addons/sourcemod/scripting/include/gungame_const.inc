#if defined _gungame_const_included_
  #endinput
#endif
#define _gungame_const_included_

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

stock const String:GUNGAME_AUTHOR[] = "teame06-hat, Liam, Otstrel.ru Team";
stock const String:GUNGAME_URL[] = "http://www.hat-city.net, http://otstrel.ru";
stock const String:GUNGAME_VERSION[] = "1.0.7.5";
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

