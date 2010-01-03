#if defined _gungame_st_natives_included_
  #endinput
#endif
#define _gungame_st_natives_included_

/**
 * Const
 */

/**
 * Show the top10 to the client
 *
 * @param client        Player index.
 * @noreturn
 */
native GG_DisplayTop10(client); /* HINT: gungame_stats */

/**
 * Return current player's place in stat.
 *
 * @param client        Player index
 * @return int
 */
native GG_GetPlayerPlaceInStat(client); /* HINT: gungame_stats */

/**
 * Count number of winners in stat.
 *
 * @return int
 */
native GG_CountPlayersInStat(); /* HINT: gungame_stats */

/**
 * Retrieves player current total wins
 *
 * @param client        Player index
 * @return int          Total player wins
 */
native GG_GetClientWins(client); /* HINT: gungame_stats */

/**
 * Get player's place in top 10.
 *
 * @param auth          Steam id.
 * @return              Player place in top 10 (from 0 to 9), -1 if not found.
 */
native GG_GetPlayerPlaceInTop10(const String:auth[]); /* HINT: gungame_stats */

/* Do not edit the code below. */
public SharedPlugin:__pl_gungame_st =
{
    name = "gungame_st",
    file = "gungame_stats.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

public __pl_gungame_st_SetNTVOptional()
{
    MarkNativeAsOptional("GG_DisplayTop10");
    MarkNativeAsOptional("GG_GetPlayerPlaceInStat");
    MarkNativeAsOptional("GG_CountPlayersInStat");
    MarkNativeAsOptional("GG_GetClientWins");
    MarkNativeAsOptional("GG_GetPlayerPlaceInTop10");
}
