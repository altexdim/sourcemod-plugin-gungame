/**
 * Top10 and player data will sync after map change.
 */

new bool:SaveProcess;

/* Player Data */
new PlayerWinsData[MAXPLAYERS + 1] = {0, ...};
new bool:IsActive;

#if defined SQL_SUPPORT
    new PlayerPlaceData[MAXPLAYERS + 1] = {0, ...};
    new TotalWinners = 0;
#endif

