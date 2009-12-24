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

Plugins
-------
gungame.smx
    * Main GunGame:SM plugin
        - Depends on gungame_config.smx, gungame_stats.smx
        - Mandatory plugin
        - Provides almost all gungame functionality
        
gungame_afk.smx
    * Afk Management System
        - Depends on gungame_config.smx, gungame.smx
        - Optional plugin
        - Detect afk players, kick them if needed, do not allow level up on afk players
        
gungame_config.smx
    * Config Reader
        - Independent
        - Mandatory plugin
        - Read all config files
        - Can load different configs (*.config.txt, *.equip.txt) depending on map 
            prefixes and map names in configs/gungame/maps.
            gungame.config.txt will be read first before prefix map name.
            Prefix map name will be executed first before map specfic map.
            Then map specifc config files will be loaded.
        
gungame_display_winner.smx
    * Display winner
        - Depends on gungame.smx, gungame_stats.smx
        - Optional plugin
        - When someone wins it shows MOTD window with external URL displaing some info about winner.
        
gungame_logging.smx
    * Logging events
        - Depends on gungame.smx
        - Optional plugin
        - Logs events gg_win, gg_leader, gg_levelup, gg_leveldown, gg_knife_steal, gg_knife_level
                                  
gungame_mapvoting.smx
    * Map voting
        - Depends on gungame.smx
        - Optional plugin
        - Starts the map voting for the next map when someone reaches particular level
          by executing cfg/gungame/gungame.mapvote.cfg
                                  
gungame_stats.smx
    * Stats
        - Depends on gungame.smx, gungame_config.smx
        - Mandatory plugin
        - Displays top10 panel
        - Stores players wins data and top10 data
        - Sets handicap level for the new connected players
                                  
