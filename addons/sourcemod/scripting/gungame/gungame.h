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
    WarmupTimerSound,
    MaxSounds
}

#if defined WITH_CSS_SUPPORT
// Killable weapons
new const String:WeaponName[Weapons:MAXWEAPON][] =
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
    Slot_None,
    Slot_Knife,
    // Secondary Weapon
    Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary,
    // Primary weapon
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,

    Slot_Grenade, Slot_Grenade, Slot_Grenade
};

new const WeaponAmmo[Weapons:MAXWEAPON] =
{
    0,
    0,
    // Secondary Weapon
    12, 20, 13, 7, 20, 30,
    // Primary weapon
    8, 7, 30, 30, 30, 25, 50, 35,
    25, 30, 30, 30, 30, 30, 30, 10,
    20, 100,

    1, 2, 1
};
#endif

#if defined WITH_CSGO_SUPPORT
// Killable weapons
new const String:WeaponName[Weapons:MAXWEAPON][] = {
    // none
    "",
    // melee
    "weapon_knife", "weapon_knifegg", "weapon_taser",
    // Secondary Weapon
    "weapon_glock", "weapon_p250", "weapon_fiveseven", "weapon_deagle", "weapon_elite", "weapon_hkp2000", "weapon_tec9",
    // Primary weapon
    "weapon_nova", "weapon_xm1014", "weapon_sawedoff", 
    "weapon_m249", "weapon_negev", "weapon_mag7", 
    "weapon_mp7", "weapon_ump45", "weapon_p90", "weapon_bizon", "weapon_mp9", "weapon_mac10",
    "weapon_famas", "weapon_m4a1", "weapon_aug", "weapon_galilar", "weapon_ak47", "weapon_sg556",
    "weapon_ssg08", "weapon_awp", "weapon_scar20", "weapon_g3sg1",
    // nade
    "weapon_decoy", "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade", "weapon_incgrenade", "weapon_molotov",
    // c4
    "weapon_c4"
};

new const Slots:WeaponSlot[Weapons:MAXWEAPON] = {
    // none
    Slot_None,
    // melee
    Slot_Knife, Slot_Knife, Slot_Knife,
    // Secondary Weapon
    Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary, Slot_Secondary,
    // Primary weapon
    Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    Slot_Primary, Slot_Primary, Slot_Primary, Slot_Primary,
    // nade
    Slot_Grenade, Slot_Grenade, Slot_Grenade, Slot_Grenade, Slot_Grenade, Slot_Grenade,
    // c4
    Slot_C4
};

// clip size
new const WeaponAmmo[Weapons:MAXWEAPON] = {
    // none
    0,
    // melee
    0, 0, 0,
    // Secondary Weapon
    20, 13, 20, 7, 30, 13, 32,
    // Primary weapon
    8, 7, 7,
    100, 150, 5,
    30, 25, 50, 64, 30, 30,
    25, 30, 30, 35, 30, 30,
    10, 10, 20, 20,
    // nade
    0, 0, 0, 0, 0, 0,
    // c4
    0
};
#endif

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

/* Status forwards */
new Handle:FwdLevelChange = INVALID_HANDLE;
new Handle:FwdWarmupEnd = INVALID_HANDLE;
new Handle:FwdWinner = INVALID_HANDLE;
new Handle:FwdSoundWinner = INVALID_HANDLE;
new Handle:FwdTripleLevel = INVALID_HANDLE;
new Handle:FwdLeader = INVALID_HANDLE;
new Handle:FwdVoteStart = INVALID_HANDLE;
new Handle:FwdDisableRtv = INVALID_HANDLE;
new Handle:FwdDeath = INVALID_HANDLE;
new Handle:FwdPoint = INVALID_HANDLE;
new Handle:FwdStart = INVALID_HANDLE;
new Handle:FwdShutdown = INVALID_HANDLE;

new Handle:WarmupTimer = INVALID_HANDLE;

new bool:IsActive = false;
new bool:IsObjectiveHooked;
new HostageEntInfo;
new Handle:PlayerLevelsBeforeDisconnect = INVALID_HANDLE;
new g_IsInGiveCommand = false;
new Handle:g_Timer_HandicapUpdate = INVALID_HANDLE;
new Handle:PlayerHandicapTimes = INVALID_HANDLE;
new bool:g_SkipSpawn[MAXPLAYERS+1] = {false, ...};
// only primary and secondary is needed, so array size = secondary + 1 = knife
new g_ClientSlotEnt[MAXPLAYERS+1][Slot_Knife];
new g_ClientSlotEntHeGrenade[MAXPLAYERS+1];
new g_ClientSlotEntSmoke[MAXPLAYERS+1];
new g_ClientSlotEntFlash[MAXPLAYERS+1][2];

new GameName:g_GameName = GameName:None;
