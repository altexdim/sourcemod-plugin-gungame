[COLOR=#ff6600][SIZE=5][B]GunGame[/B][/SIZE][/COLOR]

[B]Table of contents[/B]
----------------------------------------------------
[LIST]
[*] [goanchor=Description]Description[/goanchor]
[*] [goanchor=Complementary plugins]Complementary plugins[/goanchor]
[*] [goanchor=Commands and Cvars]Commands and Cvars[/goanchor]
[*] [goanchor=Requirements]Requirements[/goanchor]
[*] [goanchor=Installation]Installation[/goanchor]
[*] [goanchor=Plugins]Plugins[/goanchor]
[*] [goanchor=Credits]Credits[/goanchor]
[*] [goanchor=Changelog]Changelog[/goanchor]
[*] [goanchor=TODO]TODO[/goanchor]
[*] [goanchor=FAQ]FAQ[/goanchor]
[*] [goanchor=Issues]Issues[/goanchor]
[*] [goanchor=3-rd party plugins]3-rd party plugins[/goanchor]
[*] [goanchor=maps]My gungame maps[/goanchor]
[*] [goanchor=download]Download[/goanchor]
[/LIST]

[anchor]Description[/anchor][B]Description[/B]
----------------------------------------------------[INDENT]GunGame:SM is the gameplay plugin that makes you to
    act with various guns and not only with your favorite
    one. On spawn you get one weapon. You should kill
    enemy with the current weapon to get next weapon.
    You should kill enemies with all the weapons to win the game.

    [URL]http://forums.alliedmods.net/showthread.php?t=93977[/URL]
[/INDENT]

[anchor]Complementary plugins[/anchor][B]Complementary plugins[/B]
----------------------------------------------------
[LIST]
[*] [B]sm_ggdm[/B] - [URL]http://forums.alliedmods.net/showthread.php?t=103242[/URL]
    - deathmatch
    - elimination
    - spawn protection
    - add custom spawn points
    - remove included weapons from map
[*] [B]sm_noblock[/B] - [URL]http://forums.alliedmods.net/showthread.php?t=91617[/URL]
    - no block players
[*] [B]TeamChange[/B] - [URL]https://forums.alliedmods.net/showthread.php?t=197780[/URL]
    - change team by typing "/t" or "/ct" in chat
[/LIST]

[anchor]Commands and Cvars[/anchor][B]Commands and Cvars[/B]
----------------------------------------------------
[LIST]
[*] [B]sm_gungamesm_version[/B]            - Gungame version.
[*] [B]gungame_enabled[/B]                 - Display if gungame is enabled or disabled.
[/LIST]

[LIST]
[*] [B]gg_version[/B]                      - Show gungame version information.
[*] [B]gg_status[/B]                       - Show state of the current game.
[*] [B]gg_restart[/B]                      - Restarts the whole game from the beginning.
[*] [B]gg_enable[/B]                       - Turn on gungame and restart the game.
[*] [B]gg_disable[/B]                      - Turn off gungame and restart the game.
[*] [B]gg_rebuild[/B]                      - Rebuilds the top10 rank from the player data information.
[*] [B]gg_import[/B]                       - Imports the winners file from es es gungame3. File must be in data/gungame/es_gg_winners_db.txt.
                                      You can convert winners db file from es gungame5 to gungame3 - use tools/convert_winners_esgg_5to3.py.
[*] [B]gg_reset[/B]                        - Reset all gungame stats. (only if sql stats enabled)
[*] [B]gg_importdb[/B]                     - Imports the winners from gungame players data file into database. (only if sql stats enabled)

[*] [B]sm_gg_cfgdirname[/B]                - Define config directory where gungame.config.txt is located. 
                                             Default is "gungame" (so config files will be loaded from "cfg\gungame\").
                                             You can define your own directory after gungame winner, for example exec "sm_gg_cfgdirname gungame-dm",
                                             and after map change the config files will be loaded from "cfg\gungame-dm"
                                             (so config files will be loaded from "cfg\gungame\").

[*] [B]sm_gg_turbo[/B]                     - Change TurboMode config variable.
[*] [B]sm_gg_multilevelamount[/B]          - Change MultiLevelAmount config variable.
[/LIST]

[LIST]
[*] [B]say !level[/B]                      - Show your current level and who is winning.
[*] [B]say !weapons[/B]                    - Show the weapon order.
[*] [B]say !score[/B]                      - Show all player current scores.
[*] [B]say !top[/B]                        - Show the top winners on the server.
[*] [B]say !leader[/B]                     - Show current leaders.
[*] [B]say !rank[/B]                       - Show your current place in stats. (only if sql stats enabled)
[*] [B]say !rules[/B]                      - Show the rules and how to play.
[/LIST]

[anchor]Requirements[/anchor][B]Requirements[/B]
----------------------------------------------------
[LIST]
[*] Counter-Strike: Source, Counter-Strike: Global Offensive
[*] SourceMod 1.4.5+
[*] (Optional, not required by default) SDK Hooks 2.2 or later ([url]https://forums.alliedmods.net/showthread.php?t=106748[/url])
You need SDK Hooks if you want to set specific options in config 
(search for "sdkhooks" in "gungame.config.txt" and read comments for more info)
[/LIST]

[anchor]Installation[/anchor][B]Installation[/B]
----------------------------------------------------
[LIST]
[*] Install Metamod:Source.
[*] Install SourceMod.
[*] (Optional, not required by default) Install SDK Hooks.
[*] Upload the "addons", "sound", and "cfg" into your "cstrike" folder for CS:Source
[*] Config "gungame.config.txt" and "gungame.equip.txt" to your liking in "cfg/gungame/<css|csgo>/"
[*] (Optional, not required by default) If you installed SDK Hooks, remove "gungame.smx" from "plugins" folder
    and add "gungame_sdkhooks.smx" from "disabled" info "plugins" folder.
[*] Restart your server.
[/LIST]

[anchor]Plugins[/anchor][B]Plugins[/B]
----------------------------------------------------
[LIST]
[*] gungame.smx - Main GunGame:SM plugin
[LIST]
[*] Depends on gungame_config.smx, gungame_stats.smx (optional)
[*] Mandatory plugin
[*] Provides almost all gungame functionality
[/LIST]
 
[*] disabled/gungame_sdkhooks.smx - Main GunGame:SM plugin compiled with SDK Hooks support.
[LIST]
[*] You need SDK Hooks if you want to set specific options in config 
(search for "sdkhooks" in "gungame.config.txt" and read comments for more info)
[*] If you want to use sdk hooks version of gungame, then remove gungame.smx and add gungame_sdkhooks.smx.
Don't use both gungame.smx and gungame_sdkhooks.smx.
[/LIST]

[*] gungame_config.smx - Config Reader
[LIST]
[*] No dependencies
[*] Mandatory plugin
[*] Read all config files
[*] Can load different configs (*.config.txt, *.equip.txt) depending on map 
            prefixes and map names in configs/gungame/maps.
            gungame.config.txt will be read first before prefix map name.
            Prefix map name will be executed first before map specfic map.
            Then map specifc config files will be loaded.
[/LIST]
 
[*] gungame_stats.smx - Stats
[LIST]
[*] Depends on gungame.smx, gungame_config.smx
[*] Optional plugin
[*] Displays top10 panel
[*] Stores players wins data and top10 data
[*] Sets handicap level for the new connected players
[/LIST]
 
[*] gungame_afk.smx - Afk Management System
[LIST]
[*] Depends on gungame_config.smx, gungame.smx
[*] Optional plugin
[*] Detect afk players, kick them if needed, do not allow level up on afk players
[/LIST]
 
[*] gungame_mapvoting.smx - Map voting
[LIST]
[*] Depends on gungame.smx, gungame_config.smx
[*] Optional plugin
[*] Starts the map voting for the next map when someone reaches particular level
              by executing gungame.mapvote.cfg
[/LIST]
 
[*] gungame_logging.smx - Logging events
[LIST]
[*] Depends on gungame.smx
[*] Optional plugin
[*] Logs events for players: gg_win, gg_leader, gg_levelup, gg_leveldown, gg_knife_steal, 
              gg_knife_level, gg_triple_level, gg_last_level, gg_team_win, gg_team_lose.
[/LIST]
 
[*] gungame_tk.smx - TeamKill Management System
[LIST]
[*] Depends on gungame.smx, gungame_config.smx
[*] Optional plugin
[*] Level down team killer
[/LIST]
 
[*] gungame_display_winner.smx - Display winner
[LIST]
[*] Depends on gungame.smx, gungame_stats.smx, gungame_config.smx
[*] Optional plugin
[*] When someone wins it shows MOTD window with external URL displaing some info 
                about winner.
[/LIST]
 
[*] gungame_bot.smx - Bot protection
[LIST]
[*] Depends on gungame.smx, gungame_config.smx
[*] Optional plugin
[*] Does not allow players to win by killing a bot.
[/LIST]

[*] gungame_warmup_configs.smx - Warmup configs execution
[LIST]
[*] Depends on gungame.smx, gungame_config.smx
[*] Optional plugin
[*] Executes configs gungame.warmupend.cfg and gungame.warmupstart.cfg on warmup start and end.
[/LIST]

[*] gungame_winner_effects.smx - Winner effects after player win
[LIST]
[*] Depends on gungame.smx, gungame_config.smx
[*] Optional plugin
[*] Adds winner effect, configured in gungame.config.txt.
[/LIST]

[/LIST]
            
[anchor]Credits[/anchor][B]Credits[/B]
----------------------------------------------------
[LIST]
[*] Thanks to "blodia" for the plugin "[CSS] Weapon Mod" (http://forums.alliedmods.net/showthread.php?t=123015)
    Fast weapon switch code, fixed weapon animation on fast switch code is ported from this plugin.
[*] Thanks to psychonic! Actualy he made version for CSGO possible and i can not imagine this plugin without his support.
[*] Thanks to Ted Theodore Logan & xDr.HaaaaaaaXx from [url]http://www.war3source.com/[/url]
    for cool visual effect from "War3Source - Addon - Display Particles on Level Up" plugin version 1.1
    used in multi level bonus effect in gungame plugin.
[*] Thanks to exvel for sourcemod library Colors 1.0.2
      [URL]http://forums.alliedmods.net/showthread.php?t=96831[/URL]
[*] Thanks to bl4nk for GunGame Display Winner plugin.
[*] Thanks to Liam for GunGame:SM till version 1.0.0.1
      [URL]http://forums.alliedmods.net/showthread.php?t=80609[/URL]
[*] Original Idea and concepts of Gun Game was made by cagemonkey
      [URL]http://www.cagemonkey.org[/URL]
[*] Original SourceMod code by Teame06
[/LIST]

[B]Translations[/B]
[LIST]
[*] Thanks to PlasteR for the polish translation.
[*] Thanks to Xilver266 for the spanish translation.
[*] Thanks to VoGon for the portuguese translation.
[*] Thanks to tObIwAnKeNoBi for the german translation.
[/LIST]

[anchor]Changelog[/anchor][B]Changelog[/B]
----------------------------------------------------[INDENT]For full changelog see doc/CHANGELOG.txt[/INDENT][anchor]TODO[/anchor][B]TODO[/B]
----------------------------------------------------[INDENT]For full todo list see doc/TODO.txt[/INDENT]

[anchor]FAQ[/anchor][B]FAQ[/B]
----------------------------------------------------

[LIST]
[*][COLOR=#009900][B]Q.[/B][CS:GO] What do I put for game_mode and game_type?[/color]
         [COLOR=#FF0000][B]A.[/B][/color]+game_type 0 +game_mode 0

[*][COLOR=#009900][B]Q.[/B] I want weapon to be changed after leveling up in the same round and not in the next round.[/color]
         [COLOR=#FF0000][B]A.[/B][/color] "TurboMode" "1" in gungame.config.txt.

[*][COLOR=#009900][B]Q.[/B] How to enable/disable gungame depending on map prefixes (aka buyzone issue):[/color]
        [COLOR=#FF0000][B]A.[/B][/color] [URL]http://forums.alliedmods.net/showpost.php?p=1009813&postcount=389[/URL]

[*][COLOR=#009900][B]Q.[/B] How to switch stats database from sqlite to mysql[/color]
        [COLOR=#FF0000][B]A.[/B][/color] [URL]http://forums.alliedmods.net/showpost.php?p=1075809&postcount=865[/URL]

[*][COLOR=#009900][B]Q.[/B] Sound does not work.[/color]
         [COLOR=#FF0000][B]A.[/B][/color] Try to change all slashes ("/") in sound files paths to double-backslashes ("\\") 
         in gungame.config.txt and restart server and client.

[*][COLOR=#009900][B]Q.[/B] Sound still does not work.[/color]
         [COLOR=#FF0000][B]A.[/B][/color] Good article for beginning [url]http://developer.valvesoftware.com/wiki/Pure_Servers[/url]
         Post your question with the following info: output of the command on server "sv_pure",
         output of the command on client "sv_pure" or content of the file "cstrike/pure_server_whitelist.txt",
         output of the command "sv_downloadurl" on server or client.

[*][COLOR=#009900][B]Q.[/B] Weapons desapearing on level up and player spawn.[/color]
         [COLOR=#FF0000][B]A.[/B][/color] If you are using DeathMatch:SM then set [b]sm_ggdm_removeweapons "0"[/b] in [b]server.cfg[/b] and
         set [b]"StripDeadPlayersWeapon" "1"[/b] in [b]gungame.config.txt[/b]. GunGame:SM weapon stripper is much cpu effective
         then DeathMatch:SM weapon stripper, don't use DeathMatch:SM weapon stripper with GunGame:SM, it was designed for non GunGame servers.

[*][COLOR=#009900][B]Q.[/B] I level up on two levels at once.[/color]
        [COLOR=#FF0000][B]A.[/B][/color] Double check that you have only gungame_sdhooks.smx OR gungame.smx in your plugin folder.
        Not both of them. If you have both you have to delete one of them.

[*][COLOR=#009900][B]Q.[/B] I have strange errors in my logs.[/color]
        [COLOR=#FF0000][B]A.[/B][/color] First of all read this error messages carefully. Sometimes log messages has recommendations how to fix
        the issue. Double check that you have only gungame_sdhooks.smx OR gungame.smx in your plugin folder. Not both of them.
        If you have both you have to delete one of them.

[*][COLOR=#009900][B]Q.[/B] I have updated the plugin, and something does not work.[/color]
        [COLOR=#FF0000][B]A.[/B][/color] First of all update weaponinfo.txt.
        Notice, that since version 1.2.0.0 the cfg directory changed it's location from cfg/gungame/ to cfg/gungame/css/ (cfg/gungame/csgo/).
        You can use your old gungame.config.txt and gungame.equip.txt, but you should update new weaponinfo.txt from the release zip file.

[*][COLOR=#009900][B]Q.[/B] Server has been updated and gungame does not work.[/color]
        [COLOR=#FF0000][B]A.[/B][/color] If you have gungame version earlier then 1.2.0.0, you should update to the 1.2.0.0 version or later.
        Notice, that since version 1.2.0.0 the cfg directory changed it's location from cfg/gungame/ to cfg/gungame/css/ (cfg/gungame/csgo/).
        You can use your old gungame.config.txt and gungame.equip.txt, but you should update new weaponinfo.txt from the release zip file.

[*][COLOR=#009900][B]Q.[/B] How do i enable feature X?[/color]
        [COLOR=#FF0000][B]A.[/B][/color] All config files are very good described and documented. Before asking such a question you should read 
        commets in gungame.config.txt and gungame.equip.txt for all config variables.

[*][COLOR=#009900][B]Q.[/B] Something does not work, what should i do?[/color]
        [COLOR=#FF0000][B]A.[/B][/color] Start with posting your output of server commands "version; meta version; sm version; plugin_print; meta list; sm exts list;sm plugins list"
        and content of the latest file [B]cstrike/addons/sourcemod/logs/errors_<date>.log[/B] in this topic.

[*][COLOR=#009900][B]Q.[/B] Where the stats database is located?[/color]
        [COLOR=#FF0000][B]A.[/B][/color] If you did not configure any custom databases, you gungame stats is located in 
        [B]addons\sourcemod\data\sqlite\sourcemod-local.sq3[/B].

[*][COLOR=#009900][B]Q.[/B] How to convert my ES GG 5.1 winners database file into SM GG database?[/color]
        [COLOR=#FF0000][B]A.[/B][/color] 
            1) Install php (from http://php.net) into [b]C:\programs\php[/b] folder.
            2) Copy [b]C:\programs\php\php.ini-development[/b] into [b]C:\programs\php\php.ini[/b] file.
            3) Uncomment 2 lines in [b]C:\programs\php\php.ini[/b]:
            3.1) [b]extension_dir = "ext"[/b]
            3.2) [b]extension=php_sqlite3.dll[/b]
            4) Run [b]C:\programs\php\php.exe tools\convert_winners_esgg51_to_ggsm.php <input.db> <output.db>[/b]
            where [b]input.db[/b] is your ES GG 5.1 sqlite winners database file, 
            and [b]output.db[/b] is you SM GG  sqlite winners database file, that is usualy located in
            [b]addons\sourcemod\data\sqlite\sourcemod-local.sq3[/b].


[/LIST]
        
[anchor]Issues[/anchor][B]Issues[/B]
----------------------------------------------------

No issues.

[anchor]3-rd party plugins[/anchor][B]3-rd party plugins[/B]
----------------------------------------------------
[LIST]
[*]Winners menu [URL]http://forums.alliedmods.net/showpost.php?p=949442&postcount=255[/URL]
[*]!give [URL]https://forums.alliedmods.net/showpost.php?p=1055706&postcount=701[/URL]
[*]!give with reload button [URL]https://forums.alliedmods.net/showpost.php?p=2227859&postcount=9[/URL]
[*]!buylevel [URL]http://forums.alliedmods.net/showthread.php?t=134264[/URL]
[*]!buylevel [URL]https://forums.alliedmods.net/showpost.php?p=1387759&postcount=2366[/URL]
[*]MVP as level (Peacemaker) [URL]https://forums.alliedmods.net/showpost.php?p=1627823&postcount=3105[/URL]
[*]MVP as level (Sheepdude) [URL]https://forums.alliedmods.net/showpost.php?p=1834974&postcount=3790[/URL]
[/LIST]

[anchor]maps[/anchor][B]My gungame maps[/B]
----------------------------------------------------
[LIST]
[*][URL="http://www.gamebanana.com/maps/154683"][U]gg_xlighty[/U][/URL]
[*][URL="http://www.gamebanana.com/maps/156400"][U]gg_block9[/U][/URL]
[/LIST]

[anchor]download[/anchor][B]Download[/B]
----------------------------------------------------
Links below

And also i've got a github repo here: [url]https://github.com/altexdim/sourcemod-plugin-gungame[/url]

[URL="http://otstrel.ru/forum/css/obmen_opytom/45996-last_updated_sourcemod_plugins.html#post853421"][color=#ff6600][u]My plugins[/u][/color][/URL] | [URL="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=TD6GHUK986RY2&lc=RU&item_name=Altex%2c%20thank%20you%20for%20your%20sourcemod%20plugins&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"][color=#009900][u]Donations via PayPal[/u][/color][/URL]
