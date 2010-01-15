Description
-----------
    GunGame:SM is the gameplay plugin that makes you to
    act with various guns and not only with your favorite
    one. On spawn you get one weapon. You should kill
    enemy with the current weapon to get next weapon.
    You should kill enemies with all the weapons to win the game.

    http://forums.alliedmods.net/showthread.php?t=93977

    Complementary plugins:
        - deathmatch, elimination, spawn protection
            sm_ggdm - http://forums.alliedmods.net/showthread.php?t=103242
        - noblock
            sm_noblock - http://forums.alliedmods.net/showthread.php?t=91617
        
Commands and Cvars
------------------
    sm_gungamesm_version            - Gungame version.
    gungame_enabled                 - Display if gungame is enabled or disabled.
    sm_gungame_display_winner_url   - URL to display in MOTD window for gungame winner.

    gg_version                      - Show gungame version information.
    gg_status                       - Show state of the current game.
    gg_restart                      - Restarts the whole game from the beginning.
    gg_enable                       - Turn on gungame and restart the game.
    gg_disable                      - Turn off gungame and restart the game.
    gg_rebuild                      - Rebuilds the top10 rank from the player data information.
    gg_import                       - Imports the winners file from es es gungame3. File must be in data/gungame/es_gg_winners_db.txt.
                                      You can convert winners db file from es gungame5 to gungame3 - use tools/convert_winners_esgg_5to3.py.
    gg_reset                        - Reset all gungame stats. (only if sql stats enabled)
    gg_importdb                     - Imports the winners from gungame players data file into database. (only if sql stats enabled)

    say !level                      - Show your current level and who is winning.
    say !weapons                    - Show the weapon order.
    say !score                      - Show all player current scores.
    say !top                        - Show the top winners on the server.
    say !leader                     - Show current leaders.
    say !rank                       - Show your current place in stats. (only if sql stats enabled)
    say !rules                      - Show the rules and how to play.

Requirements
------------
    Counter-Strike: Source
    SourceMod 1.2.0+

Installation
------------
    * Install Metamod:Source.
    * Install SourceMod.
    * Upload the addons, sound, and cfg into your cstrike folder for CS:Source
    * Config gungame.config.txt and gungame.equip.txt to your liking in cfg/gungame/
    * Restart your server.

Plugins
-------
    gungame.smx
        * Main GunGame:SM plugin
            - Depends on gungame_config.smx, gungame_stats.smx (optional)
            - Mandatory plugin
            - Provides almost all gungame functionality
            
    gungame_config.smx
        * Config Reader
            - No dependencies
            - Mandatory plugin
            - Read all config files
            - Can load different configs (*.config.txt, *.equip.txt) depending on map 
                prefixes and map names in configs/gungame/maps.
                gungame.config.txt will be read first before prefix map name.
                Prefix map name will be executed first before map specfic map.
                Then map specifc config files will be loaded.
                
    gungame_stats.smx
        * Stats
            - Depends on gungame.smx, gungame_config.smx
            - Optional plugin
            - Displays top10 panel
            - Stores players wins data and top10 data
            - Sets handicap level for the new connected players
                
    gungame_afk.smx
        * Afk Management System
            - Depends on gungame_config.smx, gungame.smx
            - Optional plugin
            - Detect afk players, kick them if needed, do not allow level up on afk players
            
    gungame_mapvoting.smx
        * Map voting
            - Depends on gungame.smx
            - Optional plugin
            - Starts the map voting for the next map when someone reaches particular level
              by executing cfg/gungame/gungame.mapvote.cfg
                                      
    gungame_logging.smx
        * Logging events
            - Depends on gungame.smx
            - Optional plugin
            - Logs events: gg_win, gg_leader, gg_levelup, gg_leveldown, gg_knife_steal, 
              gg_knife_level, gg_triple_level, gg_last_level
                                      
    gungame_tk.smx
        * TeamKill Management System
            - Depends on gungame.smx
            - Optional plugin
            - Level down team killer
            
    gungame_display_winner.smx
        * Display winner
            - Depends on gungame.smx, gungame_stats.smx
            - Optional plugin
            - When someone wins it shows MOTD window with external URL displaing some info 
                about winner.
            
Credits
-------
    * Thanks to tObIwAnKeNoBi for german translation.
    * Thanks to exvel for sourcemod library Colors 1.0.2
      http://forums.alliedmods.net/showthread.php?t=96831
    * Thanks to bl4nk for GunGame Display Winner plugin.
    * Thanks to Liam for GunGame:SM till version 1.0.0.1
      http://forums.alliedmods.net/showthread.php?t=80609
    * Original Idea and concepts of Gun Game was made by cagemonkey
      http://www.cagemonkey.org
    * Original SourceMod code by Teame06

Changelog
---------
    * For full changelog see docs/CHANGELOG.txt
        
TODO
----
    * For full todo list see docs/TODO.txt

Issues
------
    1) My server crashes right after someone wins the map.
        a) Update your server binaries.
        b) OR Update your gamedata/gungame.games.txt:
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

    2) My server does not change map after someone wins the map.
        a) Update your gamedata/gungame.games.txt from latest gungame release.

    3) How to enable/disable gungame depending on map prefixes (aka buyzone issue):
        a) http://forums.alliedmods.net/showpost.php?p=1009813&postcount=389    

3-rd party plugins
------------------
    * Winners menu:
        http://forums.alliedmods.net/showpost.php?p=949442&postcount=255
    * Advanced stats:
        http://forums.alliedmods.net/showpost.php?p=1036934&postcount=594
    * say !give
        https://forums.alliedmods.net/showpost.php?p=1055706&postcount=701

