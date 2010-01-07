new Handle:g_DbConnection = INVALID_HANDLE;

new String:g_sql_createPlayerTable[]    = "CREATE TABLE IF NOT EXISTS `gungame_playerdata`(`id` int(11) NOT NULL auto_increment,`wins` int(12) NOT NULL default '0',`authid` varchar(255) NOT NULL default '',`name` varchar(255) NOT NULL default '',`timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,PRIMARY KEY  (`id`),KEY `wins` (`wins`),KEY `authid` (`authid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
new String:g_sql_dropPlayerTable[]      = "DROP TABLE IF EXISTS gungame_playerdata;";
new String:g_sql_checkTableExists[]     = "SHOW TABLES like 'gungame_playerdata';";

new String:g_sql_insertPlayer[]         = "INSERT INTO gungame_playerdata (wins, name, timestamp, authid) VALUES (%i, \"%s\", current_timestamp, \"%s\");";
new String:g_sql_updatePlayerByAuth[]   = "UPDATE gungame_playerdata SET wins = %i, name = \"%s\", timestamp = current_timestamp WHERE authid = \"%s\";";
new String:g_sql_getPlayerPlaceByWins[] = "SELECT count(*) FROM gungame_playerdata WHERE wins > %i;";
new String:g_sql_getPlayersCount[]      = "SELECT count(*) FROM gungame_playerdata;";
new String:g_sql_getPlayerByAuth[]      = "SELECT id, wins, name FROM gungame_playerdata WHERE authid = \"%s\";";
new String:g_sql_updatePlayerTsById[]   = "UPDATE gungame_playerdata SET timestamp = current_timestamp WHERE id = %i;";
new String:g_sql_prunePlayers[]         = "DELETE FROM gungame_playerdata WHERE timestamp < current_timestamp - interval %i day;";
new String:g_sql_getTop10Players[]      = "SELECT id, wins, name, authid FROM gungame_playerdata ORDER by wins desc LIMIT %i OFFSET %i;";

