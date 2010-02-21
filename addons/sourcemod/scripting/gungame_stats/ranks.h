/**
 * Max rank for stats.
 */
#define MAX_RANK         10

new bool:RankChange;
new bool:HasRank;
new String:PlayerName[MAX_RANK][MAX_NAME_SIZE];
new PlayerWins[MAX_RANK];

/* Top10 ranks */
new String:PlayerAuthid[MAX_RANK][64];

