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

OnCreateNatives()
{
	CreateNative("GG_GetClientLevel", __GetClientLevel);
	CreateNative("GG_GetMaxLevel", __GetMaxLevel);
	CreateNative("GG_SetMaxLevel", __SetMaxLevel);
	CreateNative("GG_AddAPoint", __AddAPoint);
	CreateNative("GG_RemoveAPoint", __RemoveAPoint);
	CreateNative("GG_GetClientPointLevel", __GetClientPointLevel);
	CreateNative("GG_GetClientMaxPointLevel", __GetClientMaxPointLevel);
	CreateNative("GG_AddALevel", __AddALevel);
	CreateNative("GG_RemoveALevel", __RemoveALevel);
	CreateNative("GG_GiveAverageLevel", __GiveAverageLevel);
	CreateNative("GG_IsClientCurrentWeapon", __IsClientCurrentWeapon);
	CreateNative("GG_SetWeaponLevel", __SetWeaponLevel);
	CreateNative("GG_SetWeaponLevelByName", __SetWeaponLevelByName);
	CreateNative("GG_GetWeaponIndex", __GetWeaponIndex);
	CreateNative("GG_IsGameCommenced", __IsGameCommenced);
}

public __IsGameCommenced(Handle:plugin, numParams)
{
	return GameCommenced;
}

public __SetMaxLevel(Handle:plugin, numParams)
{
	new level = GetNativeCell(1);

	if(level < 1 || level > GUNGAME_MAX_LEVEL)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Level out of range [%d]", level);
	}

	/* Error checking */

	if(!WeaponOrderName[level - 1][0])
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Level %d does not have a weapon set", level);
	}

	WeaponOrderCount = level;

	/* Clear any weapon index or name after the max level */
	for(new i = level; i < GUNGAME_MAX_LEVEL; i++)
	{
		WeaponOrderName[i][0] = '\0';
		WeaponOrderId[i] = Weapons:0;
	}

	return 1;
}

/**
 * Retrieve the weapon index for the weapon name.
 *
 * @param weapon		Name of weapon. short or long name.
 */
//native Weapons:GG_GetWeaponIndex(const String:weapon[]);
public __GetWeaponIndex(Handle:plugin, numParams)
{
	decl String:weapon[24];
	GetNativeString(1, weapon, sizeof(weapon));

	return _:UTIL_GetWeaponIndex(weapon);
}

public __GiveAverageLevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	}

	new Count = GetClientCount();

	if(TotalLevel && Count)
	{
		PlayerLevel[client] = TotalLevel / Count;
	}

	return 1;
}

public __RemoveALevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	if(--CurrentLevelPerRound[client] < 0)
	{
		CurrentLevelPerRound[client] = MaxLevelPerRound - 1;
	}

	new level = UTIL_ChangeLevel(client, -1);

	if(TurboMode)
	{
		UTIL_GiveNextWeapon(client, level);
	}

	return 1;
}

public __AddALevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	/*  Do stuff */
	if(CurrentLevelPerRound[client] >= MaxLevelPerRound)
	{
		return 0;
	}

	CurrentLevelPerRound[client]++;
	new level = UTIL_ChangeLevel(client, 1);

	if(TurboMode)
	{
		UTIL_GiveNextWeapon(client, level);
	}

	return level;
}

public __IsClientCurrentWeapon(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	decl String:Weapon[24];
	GetNativeString(2, Weapon, sizeof(Weapon));

	if(strcmp(Weapon, WeaponName[WeaponOrderId[PlayerLevel[client]]], false) == 0)
	{
		return 1;
	}

	return 0;
}

public __GetClientLevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	return PlayerLevel[client] + 1;

}
public __GetMaxLevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	return WeaponOrderCount;
}

public __AddAPoint(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	new level = PlayerLevel[client], Weapons:WeaponLevel = WeaponOrderId[level],
		temp = CustomKillPerLevel[WeaponLevel] ? CustomKillPerLevel[WeaponLevel] : MinKillsPerLevel,
		point = ++CurrentKillsPerWeap[client];

	if(point < temp)
	{
		return point;
	} /* They leveled up.*/

	CurrentKillsPerWeap[client] = NULL;

	if(CurrentLevelPerRound[client] >= MaxLevelPerRound)
	{
		return 0;
	}

	CurrentLevelPerRound[client]++;
	level = UTIL_ChangeLevel(client, 1);

	if(TurboMode)
	{
		UTIL_GiveNextWeapon(client, level);
	}

	return 0;
}

public __RemoveAPoint(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	new level = PlayerLevel[client], Weapons:WeaponLevel = WeaponOrderId[level],
		temp = CustomKillPerLevel[WeaponLevel] ? CustomKillPerLevel[WeaponLevel] : MinKillsPerLevel,
		point = --CurrentKillsPerWeap[client];

	if(point >= 0)
	{
		return point;
	} else {
		CurrentKillsPerWeap[client] = temp - 1;

		if(--CurrentLevelPerRound[client] < 0)
		{
			CurrentLevelPerRound[client] = MaxLevelPerRound - 1;
		}
	}

	level = UTIL_ChangeLevel(client, -1);

	/* They lost a level if turbo mode is enabled return them back to the previous weapon */
	if(TurboMode)
	{
		UTIL_GiveNextWeapon(client, level);
	}

	return temp - 1;
}
public __GetClientPointLevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	return CurrentKillsPerWeap[client];
}
public __GetClientMaxPointLevel(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new maxslots = GetMaxClients( );

	if(client < 1 || client > maxslots)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index [%d]", client);
	} else if(!IsClientInGame(client)) {
		return ThrowNativeError(SP_ERROR_NATIVE, "Client is not currently ingame [%d]", client);
	}

	new level = PlayerLevel[client], Weapons:WeaponLevel = WeaponOrderId[level];

	return CustomKillPerLevel[WeaponLevel] ? CustomKillPerLevel[WeaponLevel] : MinKillsPerLevel;
}

public __SetWeaponLevel(Handle:plugin, numParams)
{
	new level = GetNativeCell(1);

	if(level < 1 || level > GUNGAME_MAX_LEVEL)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Level out of range [%d]", level);
	}

	new Weapons:weap = Weapons:GetNativeCell(2);

	if(weap < CSW_KNIFE || weap > CSW_SMOKEGRENADE)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Weapon index out of range [%d]", weap);
	}

	strcopy(WeaponOrderName[level - 1], sizeof(WeaponOrderName[]), WeaponName[weap]);
	WeaponOrderId[level - 1] = weap;

	return 1;
}

public __SetWeaponLevelByName(Handle:plugin, numParams)
{
	new level = GetNativeCell(1);

	if(level < 1 || level > GUNGAME_MAX_LEVEL)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Level out of range [%d]", level);
	}

	decl String:weapon[24];
	GetNativeString(2, weapon, sizeof(weapon));

	new Weapons:weap = Weapons:UTIL_GetWeaponIndex(weapon);

	if(weap < CSW_KNIFE || weap > CSW_SMOKEGRENADE)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Weapon name is invalid [%s]", weapon);
	}

	strcopy(WeaponOrderName[level - 1], sizeof(WeaponOrderName[]), WeaponName[weap]);
	WeaponOrderId[level - 1] = weap;

	return 1;
}