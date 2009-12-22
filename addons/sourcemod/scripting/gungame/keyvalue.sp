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
	FormatEx(WeaponFile, sizeof(WeaponFile), "cfg\\gungame\\weaponinfo.txt");

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

    new String:WeaponName[24];
    new Weapons:WeaponIndex;
    while (true)
    {
        if ( !KvGetSectionName(KvWeapon, WeaponName, sizeof(WeaponName)) )
        {
            break;
        }
        WeaponIndex = Weapons:KvGetNum(KvPlayer, "index");
        SetTrieValue(TrieWeapon, WeaponName, WeaponIndex);
		if ( !KvGotoNextKey(KvWeapon) )
		{
			break;
		}
	}

	KvRewind(KvWeapon);
}
