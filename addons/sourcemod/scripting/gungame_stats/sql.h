new Handle:g_DbConnection = INVALID_HANDLE;

#if defined MYSQL_SUPPORT
new String:g_sql_createPlayerTable[]    = "CREATE TABLE IF NOT EXISTS `gungame_playerdata`(`id` int(11) NOT NULL auto_increment,`wins` int(12) NOT NULL default '0',`authid` varchar(255) NOT NULL default '',`name` varchar(255) NOT NULL default '',`timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,PRIMARY KEY  (`id`),KEY `wins` (`wins`),KEY `authid` (`authid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
#endif
#if defined SQLITE_SUPPORT
new String:g_sql_createPlayerTable[]    = "CREATE TABLE IF NOT EXISTS gungame_playerdata (   id INTEGER PRIMARY KEY AUTOINCREMENT, wins int(12) NOT NULL default 0, authid varchar(255) NOT NULL default '', name varchar(255) NOT NULL default '', timestamp timestamp NOT NULL default CURRENT_TIMESTAMP );";
new String:g_sql_createPlayerTableIndex1[]  = "CREATE INDEX wins ON gungame_playerdata(wins);";
new String:g_sql_createPlayerTableIndex2[]  = "CREATE INDEX authid ON gungame_playerdata(authid);";
#endif
new String:g_sql_dropPlayerTable[]      = "DROP TABLE IF EXISTS gungame_playerdata;";
#if defined MYSQL_SUPPORT
new String:g_sql_checkTableExists[]     = "SHOW TABLES like 'gungame_playerdata';";
#endif
#if defined SQLITE_SUPPORT
new String:g_sql_checkTableExists[]     = "SELECT name FROM sqlite_master WHERE name = 'gungame_playerdata';";
#endif

new String:g_sql_insertPlayer[]         = "INSERT INTO gungame_playerdata (wins, name, timestamp, authid) VALUES (%i, \"%s\", current_timestamp, \"%s\");";
new String:g_sql_updatePlayerByAuth[]   = "UPDATE gungame_playerdata SET wins = %i, name = \"%s\", timestamp = current_timestamp WHERE authid = \"%s\";";
new String:g_sql_getPlayerPlaceByWins[] = "SELECT count(*) FROM gungame_playerdata WHERE wins > %i;";
new String:g_sql_getPlayersCount[]      = "SELECT count(*) FROM gungame_playerdata;";
new String:g_sql_getPlayerByAuth[]      = "SELECT id, wins, name FROM gungame_playerdata WHERE authid = \"%s\";";
new String:g_sql_updatePlayerTsById[]   = "UPDATE gungame_playerdata SET timestamp = current_timestamp WHERE id = %i;";
#if defined MYSQL_SUPPORT
new String:g_sql_prunePlayers[]         = "DELETE FROM gungame_playerdata WHERE timestamp < current_timestamp - interval %i day;";
#endif
#if defined SQLITE_SUPPORT
new String:g_sql_prunePlayers[]         = "DELETE FROM gungame_playerdata WHERE timestamp < %i;";
#endif
new String:g_sql_getTopPlayers[]      = "SELECT id, wins, name, authid FROM gungame_playerdata ORDER by wins desc, id LIMIT %i OFFSET %i;";

