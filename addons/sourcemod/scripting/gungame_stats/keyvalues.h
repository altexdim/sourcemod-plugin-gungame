/* Contains the top 10 data */
new String:RankFile[PLATFORM_MAX_PATH];
new Handle:KvRank = INVALID_HANDLE;
new bool:RankOpen;

/* Contains players wins data */
#if !defined SQL_SUPPORT
new String:PlayerFile[PLATFORM_MAX_PATH];
new Handle:KvPlayer = INVALID_HANDLE;
new bool:PlayerOpen;
#endif

new const String:Numbers[11][] =
{
    "0", "1", "2", "3", "4", "5",
    "6", "7", "8", "9", "10"
};

new String:RenameFileTop10[PLATFORM_MAX_PATH];