gungame_tk.smx
    * TeamKill Management System
        - Depends on gungame.smx
        - Optional plugin
        - Level down team killer
        
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

    say !level                      - Show your current level and who is winning.
    say !weapons                    - Show the weapon order.
    say !score                      - Show all player current scores.
    say !top10                      - Show the top 10 winners on the server.
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
    1.0.5.6:
        + Added russian translation.
        + Added german translation. Thanks to tObIwAnKeNoBi.
        * Fixed bug:
            Players do not triple level. Fast speed, sound etc - when they get 3 levels.
        * Fixed bug:
            when I have "WarmupStartup" "1" and each team has a player then new round starts with info 
            in chat "[GunGame] Warmup round has not started yet" when should be "[GunGame] Warmup round 
            is in progress". It is ok in next round.
        * Fixed bug:
            plugin require one extra AFK death than set in config file i.e. 
            "AfkDeaths" "2" - requires 3 AFK deaths before an action
        * Fixed bug:
            AFK deaths counter is not cleared after AFK kick (maybe also when it 
            moves to spectators). When you got AFK kick, rejoin and get one more AFK 
            death then plugin kicks instantly no matter what is in "AfkDeaths".
        * Fixed bug:
            AFK action moving to spectators don't work

    1.0.5.5:
        * Fixed bug: With knifepro enabled and the attacker on knife level, they do not steal 
            levels from other players when they knife someone.
    
    1.0.5.4:
        * Fixed bug: 
            There is one little bug. I'm using Turbo mode on my server and when I kill somebody 
            with awp then next weapon is a nade. So, I should get glock, flashbang, smokenade 
            and hegrenade (i set it on config). But I'm getting only glock and nade. I have it 
            all on next spawn but not in the same round I gained new level  . This happens every 
            time to me when I get nade level before round end.

    1.0.5.3:
        * Fixed bug: If WorldspawnSuicide is 0 than player could level up with worldspawn.

        * Refactoring: Restore level on reconnect was moved from handicap and now is independent.
          Added new config variable to enable/disable this function - RestoreLevelOnReconnect.

    1.0.5.2:
        * Fixed:
            [SM] Native "IsPlayerAlive" reported: Client 10 is not in game
            L 12/22/2009 - 15:27:41: [SM] Displaying call stack trace for plugin "gungame.smx": L 12/22/2009 - 15:27:41: [SM]
            [0]  Line 290, E:\Download \sm_gungame-1.0.5.1\addons\sourcemod\scripting\gungame.sp::OnClientDisconnect()
            
    1.0.5.1:
        * Strip weapons from dead players completely rewritten.
          Cpu usage optimization.

        * Weapon to index procedure rewritten from keyvalue to trie array. 
          Cpu usage optimization.
    
    1.0.5.0:
        + Providing "AfkAction" = 0 in gungame.config.txt will disables kicking/moving
            to specs afk players without disabling afk management completely.
        + Added config variable to allow level up after round end - "AllowLevelUpAfterRoundEnd".
        + Added config variable to strip dead players weapons so that their weapons can't 
            be picked up - "StripDeadPlayersWeapon".
        + Timer moved to hint box instead of screen center.
        + Added ticking sound for the last 5 warmup seconds.
        + Added global forward GG_OnWarmupEnd which fire when GG warmup is over.
        * All "play" sounds replaced with EmitSound.
        * All chat texts are moved to translation files.

    1.0.4.1:
        * Fixed bug:
            - its seems like there is a bug in the latest release with the two new cvars. I 
            have the RemoveWeaponAmmo set to 0 and it works for one round and not the next 
            round I have nade set to 2 kills required. 
        + Added handicap mode 3. It's like handicap mode 2 but skipping bots.
            Usefull for dm servers with bots blocking round end.
            
    1.0.4.0:
        * Fixed bug:
            I dont level down at all, when i kill my self with a nade.
            (autofriendlyfire is 1 i think)
        * Fixed bug: 
            When i kill a teammate, kill a enemy and then another enemy with the knife 
            i triple level. But not always. Yet I couldn't figure it out why.
            (maxlevelperround is 2 i think)
        + Added configuration variable for disable RemoveWeaponAmmo of NadeBonus weapon.
        + Added option to reload ammo on player kill.
        + Enabled removing all weapons before giving next level 
            weapon for player if Turbo is enabled.
        
    1.0.3.0:
        + Restore level on player reconnect.
      
    1.0.2.0:
        + There are forwards for logging level up and level down.
          Added logging for lvlup, lvldn, lvlsteal to gungame_logging.sp
        * Fixed:
            L 09/16/2009 - 13:26:45: [SM] Native "GetClientAuthString" reported: Client index 0 is invalid
            L 09/16/2009 - 13:26:45: [SM] Displaying call stack trace for plugin "gungame_logging.smx":
            L 09/16/2009 - 13:26:45: [SM]   [0]  Line 94, gungame_logging.sp::LogEventToGame()
            L 09/16/2009 - 13:26:45: [SM]   [1]  Line 62, gungame_logging.sp::GG_OnLeaderChange()
        * Bugfix for:
            L 10/07/2009 - 00:27:23: [SM] Native "GetClientTeam" reported: Client 1 is not in game
            L 10/07/2009 - 00:27:23: [SM] Displaying call stack trace for plugin "gungame_logging.smx":
            L 10/07/2009 - 00:27:23: [SM]   [0]  Line 99, gungame_logging.sp::LogEventToGame()
            L 10/07/2009 - 00:27:23: [SM]   [1]  Line 64, gungame_logging.sp::GG_OnLeaderChange()
        + Added gg_leader and gg_knife_level events to logger.
          gg_leader event triggered when leader changed.
          gg_knife_level event triggered when player reaches last level.
        * Changed GG_OnClientLevelChange forward prototype. Added "last level"
          param.
        * Bugfix: 
            One BIG bug, which, I think, wasn't mentioned here: gungame 1.0.1.1 
            removes buysites. When it's disabled, it also removes.

    1.0.1.1:
        * Renamed cvar from sm_gungame_css_version to sm_gungamesm_version.
        * Blue color is unreadable. Changed to light blue.
        * Disabled money removement. Removed buyzones instead.
        * Fixed issue: map does not change after gungame winner.
          Update your gungame.games.txt only if you've updated
          your steam engine to the latest version and map
          does not change after somebody win.
        * Fixed warmup end right after round_restart (warmup was 
          ending 1 second before round_restart).
        - Removed CSSDM patch.
        + Added elimination mode. Elimination mode added to ggdm plugin.
          For elimination mode you will need sm_ggdm 1.5.1+
          http://forums.alliedmods.net/showpost.php?p=927227&postcount=27
          You should not update gungame plugin for that, only ggdm.
        * Bug fixed:
            L 07/30/2009 - 06:55:41: [SM] Native "GetClientTeam" reported: Client index 0 is invalid
            L 07/30/2009 - 06:55:41: [SM] Displaying call stack trace for plugin "gungame.smx":
            L 07/30/2009 - 06:55:41: [SM]   [0]  Line 371, gungame/event.sp::_PlayerDeath()
        * Fixed top10 scoreboard.
            !top10 was not working corretly, when someone reaches someone's else place.
            For example player1 is on 8 place with 255 wins, player2 is on place 9
            with 254 wins. Than player 2 wins 2 times, and even so he has 255 wins 
            on top10 list. But in winners he has 256 wins.
        
    1.0.0.1.12:
        * Fixed if VoteLevelLessWeaponCount = 0 then player can not win from the first time.
        * Fixed to change player's level down when self killed with grenade if autofriendlyfire is disabled.
        * Fixed Handicap.
        * Fixed intermission to start right after player has won (no round start if team has won).
        + Added examples to gungame.mapconfig.cfg.
        - Removed mp_chattime modification.
        
    1.0.0.1.11:
        * Fixed top10 update on gungame win (it was not working if players have same wins).
        * Fixed not to give additional grenade if player kills with grenade with ExtraNade on.
    
    1.0.0.1.10:
        + Added motd winner display.
        + Added option to winner display for the custom URL.
        + Added option to give deagle or other weapon instead of glock when on nade level.
        * Fixed NadeBonus to work if turbo is enabled.
      
    1.0.0.1.9:
        * Extended plugin info: added new author and new url.
        + Added external converter for winners db file from es gg5 to gg3.
        + Added option to disable annoying chat messages if multikill enabled.

    1.0.0.1.8:
        * Fixed multiple kills.
        + Added random weapon order option.
        
    1.0.0.1.7:
        + Added option no activate alltalk after player win.
        + Added grenade warmup.
        + Added unlimited nades.
        * Fixed for:
            ==== in sm error log ====
            L 05/24/2009 - 19:48:22: [SM] Native "SetEntData" reported: Entity 9 is invalid
            L 05/24/2009 - 19:48:22: [SM] Displaying call stack trace for plugin "gungame.smx":
            L 05/24/2009 - 19:48:22: [SM]   [0]  Line 305, gungame/event.sp::DelayClearMoney()
            ==== in srv log ====
            L 05/24/2009 - 19:48:22: World triggered "Round_Start"
            L 05/24/2009 - 19:48:22: World triggered "Round_Start"
            L 05/24/2009 - 19:48:22: " -=XXXX=-<158><STEAM_0:0:XXXX><>" disconnected (reason "Disconnect by user.")
    
    1.0.0.1.6:
        * Fixed top left winner message size for long nicknames.
        + Added handycap option to give the lowest level to new connected player.
        
    1.0.0.1.5:
        * Fixed money remove on player kill.
        * Colorized winner message.
        + Added sounds on last/nade level.
        * Colorized nick names in chat by red/blue color.
        * Fixed levels freezing on warmup if warmupreset is set.
        * Fixed not to give weapon on warmup if warmupknifeonly is set in turbo mode.
        * Fixed automatic switching to new given weapon in turbo mode.
        * Fixed mp_chattime time.
        + Added "!score" button to "!level" panel.
    
    1.0.0.1.4:
        * Reverted changes about warmup. Need more think about.
    
    1.0.0.1.3:
        * Added exit button "1" to "!score" menu
        * Code improved. Separated business logic about calculating leader from
          showing messages to chat. Added UTIL_RecalculateLeader and it is called from 
          UTIL_ChangeLevel. Added PrintLeaderToChat. 
        * Fixed recalculating leader on TK (GG_RemoveALevel)
        * Fixed saving to top10.txt. The issue was that only 9 players was in !top10. 10-th player
          was never loaded, so on map end his rank was rewritten by the winner.
        * Fixed warmup end right after round_restart (warmup was ending 1 second before round_restart).
        
    1.0.0.1.2:
        * Fixed bug with no message about tied with the leader when leader on level 2 (first level gained)
          Fixed FindLeader to return CLIENT (it was returning LEVEL not CLIENT). (!!!)
        * Fixed bug with no message about leaders if stealing level
        * ChangeLevel and FindLeader should come together, because
          each ChangeLevel can change and the CurrentLeader.
        * Fixed CurrentLeader calculation on stealing level
        * Fixed behaviour if multiple leaders found on intermission
    
    1.0.0.1.1:
        * Version changed :)
        * Write leaders to chat, not in hint box
        * Disable second line on spawn to chat if custom kill per level = 1 (annoying line)
        - Disable "congratulation" line (there is a sound)
        + Added line "is leading on level X" after leader gained next level
        * Fixed possible bug for random winner sound
        * Redesigned all menus where it is possible to change "0. Exit" to "1. Exit".
          It's pretty much ergonomic button.
        * Fixed gg_rebuild to recreate top10panel. Now you do not need to wait for map end
          to see recreated top10 panel.
        * Fixed HasRank value after SaveRank. Now you do not need to restart plugin 
          if there was no winners yet.
        * Redesigned "!level" panel.
    
    1.0.0.1 unofficial release 2:
        * Fixed gg_import
        * Redesigned join message panel

    1.0.0.1 unofficial release 1:
        + Added option to disable calculate winner on intermission
        + Added option to level up attacker even if victim on first level
        + Added option to level down victim even if attacker is on grenade level
        * Fixed player stats saving on map end
        + Start map voting on level provided in config
        + Added random winner sound
        * Fixed bug win BotCanWin
        * Fixed JoinMessage config variable
        * Commented hookusermessage due to bug (server crash on plugin unload)
          So calculate winner on intermission is disabled.

    1.0.0.1:
        * Original Liam's version http://forums.alliedmods.net/showthread.php?t=80609

