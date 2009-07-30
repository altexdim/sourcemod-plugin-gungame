Description
-----------
    GunGame:SM is the gameplay plugin that makes you to
    act with various guns and not only with your favorite
    one. You should kill enemy with the current weapon to
    get next weapon. You should kill enemies with all the
    weapons to win the game.

    http://forums.alliedmods.net/showthread.php?t=93977

    For deathmatch mode you will need sm_ggdm 1.4+ plugin
    http://forums.alliedmods.net/showthread.php?t=87198

Commands and Cvars
------------------
    sm_gungame_css_version          - Gungame version.
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
    SourceMod 1.2.0    

Installation
------------
    * Install Metamod:Source.
    * Install SourceMod.
    * Upload the addons, sound, and cfg into your cstrike folder for CS:Source
    * Config gungame.config.txt and gungame.equip.txt to your liking in cfg/gungame/
    * Restart your server.

Credits
-------
    * Thanks to bl4nk for GunGame Display Winner plugin.
    * Thanks to Liam for GunGame:SM till version 1.0.0.1
      http://forums.alliedmods.net/showthread.php?t=80609
    * Original Idea and concepts of Gun Game was made by cagemonkey
      http://www.cagemonkey.org
    * Original SourceMod code by Teame06

Changelog
---------
        * Blue color is unreadable. Changed to light blue.
        * Disabled money removement. Removed buyzones instead.
        
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

TODO
----
    * Enable hookusermessage after fix for https://bugs.alliedmods.net/show_bug.cgi?id=3817
    + Add sqlite and mysql support for top players stats
    * Improve random number generation algorithm after fix for https://bugs.alliedmods.net/show_bug.cgi?id=3831
    * Fix warmup end right after round_restart (warmup is ending 1 second before round_restart).
    * Sometimes "!scores" shows wrong levels if it was many knife battles.
      I can not figure out algorythm to reproduce this bug. Maybe all is ok.
    + Add option to reload ammo on player kill.
    * Check what is IsDmActive for.
    + Implement gg_handicap_update like in esgg5.
    + Implement !give.
      Is it realy needed?
    + Implement !buylevel.
      If implement this, it should be disable money removement and it is 
      needed to remove buyzones instead.
    + Save levels on disconnect and restore on reconnect like in esgg5.
      Will be using tries for static cashe. Keys are steam_ids and values are
      levels integers.
    * Bug report:
        I dont think that de Handicap works as it should :/
        On my server i set it to "1" that means it should give the AVG level, but.
        If a players joins the server he/she always got the first weapon no matter
        what the AVG level is., but after he recconnect he get's the AVG level.
        So in shot newly connected players aren't getting the avg level.
    + Feature requst:
        the problem im having is when someone dies their gun drops
        and someone else can pick it up and use it. i dont want that.
        i want the gun to disappear or disable people from picking it up.
        So add option to allow weapon removement on player death, or allow to
        set IsDmActive from config.
    * Move handicap code from gungame_stats.sp to gungame.sp.
    * Rename version variable
    * These function arent working:
        - Handicap (givin neewly connected player teh avg level)
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
        - Triplelevelbonus
        - AFK manager (moving afk-s to spec)
    * Is there a way to put more nades on he level, like this one 
      for GunGame5? http://forums.gungame5.com/viewtopic.php?f=17&t=265        
    * Add elimination mode.
    * Bug report
        L 07/30/2009 - 06:55:41: [SM] Native "GetClientTeam" reported: Client index 0 is invalid
        L 07/30/2009 - 06:55:41: [SM] Displaying call stack trace for plugin "gungame.smx":
        L 07/30/2009 - 06:55:41: [SM]   [0]  Line 371, gungame/event.sp::_PlayerDeath()

