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

public GG_OnWinner(client, const String:Weapon[])
{
	if(IsClientInGame(client) && !IsFakeClient(client))
	{
		CheckRank(client, ++PlayerWinsData[client]);
	}
}

IsPlayerInTop10(const String:Auth[])
{
	for(new i = 0; i < MAX_RANK; i++)
	{
		if(strcmp(Auth, PlayerAuthid[i]) == 0)
		{
			return i;
		}
	}

	return -1;
}

CheckRank(client, Wins)
{
	SavePlayerData(client);

	decl String:Authid[64];
	GetClientAuthString(client, Authid, sizeof(Authid));

	new location = IsPlayerInTop10(Authid);

	if(location != -1)
	{
		RankChange = true;

		/* If they are already in the rank 1 just update they rank otherwise check*/
		if(location && Wins > PlayerWins[location - 1])
		{
			SwitchRanks(client, location - 1, location, Authid);
			// FIXME: If switch ranks then where is PlayerWins updated?
			return;
		} /* Otherwise just update their wins because their rank has not change */

		PlayerWins[location] = Wins;
		return;
	}

	for(new i = 0; i < MAX_RANK; i++)
	{
		if(Wins > PlayerWins[i])
		{
			RankChange = true;
			/**
			 * Winner Winner Winner
			 * Let shift old ranks up.
			 */
			ShiftRanksUp(client, Wins, i, Authid);
			break;
		}
	}
}

SwitchRanks(client, New, Old, const String:Auth[64])
{
	decl TempWins, String:TempAuth[64];

	TempWins = PlayerWins[Old];
	TempAuth = PlayerAuthid[Old];

	PlayerWins[Old] = PlayerWins[New];
	PlayerName[Old] = PlayerName[New];
	PlayerAuthid[Old] = PlayerAuthid[New];

	/* Update player name in the top10 */
	GetClientName(client, PlayerName[New], sizeof(PlayerName[]));
	PlayerWins[New] = TempWins;
	PlayerAuthid[New] = Auth;
}

ShiftRanksUp(client, Wins, RankToReplace, const String:Auth[64])
{
	new b = MAX_RANK - 1, c;

	while(--b >= RankToReplace)
	{
		/* Makes sure there a rank in the slot before shift up otherwise stop */
		if((c = PlayerWins[b]) != 0)
		{
			PlayerWins[b + 1] = c;
			PlayerAuthid[b + 1] = PlayerAuthid[b];
			PlayerName[b + 1] = PlayerName[b];
		}
	}

	PlayerWins[RankToReplace] = Wins;
	GetClientName(client, PlayerName[RankToReplace], sizeof(PlayerName[]));
	PlayerAuthid[RankToReplace] = Auth;
}

