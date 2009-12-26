new PlayerState[MAXPLAYERS + 1];
new PlayerOnGrenade;

// TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
// new bool:IsIntermissionCalled;

/**
 * Caching information to see if there aleast a player on each team
 * Work around for game_start and game_end. Use GameCommenced for replacement
 */
new bool:GameCommenced;
new CTcount;
new Tcount;

/* Checks to make sure clients only gain level by objective during Round Started and not during Round End*/
new bool:RoundStarted;

/* Changes the default MinKillsPerWeapon setting if value is greater than 0. */
new CustomKillPerLevel[GUNGAME_MAX_LEVEL];

new PlayerLevel[MAXPLAYERS + 1];
new CurrentKillsPerWeap[MAXPLAYERS + 1];
new CurrentLevelPerRound[MAXPLAYERS + 1];
new CurrentLevelPerRoundTriple[MAXPLAYERS + 1];
new CurrentLeader;
new GameWinner;