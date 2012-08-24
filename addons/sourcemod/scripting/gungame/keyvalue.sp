/**
 * Ranking and Player Data.
 */

/**
 * How to store other player data rank/wins like this. How to do this so it fast?
 * Lookup fast so we can change the keyvalue wins. Have to search for any matching steamid.
 * If not then create a new entry.
 *
 * Pruning old data out? Config file with option NumberOfDays to prune or something like that.
 * By default 30 days since the player has enter the server. 60 * 60 * 24 * 30 = 2592000
 * new TimeStamp[2] GetTime(TimeStamp); I believe [0] is the 32 bit timestamp. (Need to check)
 *
 * new NumberOfDaysInSeconds = 86400 * DaysVariableFromConfig;
 * if(Player_TimeStamp <= (TimeStamp[0] - NumberOfDaysInSeconds)) { // Delete player from player data ranking }
 * They been away from the server for 30 days already. Clear out old information.
 *
 * To update the player TimeStamp? on PutInServer or join of team/class? Probably best on join after class.
 * Will this have alot of impact on the server? ie long list? will it cause lag?
 *
 * Player has to have aleast one win to be in the list.
 */

 /* keyvalues?. It would be faster if the news header was the rank so faster replace
 * or news header would be Authid for faster lookup instead of going rank->Authid? Which one would be better?
 *
 * We always read top10 into memory and read in OnPluginStart. No need to reload it every single map unless it changed.
 * Add a command in the top10/rank plugin to allow reloading of the top10 (ie admin need editing the top10 list).
 *
 * When a change has occur have a bool:var change to true. When OnMapEnd() is call write clear and write out the new top10
 * list otherwise don't do anything. I believe this is the best way so it doesn't have to reload every map change.
 */

/* Have an option cvar to save on change if changed */

OnKeyValueStart()
{
    /* Make sure to use unique section name just incase someone else uses it */
    KvWeapon = CreateKeyValues("gg_WeaponInfo", BLANK, BLANK);
    if (g_GameName == GameName:Css) {
        FormatEx(WeaponFile, sizeof(WeaponFile), "cfg\\gungame\\css\\weaponinfo.txt");
    } else if (g_GameName == GameName:Csgo) {
        FormatEx(WeaponFile, sizeof(WeaponFile), "cfg\\gungame\\csgo\\weaponinfo.txt");
    }

    if ( !FileExists(WeaponFile) )
    {
        decl String:Error[PLATFORM_MAX_PATH + 64];
        FormatEx(Error, sizeof(Error), "FATAL ERROR File does not exists [%s]", WeaponFile);
        SetFailState(Error);
    }

    WeaponOpen = FileToKeyValues(KvWeapon, WeaponFile);

    if ( TrieWeapon == INVALID_HANDLE )
    {
        TrieWeapon = CreateTrie();
    }
    else
    {
        ClearTrie(TrieWeapon);
    }
    
    if ( !WeaponOpen )
    {
        return;
    }

    KvRewind(KvWeapon);

    if ( !KvGotoFirstSubKey(KvWeapon) )
    {
        return;
    }

    new String:name[MAX_WEAPON_NAME_LEN];
    new index;
    g_WeaponsMaxId          = 0;
    g_WeaponIdKnife         = 0;
    g_WeaponIdHegrenade     = 0;
    g_WeaponIdSmokegrenade  = 0;
    g_WeaponIdFlashbang     = 0;

    g_WeaponAmmoTypeHegrenade       = 0;
    g_WeaponAmmoTypeFlashbang       = 0;
    g_WeaponAmmoTypeSmokegrenade    = 0;

    for (;;) {
        if ( !KvGetSectionName(KvWeapon, name, sizeof(name)) ) {
            break;
        }

        index = KvGetNum(KvWeapon, "index");
        UTIL_StringToLower(name);

        // init weapons by name array
        SetTrieValue(TrieWeapon, name, index);
        // init weapons count
        g_WeaponsMaxId++;
        // init weapons full names (to use in give commands)
        FormatEx(g_WeaponName[index], sizeof(g_WeaponName[]), "weapon_%s", name);
        // init weapons slots
        g_WeaponSlot[index] = Slots:KvGetNum(KvWeapon, "slot");
        // init weapons clip size
        g_WeaponAmmo[index] = KvGetNum(KvWeapon, "clipsize", 0);

        if (KvGetNum(KvWeapon, "is_knife", 0)) {
            g_WeaponIdKnife                 = index;
        } else if (KvGetNum(KvWeapon, "is_hegrenade", 0)) {
            g_WeaponIdHegrenade             = index;
            g_WeaponAmmoTypeHegrenade       = KvGetNum(KvWeapon, "ammotype", 0);
        } else if (KvGetNum(KvWeapon, "is_smokegrenade", 0)) {
            g_WeaponIdSmokegrenade          = index;
            g_WeaponAmmoTypeSmokegrenade    = KvGetNum(KvWeapon, "ammotype", 0);
        } else if (KvGetNum(KvWeapon, "is_flashbang", 0)) {
            g_WeaponIdFlashbang             = index;
            g_WeaponAmmoTypeFlashbang       = KvGetNum(KvWeapon, "ammotype", 0);
        } 
        
        if ( !KvGotoNextKey(KvWeapon) ) {
            break;
        }
    }

    KvRewind(KvWeapon);

    if (!(  g_WeaponsMaxId
            && g_WeaponIdKnife
            && g_WeaponIdHegrenade
            && g_WeaponIdSmokegrenade
            && g_WeaponIdFlashbang
    )) {
        decl String:Error[1024];
        FormatEx(Error, sizeof(Error), "FATAL ERROR: Some of the weapons not found MAXID=[%i] KNIFE=[%i] HE=[%i] SMOKE=[%i] FLASH=[%i]", 
            g_WeaponsMaxId, g_WeaponIdKnife, g_WeaponIdHegrenade, g_WeaponIdSmokegrenade, g_WeaponIdFlashbang);
        SetFailState(Error);
    }

    if (!(  g_WeaponAmmoTypeHegrenade
            && g_WeaponAmmoTypeFlashbang
            && g_WeaponAmmoTypeSmokegrenade
    )) {
        decl String:Error[1024];
        FormatEx(Error, sizeof(Error), "FATAL ERROR: Some of the weapon types not found HE=[%i] FLASH=[%i] SMOKE=[%i]", 
            g_WeaponsMaxId, g_WeaponAmmoTypeHegrenade, g_WeaponAmmoTypeFlashbang, g_WeaponAmmoTypeSmokegrenade);
        SetFailState(Error);
    }
}
