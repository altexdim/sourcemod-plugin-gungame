<?php

if ($argc < 2) {
    exit("Usage: php {$argv[0]} <input.db> <output.db>\n"
        ."\tinput.db - path to ES GG 5.1 winners database file\n"
        ."\toutput.db - path to SM GG winners database file (usualy \"sourcemod-local.sq3\" located in \"addons\\sourcemod\\data\\sqlite\\\")\n");
}

$fileIn = $argv[1];
$fileOut = $argv[2];

if (!is_file($fileIn) || !file_exists($fileIn)) {
    exit("File $fileIn not found\n");
}

$dbOutput = new SQLite3($fileOut);
$results = $dbOutput->query('SELECT name FROM sqlite_master WHERE name = \'gungame_playerdata\';');
$row = $results->fetchArray(SQLITE3_ASSOC);
if ($row === false) {
    // table does not exist
    $results = $dbOutput->query('CREATE TABLE IF NOT EXISTS gungame_playerdata (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        wins int(12) NOT NULL default 0, 
        authid varchar(255) NOT NULL default \'\', 
        name varchar(255) NOT NULL default \'\', 
        timestamp timestamp NOT NULL default CURRENT_TIMESTAMP
    );');
    $results = $dbOutput->query('CREATE INDEX wins ON gungame_playerdata(wins);');
    $results = $dbOutput->query('CREATE INDEX authid ON gungame_playerdata(authid);');
}

$dbInput = new SQLite3($fileIn);
$results = $dbInput->query('select name, uniqueid, wins, timestamp from gg_wins');
while ($row = $results->fetchArray(SQLITE3_ASSOC)) {
    $result2 = $dbOutput->query(sprintf(
        'SELECT * FROM gungame_playerdata WHERE authid = \'%s\';',
        SQLite3::escapeString($row['uniqueid'])
    ));

    if ($result2->fetchArray(SQLITE3_ASSOC) === false) {
        echo "ADD USER NAME=\"{$row['name']}\" STEAM_ID={$row['uniqueid']} WINS={$row['wins']}\n";
    
        // user does not exist
        $dbOutput->query(sprintf(
            'INSERT INTO gungame_playerdata (wins, authid, name) VALUES (%d, \'%s\', \'%s\');', 
            intval($row['wins']), 
            SQLite3::escapeString($row['uniqueid']),
            SQLite3::escapeString($row['name'])
        ));
    } else {
        echo "UPDATE USER NAME=\"{$row['name']}\" STEAM_ID={$row['uniqueid']} WINS={$row['wins']}\n";

        // user found
        $dbOutput->query(sprintf(
            'UPDATE gungame_playerdata SET wins = wins + %d, name = \'%s\', timestamp = current_timestamp WHERE authid = \'%s\';', 
            intval($row['wins']), 
            SQLite3::escapeString($row['name']),
            SQLite3::escapeString($row['uniqueid'])
        ));
    }
    
}

echo "Done\n";
exit(0);
