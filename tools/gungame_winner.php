<?php

// This is gungame winner motd file that is been shown by gungame_display_winner plugin.

header("Content-type: text/html; charset=utf-8");

function show($varName)
{
    if ( isset($_GET[$varName]) )
    {
        echo mb_convert_encoding($_GET[$varName],"HTML-ENTITIES","UTF-8");
    }
}

?>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>GunGame Winner</title>
    </head>
<body>
    <b><?php show("winnerName"); ?></b> Won!<hr><br />
    <b><?php show("winnerName"); ?></b> won the game by killing <b><?php show("loserName"); ?></b>
    <br /><br />
    <b>Stats:</b><br />
    Wins: <b><?php show("wins"); ?></b><br />
    Place: <b><?php show("place"); ?></b> of <b><?php show("totalPlaces"); ?></b>
</body>
</html>

