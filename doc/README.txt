[COLOR=#ff6600][SIZE=5][B]GunGame[/B][/SIZE][/COLOR]

[B]Table of contents[/B]
----------------------------------------------------
[LIST]
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
[/LIST]

[anchor]Description[/anchor][B]Description[/B]
----------------------------------------------------[INDENT]GunGame:SM is the gameplay plugin that makes you to
    act with various guns and not only with your favorite
    one. On spawn you get one weapon. You should kill
    enemy with the current weapon to get next weapon.
    You should kill enemies with all the weapons to win the game.

    [URL]http://forums.alliedmods.net/showthread.php?t=93977[/URL]

    Complementary plugins:
[LIST]
[*] deathmatch, elimination, spawn protection
            [B]sm_ggdm[/B] - [URL]http://forums.alliedmods.net/showthread.php?t=103242[/URL]
[*] noblock
            [B]sm_noblock[/B] - [URL]http://forums.alliedmods.net/showthread.php?t=91617[/URL]
[/LIST]
    [/INDENT][B]Commands and Cvars[/B][anchor]Commands and Cvars[/anchor]
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
[*] Counter-Strike: Source
[*] SourceMod 1.2.0+
[*] (Optional, not required by default) SDK Hooks 1.3 (Updated 2010-05-12) or later (https://forums.alliedmods.net/showthread.php?t=106748)
You need SDK Hooks if you want to set "BlockWeaponSwitchIfKnife" "1"
To enable this option you need to uncomment "USE_SDK_HOOKS" define in gungame_const.inc and recompile plugin.
[/LIST]

[anchor]Installation[/anchor][B]Installation[/B]
----------------------------------------------------
[LIST]
[*] Install Metamod:Source.
[*] Install SourceMod.
[*] (Optional, not required by default) Install SDK Hooks.
[*] Upload the addons, sound, and cfg into your cstrike folder for CS:Source
[*] Config gungame.config.txt and gungame.equip.txt to your liking in cfg/gungame/
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
[*] Depends on gungame.smx
[*] Optional plugin
[*] Starts the map voting for the next map when someone reaches particular level
              by executing cfg/gungame/gungame.mapvote.cfg
[/LIST]
 
[*] gungame_logging.smx - Logging events
[LIST]
[*] Depends on gungame.smx
[*] Optional plugin
[*] Logs events: gg_win, gg_leader, gg_levelup, gg_leveldown, gg_knife_steal, 
              gg_knife_level, gg_triple_level, gg_last_level
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
 
[/LIST]
            
[anchor]Credits[/anchor][B]Credits[/B]
----------------------------------------------------
[LIST]
[*] Thanks to VoGon for the translation to portuguese.
[*] Thanks to tObIwAnKeNoBi for german translation.
[*] Thanks to exvel for sourcemod library Colors 1.0.2
      [URL]http://forums.alliedmods.net/showthread.php?t=96831[/URL]
[*] Thanks to bl4nk for GunGame Display Winner plugin.
[*] Thanks to Liam for GunGame:SM till version 1.0.0.1
      [URL]http://forums.alliedmods.net/showthread.php?t=80609[/URL]
[*] Original Idea and concepts of Gun Game was made by cagemonkey
      [URL]http://www.cagemonkey.org[/URL]
[*] Original SourceMod code by Teame06
[/LIST]

[anchor]Changelog[/anchor][B]Changelog[/B]
----------------------------------------------------[INDENT]For full changelog see doc/CHANGELOG.txt[/INDENT][anchor]TODO[/anchor][B]TODO[/B]
----------------------------------------------------[INDENT]For full todo list see doc/TODO.txt[/INDENT][anchor]Issues[/anchor][B]Issues[/B]
----------------------------------------------------

[LIST]
[*][B]Q.[/B] Plugin does not change map or crashing server after latest css update?
         [B]A.[/B] Update your gungame.games.txt attached to this post.
         Update server binaries and update gungame plugin to the latest version.
[*][B]Q.[/B] Plugin does not work after latest css update?
         [B]A.[/B] Update your gungame.games.txt attached to this post.
[*][B]Q.[/B] Sounds does not work after css update in june 2010?
         [B]A.[/B] If you are running css server on windows platform, then you need to change paths to sound files: 
         replace slashes "/" with double backslashes "\\". And of course don't forget to restore your pure_server_whitelist.txt and sv_pure 1 in config.
[*] [B]Q.[/B] How to enable/disable gungame depending on map prefixes (aka buyzone issue):
        [B]A.[/B] [URL]http://forums.alliedmods.net/showpost.php?p=1009813&postcount=389[/URL]
[*] [B]Q.[/B] How to switch stats database from sqlite to mysql 
        [B]A.[/B] [URL]http://forums.alliedmods.net/showpost.php?p=1075809&postcount=865[/URL]
[/LIST]
        
[anchor]3-rd party plugins[/anchor][B]3-rd party plugins[/B]
----------------------------------------------------
[LIST]
[*] Winners menu:
        [URL]http://forums.alliedmods.net/showpost.php?p=949442&postcount=255[/URL]
[*] Advanced stats:
        [URL]http://forums.alliedmods.net/showpost.php?p=1036934&postcount=594[/URL]
[*] say !give
        [URL]https://forums.alliedmods.net/showpost.php?p=1055706&postcount=701[/URL]
[/LIST]