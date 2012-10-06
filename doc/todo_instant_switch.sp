#pragma semicolon 1

#include <sdktools>
#include <sdkhooks>

public Plugin:myinfo = {
    name        = "test",
    author      = "test",
    description = "test",
    version     = "test",
    url         = "test"
};

new g_index     = 0;
new g_index2    = 0;
new String:g_weapons[][] = {
    "weapon_glock",
    "weapon_p250",
    "weapon_fiveseven",
    "weapon_deagle",
    "weapon_elite",
    "weapon_hkp2000",
    "weapon_tec9",

    "weapon_nova",
    "weapon_xm1014",
    "weapon_sawedoff",

    "weapon_m249",
    "weapon_negev",
    "weapon_mag7",

    "weapon_mp7",
    "weapon_ump45",
    "weapon_p90",
    "weapon_bizon",
    "weapon_mp9",
    "weapon_mac10",

    "weapon_famas",
    "weapon_m4a1",
    "weapon_aug",
    "weapon_galilar",
    "weapon_ak47",
    "weapon_sg556",

    "weapon_ssg08",
    "weapon_awp",
    "weapon_scar20",
    "weapon_g3sg1",

    "weapon_taser",
    "weapon_molotov",
    "weapon_hegrenade"

};

SwitchWeapon(client) {
    if (g_index+1>= sizeof(g_weapons)) {
        g_index = 0;
    } else {
        g_index++;
    }

    for (new i = 0, ent; i < 2; i++) {
        ent = GetPlayerWeaponSlot(client, i);
        if (ent > 0) {
            RemovePlayerItem(client, ent);
            RemoveEdict(ent);
        }
    }

    new weapon = GivePlayerItem(client, g_weapons[g_index]);
    FakeClientCommand(client, "use %s", g_weapons[g_index]);
    InstantSwitch(client, weapon);
}

public OnPluginStart() {
    HookEvent("player_death", Event_PlayerDeath);
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast) {
    new client = GetClientOfUserId(GetEventInt(event, "attacker"));
    if (!client) {
        return;
    }
    SwitchWeaponDelayed(client);
}

SwitchWeaponDelayed(client) {
    CreateTimer(0.1, Timer_SwitchWeapon, client);
}

public Action:Timer_SwitchWeapon(Handle:timer, any:client) {
    if (client&&IsClientInGame(client)&&IsPlayerAlive(client)) {
        SwitchWeapon(client);
    }
}

public OnMapStart() {
    for (new client = 1; client <= MaxClients; client++) { 
        if (IsClientInGame(client)) {
            SDKHook(client, SDKHook_WeaponSwitch, OnWeaponSwitch);
        } 
    }
}

public OnClientPutInServer(client) {
    SDKHook(client, SDKHook_WeaponSwitch, OnWeaponSwitch);
}

public Action:OnWeaponSwitch(client, weapon) {
    new Handle:data;
    data = CreateDataPack();
    WritePackCell(data, client);
    WritePackCell(data, weapon);

    CreateTimer(0.1, Timer_InstantSwitch, data);

    return Plugin_Continue;
}

public Action:Timer_InstantSwitch(Handle:timer, any:data) {
    ResetPack(data);
    new client = ReadPackCell(data);
    new weapon = ReadPackCell(data);
    CloseHandle(data);

    if (client&&IsClientInGame(client)&&IsPlayerAlive(client)) {
        InstantSwitch(client, weapon, 1);
    }
}

InstantSwitch(client, weapon, timer = 0) {
    new Float:GameTime = GetGameTime();

    if (!timer) {
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
        SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", GameTime);
    }

    SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GameTime);
    new ViewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
    SetEntProp(ViewModel, Prop_Send, "m_nSequence", 0);
}
