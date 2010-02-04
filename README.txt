[COLOR=#ff6600][SIZE=5][B]GunGame[/B][/SIZE][/COLOR]

[b]Table of contents[/b]
----------------------------------------------------
[list]
    [*] [goanchor=Description]Description[/goanchor]
    [*] [goanchor=Commands and Cvars]Commands and Cvars[/goanchor]
    [*] [goanchor=Requirements]Requirements[/goanchor]
    [*] [goanchor=Installation]Installation[/goanchor]
    [*] [goanchor=Plugins]Plugins[/goanchor]
    [*] [goanchor=Credits]Credits[/goanchor]
    [*] [goanchor=Changelog]Changelog[/goanchor]
    [*] [goanchor=TODO]TODO[/goanchor]
    [*] [goanchor=Issues]Issues[/goanchor]
    [*] [goanchor=3-rd party plugins]3-rd party plugins[/goanchor]
[/list]

[anchor]Description[/anchor][b]Description[/b]
----------------------------------------------------
    [indent]GunGame:SM is the gameplay plugin that makes you to
    act with various guns and not only with your favorite
    one. On spawn you get one weapon. You should kill
    enemy with the current weapon to get next weapon.
    You should kill enemies with all the weapons to win the game.

    http://forums.alliedmods.net/showthread.php?t=93977

    Complementary plugins:
    [list]
        [*] deathmatch, elimination, spawn protection
            [b]sm_ggdm[/b] - http://forums.alliedmods.net/showthread.php?t=103242
        [*] noblock
            [b]sm_noblock[/b] - http://forums.alliedmods.net/showthread.php?t=91617
    [/list]
    [/indent]
        
[b]Commands and Cvars[/b][anchor]Commands and Cvars[/anchor]
----------------------------------------------------
[list]
    [*] [b]sm_gungamesm_version[/b]            - Gungame version.
    [*] [b]gungame_enabled[/b]                 - Display if gungame is enabled or disabled.
[/list]

[list]
    [*] [b]gg_version[/b]                      - Show gungame version information.
    [*] [b]gg_status[/b]                       - Show state of the current game.
    [*] [b]gg_restart[/b]                      - Restarts the whole game from the beginning.
    [*] [b]gg_enable[/b]                       - Turn on gungame and restart the game.
    [*] [b]gg_disable[/b]                      - Turn off gungame and restart the game.
    [*] [b]gg_rebuild[/b]                      - Rebuilds the top10 rank from the player data information.
    [*] [b]gg_import[/b]                       - Imports the winners file from es es gungame3. File must be in data/gungame/es_gg_winners_db.txt.
                                                 You can convert winners db file from es gungame5 to gungame3 - use tools/convert_winners_esgg_5to3.py.
    [*] [b]gg_reset[/b]                        - Reset all gungame stats. (only if sql stats enabled)
    [*] [b]gg_importdb[/b]                     - Imports the winners from gungame players data file into database. (only if sql stats enabled)
[/list]

[list]
    [*] [b]say !level[/b]                      - Show your current level and who is winning.
    [*] [b]say !weapons[/b]                    - Show the weapon order.
    [*] [b]say !score[/b]                      - Show all player current scores.
    [*] [b]say !top[/b]                        - Show the top winners on the server.
    [*] [b]say !leader[/b]                     - Show current leaders.
    [*] [b]say !rank[/b]                       - Show your current place in stats. (only if sql stats enabled)
    [*] [b]say !rules[/b]                      - Show the rules and how to play.
[/list]

[anchor]Requirements[/anchor][b]Requirements[/b]
----------------------------------------------------
[list]
    [*] Counter-Strike: Source
    [*] SourceMod 1.2.0+
[/list]

[anchor]Installation[/anchor][b]Installation[/b]
----------------------------------------------------
[list]
    [*] Install Metamod:Source.
    [*] Install SourceMod.
    [*] Upload the addons, sound, and cfg into your cstrike folder for CS:Source
    [*] Config gungame.config.txt and gungame.equip.txt to your liking in cfg/gungame/
    [*] Restart your server.
[/list]

[anchor]Plugins[/anchor][b]Plugins[/b]
----------------------------------------------------
[list]
    [*] gungame.smx - Main GunGame:SM plugin
    [list]
        [*] Depends on gungame_config.smx, gungame_stats.smx (optional)
        [*] Mandatory plugin
        [*] Provides almost all gungame functionality
    [/list]
            
    [*] gungame_config.smx - Config Reader
    [list]
        [*] No dependencies
        [*] Mandatory plugin
        [*] Read all config files
        [*] Can load different configs (*.config.txt, *.equip.txt) depending on map 
            prefixes and map names in configs/gungame/maps.
            gungame.config.txt will be read first before prefix map name.
            Prefix map name will be executed first before map specfic map.
            Then map specifc config files will be loaded.
    [/list]
                
    [*] gungame_stats.smx - Stats
    [list]
        [*] Depends on gungame.smx, gungame_config.smx
        [*] Optional plugin
        [*] Displays top10 panel
        [*] Stores players wins data and top10 data
        [*] Sets handicap level for the new connected players
    [/list]
                
    [*] gungame_afk.smx - Afk Management System
    [list]
        [*] Depends on gungame_config.smx, gungame.smx
        [*] Optional plugin
        [*] Detect afk players, kick them if needed, do not allow level up on afk players
    [/list]
            
    [*] gungame_mapvoting.smx - Map voting
    [list]
        [*] Depends on gungame.smx
        [*] Optional plugin
        [*] Starts the map voting for the next map when someone reaches particular level
              by executing cfg/gungame/gungame.mapvote.cfg
    [/list]
                                      
    [*] gungame_logging.smx - Logging events
    [list]
        [*] Depends on gungame.smx
        [*] Optional plugin
        [*] Logs events: gg_win, gg_leader, gg_levelup, gg_leveldown, gg_knife_steal, 
              gg_knife_level, gg_triple_level, gg_last_level
    [/list]
                                      
    [*] gungame_tk.smx - TeamKill Management System
    [list]
        [*] Depends on gungame.smx, gungame_config.smx
        [*] Optional plugin
        [*] Level down team killer
    [/list]
            
    [*] gungame_display_winner.smx - Display winner
    [list]
        [*] Depends on gungame.smx, gungame_stats.smx, gungame_config.smx
        [*] Optional plugin
        [*] When someone wins it shows MOTD window with external URL displaing some info 
                about winner.
    [/list]
[/list]
            
[anchor]Credits[/anchor][b]Credits[/b]
----------------------------------------------------
[list]
    [*] Thanks to VoGon for the translation to portuguese.
    [*] Thanks to tObIwAnKeNoBi for german translation.
    [*] Thanks to exvel for sourcemod library Colors 1.0.2
      http://forums.alliedmods.net/showthread.php?t=96831
    [*] Thanks to bl4nk for GunGame Display Winner plugin.
    [*] Thanks to Liam for GunGame:SM till version 1.0.0.1
      http://forums.alliedmods.net/showthread.php?t=80609
    [*] Original Idea and concepts of Gun Game was made by cagemonkey
      http://www.cagemonkey.org
    [*] Original SourceMod code by Teame06
[/list]        

[anchor]Changelog[/anchor][b]Changelog[/b]
----------------------------------------------------
    [indent]For full changelog see docs/CHANGELOG.txt[/indent]

[anchor]TODO[/anchor][b]TODO[/b]
----------------------------------------------------
    [indent]For full todo list see docs/TODO.txt[/indent]

[anchor]Issues[/anchor][b]Issues[/b]
----------------------------------------------------
[list]
    [*] [b]Q.[/b] My server crashes right after someone wins the map.
        [b]A.[/b] Update your server binaries OR Update your gamedata/gungame.games.txt:
            Replace:
                "EndMultiplayerGame"
                {
                    "windows"       "102"
                    "linux"     "103"
                }
            to:
                "EndMultiplayerGame"
                {
                    "windows"       "101"
                    "linux"     "102"
                }

    [*] [b]Q.[/b] My server does not change map after someone wins the map.
        [b]A.[/b] Update your gamedata/gungame.games.txt from latest gungame release.

    [*] [b]Q.[/b] How to enable/disable gungame depending on map prefixes (aka buyzone issue):
        [b]A.[/b] http://forums.alliedmods.net/showpost.php?p=1009813&postcount=389    

    [*] [b]Q.[/b] How to switch stats database from sqlite to mysql 
        [b]A.[/b] http://forums.alliedmods.net/showpost.php?p=1075809&postcount=865        
[/list]
        
[anchor]3-rd party plugins[/anchor][b]3-rd party plugins[/b]
----------------------------------------------------
[list]
    [*] Winners menu:
        http://forums.alliedmods.net/showpost.php?p=949442&postcount=255
    [*] Advanced stats:
        http://forums.alliedmods.net/showpost.php?p=1036934&postcount=594
    [*] say !give
        https://forums.alliedmods.net/showpost.php?p=1055706&postcount=701
[/list]