TODO
----
    ----====----==== High priority list ----====----====

    * Move all panel texts to translation files.

    * gungame_stats is not optional because gungame_stats is required to run gungame. Can you please 
        fix it so it is optional. I believe only the gungame levelpanel depends on it for 'wins'.

        It would be nice if handicap could be moved out of gungame_stats because you don't really 
        need stats to run the handicap. I just do not want to run gungame_stats at all because I 
        use hlstatsx. The extra processing for top10 etc is not necessary.    

    ----====----==== Normal priority list ----====----====

    + Feature request:
        I also have an idea about round start message like "You are on level 1 :: glock". What do you 
        think about moving it to the hint box (like warmup timer) and add information about leader 
        level like "Leader level 24 :: awp"?
    + Feature request:
        - configurable warmup weapon by cvar

        For example I've wrote very simple plugin which randomize warmup weapon in ES GG5 
        (by changing gg_warmup_weapon value). You should add such cvar as well, it's useful. 
        
        If enabled weapon reloading on kill then reload warmup weapon.
    + Add an option to level down not to one level, but to some points, calculating depends on how 
        much points does exists on current and previous level. 
        Example:
        was - level 4, points 2 (miltikill 4)
        after knifed - level 3, point 1 (multikill 2)
        levelNew = levelOld - 1, 
        pointsNew = floor((poinsOld/miltikillOld) * multikillNew)
    
    * Think about this feature request:
        I also would like to request that plugin could save level kills when level down. 
        For example when there are 3 kill levels and you have already killed 2 and somebody 
        knifes you. Instead of starting from 0 kills on previous level you could continue 
        from 2 kill. Many people on my server are constantly complaining one this issue.

        My opinion is it's not a good idea, because it you loose a level you are loosing a 
        level, not just some points. And actualy some levels can be 2 points, for example, 
        and some levels can be just 1 point, and some 5 points, so how plugin should 
        calculate what exactly points it should save?
    + Feature request:
        Is it possible to enable friendly fire earlier than on nade level
    + Feature request:
        If you kill yourself or a teammate you loose one level. I want set this 
        to loose 2 levels, or 3, or...
    + Implement gg_handicap_update like in esgg5.
    + Implement !buylevel.
    * These function arent working:
        - Triplelevelbonus
        - AFK manager (moving afk-s to spec)
    * Is there a way to put more nades on he level, like this one 
      for GunGame5? http://forums.gungame5.com/viewtopic.php?f=17&t=265        
    * Feature request:
        1) I want to run a random weapon order but *always* have knife 
        and nade as the last two weapons. When I turn random weapon order 
        on it mixes knife and nade into the mix. Is there a way to make 
        knife and nade the last two weapons?
        Add something like configurable random weapons groups.
    * AfkDeaths does not reset sometimes.
      Redone afk managenemt not to check weapon_fire every shot.
    * Make removement buyzones on/off. So once gg is enabled than buyzones are
      disabled, and when gg is disabled buyzones are enabled.
      Maybe instead of removement buyzones just disable it to players on
      spawn and when gg swithces enabled/disabled.
    + Add winners menu - https://forums.alliedmods.net/showpost.php?p=949442&postcount=255
    
    ----====----==== High severity list ----====----====
    
    * Enable hookusermessage after fix for https://bugs.alliedmods.net/show_bug.cgi?id=3817
    + Add sqlite and mysql support for top players stats
    * Improve random number generation algorithm after fix for https://bugs.alliedmods.net/show_bug.cgi?id=3831
    
    ----====----==== Low priority list ----====----====
    
    * [UNAPPROVED] Sometimes "!scores" shows wrong levels if it was many knife battles.
      I can not figure out algorythm to reproduce this bug. Maybe all is ok.
    * [UNAPPROVED] Bug report:
        2) I also like to require 2 kills per round. This works fine 
        but with Knife Pro turned on, it still takes two knife kills to 
        level up where it should only take one knife kill. Is there an 
        option for this?
    * [UNAPPROVED] Bug report:
        I found two bugs.
        - First, if the player has hegrenade, he's the last man standing in his team and 
          he suicides, he doesn't loose his level.
        - Second (maybe it's some problem w/ server), quite often when somebody makes a 
          knivekill, server just shuts down and i have to restart it.
        On the 1.0.0.1.12v the 2nd problem hasn't appeared, so I'm downgrading.
    * Bug report:
        [UNAPPROVED] I dont think that de Handicap works as it should :/
        On my server i set it to "1" that means it should give the AVG level, but.
        If a players joins the server he/she always got the first weapon no matter
        what the AVG level is., but after he recconnect he get's the AVG level.
        So in shot newly connected players aren't getting the avg level.
    * Fix:
        L 09/16/2009 - 13:49:26: [SM] Native "SetEntData" reported: Offset 0 is invalid
        L 09/16/2009 - 13:49:26: [SM] Displaying call stack trace for plugin "gungame.smx":
        L 09/16/2009 - 13:49:26: [SM]   [0]  Line 193, gungame/util.sp::UTIL_SetClientGodMode()
        L 09/16/2009 - 13:49:26: [SM]   [1]  Line 465, gungame/event.sp::_PlayerDeath()

        L 09/16/2009 - 13:49:36: [SM] Native "SetEntData" reported: Offset 0 is invalid
        L 09/16/2009 - 13:49:36: [SM] Displaying call stack trace for plugin "gungame.smx":
        L 09/16/2009 - 13:49:36: [SM]   [0]  Line 193, gungame/util.sp::UTIL_SetClientGodMode()
        L 09/16/2009 - 13:49:36: [SM]   [1]  Line 857, gungame/event.sp::RemoveBonus()
      Comment: Realy dont understand how it is possible. Is it knife throw plugin installed?
      Think about what to do if Killer == 0.
      I dont know how it is possible.
    * Fix
        L 08/31/2009 - 21:17:31: [SM] Native "UnhookEvent" reported: Game event "hostage_killed" has no active hook
        L 08/31/2009 - 21:17:31: [SM] Displaying call stack trace for plugin "gungame.smx":
        L 08/31/2009 - 21:17:31: [SM]   [0]  Line 399, gungame.sp::GG_OnShutdown()
      I dont know how it is possible.
    * These function arent working:
        - [UNAPPROVED] Handicap (givin neewly connected player teh avg level)
            So people are playing on server let's say there are 6 players 
            and all of them are on the same level ( just to keep simple 
            the explain), let say level 10.
            A 7th player joins the game.
            He should start at level 10 after joining T or CT ,
            BUT!!!! he starts at level 1 instead.
            He wil only get the avg. level by using the "retry" 
            reconnect consoloe command. After reconnectig the plugin 
            works fine and the player get's the avg. level.

            So to keep it simple, neewly connected players don't get 
            the avg or min level, only after recconecting.
    * When bot just added than it is assigning to team and spawning 
      before it "entered the game". So he did not receive knife
      and then gungame plugin add him knife. But then he disconnects
      and respawning (after entren the game) but there is dropped
      knife.

Issues
-------
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
        a) https://forums.alliedmods.net/showpost.php?p=1009813&postcount=389    
 
