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

new const String:DATE[] = __DATE__;
new const String:TIME[] = __TIME__;

/* PlayerState[client] */
#define KNIFE_ELITE         (1<<0)
#define FIRST_JOIN          (1<<1)
#define GRENADE_LEVEL       (1<<2)

enum Sounds
{
    Welcome,
    Knife,
    Nade,
    Steal,
    Up,
    Down,
    Triple,
    AutoFF,
    MultiKill,
    Winner,
    MaxSounds
}

// Killable weapons
new const String:WeaponName[MAXWEAPON][] =
{
    "",
    "weapon_knife",
    // Secondary Weapon
    "weapon_usp", "weapon_glock", "weapon_p228", "weapon_deagle", "weapon_fiveseven", "weapon_elite",
    // Primary weapon
    "weapon_m3", "weapon_xm1014", "weapon_tmp", "weapon_mac10", "weapon_mp5navy", "weapon_ump45", "weapon_p90", "weapon_galil",
    "weapon_famas", "weapon_ak47", "weapon_m4a1", "weapon_sg552", "weapon_aug", "weapon_scout", "weapon_sg550", "weapon_awp",
    "weapon_g3sg1", "weapon_m249",

    "weapon_hegrenade", "weapon_flashbang", "weapon_smokegrenade"
};

new const Slots:WeaponSlot[Weapons:MAXWEAPON] =
{
    Slots:NULL,
    Slot_Knife,
    // Secondary Weapon
    Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary,
    // Primary weapon
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,

    Slot_Grenade, Slot_Grenade, Slot_Grenade
};

/**
 * Minimum level to win on max timelimit reached.
 */
new MinimumLevel;

new String:EventSounds[Sounds:MaxSounds][64];

/* Default values for weapon order.*/
new Weapons:WeaponOrderId[GUNGAME_MAX_LEVEL];
new String:WeaponOrderName[GUNGAME_MAX_LEVEL][24];
new WeaponOrderCount;
new RandomWeaponOrderMap[GUNGAME_MAX_LEVEL];
new bool:RandomWeaponOrder;

// ConVar Pointer
new Handle:mp_friendlyfire = INVALID_HANDLE;
new Handle:mp_restartgame = INVALID_HANDLE;
new Handle:gungame_enabled = INVALID_HANDLE;
new Handle:cssdm_enabled = INVALID_HANDLE;

/* Status forwards */
new Handle:FwdLevelChange = INVALID_HANDLE;
new Handle:FwdWinner = INVALID_HANDLE;
new Handle:FwdLeader = INVALID_HANDLE;
new Handle:FwdVoteStart = INVALID_HANDLE;
new Handle:FwdDeath = INVALID_HANDLE;
new Handle:FwdPoint = INVALID_HANDLE;
new Handle:FwdStart = INVALID_HANDLE;
new Handle:FwdShutdown = INVALID_HANDLE;

new Handle:WarmupTimer = INVALID_HANDLE;
new UserMsg:VGUIMenu = INVALID_MESSAGE_ID;

new TakeDamage[MAXPLAYERS + 1];

/* Work around for cssdm 2.0 because cssdm remove weapon exactly on weapon drop. */
new bool:IsDmActive = false;
new bool:IsActive = false;
new bool:IsObjectiveHooked;
new HostageEntInfo;
