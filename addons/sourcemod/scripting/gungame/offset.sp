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

OnOffsetStart()
{
	decl String:Error[64];
	OffsetFlags = FindSendPropOffs("CBasePlayer", "m_fFlags");

	if(OffsetFlags == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetFlags [%d]. Please contact the author.", OffsetFlags);
		SetFailState(Error);
	}

	OffsetMovement = FindSendPropOffs("CBasePlayer", "m_flLaggedMovementValue");

	if(OffsetMovement == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetMovement [%d]. Please contact the author.", OffsetMovement);
		SetFailState(Error);
	}

	m_hMyWeapons = FindSendPropOffs("CBasePlayer", "m_hMyWeapons");

	if(m_hMyWeapons == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR m_hMyWeapons [%d]. Please contact the author.", m_hMyWeapons);
		SetFailState(Error);
	}

	FindCstrikeOffset();

	/**
	 * More research need to be done for the other mods.
	 * Golden:S might be good. Not sure of DoD:S
	 * FindDoDOffset();
	 * FindGSOffset();
	 */
}

FindCstrikeOffset()
{
	decl String:Error[64];

	OffsetHostage = FindSendPropOffs("CCSPlayerResource", "m_iHostageEntityIDs");

	if(OffsetHostage == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetHostage [%d]. Please contact the author.", OffsetHostage);
		SetFailState(Error);
	}

	new String:CCSPlayer[] = "CCSPlayer";
	//Offsets
	OffsetMoney = FindSendPropOffs(CCSPlayer, "m_iAccount");

	if(OffsetMoney == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetMoney [%d]. Please contact the author.", OffsetMoney);
		SetFailState(Error);
	}

	OffsetArmor = FindSendPropOffs(CCSPlayer, "m_ArmorValue");

	if(OffsetArmor == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetArmor [%d]. Please contact the author.", OffsetArmor);
		SetFailState(Error);
	}

	OffsetHelm = FindSendPropOffs(CCSPlayer, "m_bHasHelmet");

	if(OffsetHelm == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetHelm [%d]. Please contact the author.", OffsetHelm);
		SetFailState(Error);
	}

	OffsetDefuser = FindSendPropOffs(CCSPlayer, "m_bHasDefuser");

	if(OffsetDefuser == INVALID_OFFSET)
	{
		FormatEx(Error, sizeof(Error), "FATAL ERROR OffsetDefuser [%d]. Please contact the author.", OffsetDefuser);
		SetFailState(Error);
	}
}
