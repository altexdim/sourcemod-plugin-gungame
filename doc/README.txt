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
[*] [goanchor=FAQ]FAQ[/goanchor]
[*] [goanchor=Issues]Issues (updated on 15 Apr 2011)[/goanchor]
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
[*] Counter-Strike: Source
[*] SourceMod 1.2.0+
[*] (Optional, not required by default) SDK Hooks 1.3 or later (https://forums.alliedmods.net/showthread.php?t=106748)
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
[*] Config "gungame.config.txt" and "gungame.equip.txt" to your liking in "cfg/gungame/"
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
[*] Depends on gungame.smx
[*] Optional plugin
[*] Starts the map voting for the next map when someone reaches particular level
              by executing cfg/gungame/gungame.mapvote.cfg
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

[/LIST]
            
[anchor]Credits[/anchor][B]Credits[/B]
----------------------------------------------------
[LIST]
[*] Thanks to Xilver266 for spanish translation.
[*] Thanks to Ted Theodore Logan & xDr.HaaaaaaaXx from http://www.war3source.com/
    for cool visual effect from "War3Source - Addon - Display Particles on Level Up" plugin version 1.1
    used in multi level bonus effect in gungame plugin.
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
----------------------------------------------------[INDENT]For full todo list see doc/TODO.txt[/INDENT]

[anchor]FAQ[/anchor][B]FAQ[/B]
----------------------------------------------------

[LIST]
[*][B]Q.[/B] I want weapon to be changed after leveling up in the same round and not in the next round.
         [B]A.[/B] "TurboMode" "1" in gungame.config.txt.
[*] [B]Q.[/B] How to enable/disable gungame depending on map prefixes (aka buyzone issue):
        [B]A.[/B] [URL]http://forums.alliedmods.net/showpost.php?p=1009813&postcount=389[/URL]
[*] [B]Q.[/B] How to switch stats database from sqlite to mysql 
        [B]A.[/B] [URL]http://forums.alliedmods.net/showpost.php?p=1075809&postcount=865[/URL]
[/LIST]
        
[anchor]Issues[/anchor][B]Issues[/B]
----------------------------------------------------

[LIST]
[*][B]Q.[/B] (15 Apr 2011) Server crashes after update.
         [B]A.[/B] Install mmsource-1.8.6-hg760, sourcemod-1.3.7-hg3126, sdkhooks-2.0 (only if you are using sdkhooks), disable or update stripper:source.
[*][B]Q.[/B] Sound does not work.
         [B]A.[/B] Try to change all slashes ("/") in sound files paths to double-backslashes ("\\") 
         in gungame.config.txt and restart server and client.
[*][B]Q.[/B] Sound still does not work.
         [B]A.[/B] Good article for beginning http://developer.valvesoftware.com/wiki/Pure_Servers
         Post your question with the following info: output of the command on server "sv_pure",
         output of the command on client "sv_pure" or content of the file "cstrike/pure_server_whitelist.txt",
         output of the command "sv_downloadurl" on server or client.
[*][B]Q.[/B] Weapons desapearing on level up and player spawn.
         [B]A.[/B] If you are using DeathMatch:SM then set [b]sm_ggdm_removeweapons "0"[/b] in [b]server.cfg[/b] and
         set [b]"StripDeadPlayersWeapon" "1"[/b] in [b]gungame.config.txt[/b]. GunGame:SM weapon stripper is much cpu effective
         then DeathMatch:SM weapon stripper, don't use DeathMatch:SM weapon stripper with GunGame:SM, it was designed for non GunGame servers.
[*][B]Q.[/B] Something does not work, what should i do?
        [B]A.[/B] Start with posting your output of server commands "plugin_print; meta list; sm plugins list"
        and content of the latest file [B]cstrike/addons/sourcemod/logs/errors_<date>.log[/B] in this topic.
[/LIST]
        
[anchor]3-rd party plugins[/anchor][B]3-rd party plugins[/B]
----------------------------------------------------
[LIST]
[*]Winners menu [URL]http://forums.alliedmods.net/showpost.php?p=949442&postcount=255[/URL]
[*]!give [URL]https://forums.alliedmods.net/showpost.php?p=1055706&postcount=701[/URL]
[*]!buylevel [URL]http://forums.alliedmods.net/showthread.php?t=134264[/URL]
[*]!buylevel [URL]https://forums.alliedmods.net/showpost.php?p=1387759&postcount=2366[/URL]
[*]MVP as level [URL]https://forums.alliedmods.net/showpost.php?p=1627823&postcount=3105[/URL]
[/LIST]

[anchor]maps[/anchor][B]My gungame maps[/B]
----------------------------------------------------
[LIST]
[*][URL="http://www.gamebanana.com/maps/154683"][U]gg_xlighty[/U][/URL]
[/LIST]

[anchor]download[/anchor][B]Download[/B]
----------------------------------------------------
Links below
