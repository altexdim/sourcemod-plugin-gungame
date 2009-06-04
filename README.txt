Changelog
---------
    Unofficial_10 1.0.0.1.8:
        * Fixed multiple kills.
        + Added random weapon order option.
        
    Unofficial_9 1.0.0.1.7:
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
    
    Unofficial_8 1.0.0.1.6:
        * Fixed top left winner message size for long nicknames.
        + Added handycap option to give the lowest level to new connected player.
        
    Unofficial_7 1.0.0.1.5:
        * Fixed money remove on player kill.
        * Colorized winner message.
        + Added sounds on last/nade level.
        * Colorized nick names in chat by red/blue color.
        * Fixed levels freezing on warmup if warmupreset is set.
        * Fixed not to give weapon on warmup if warmupknifeonly is set in turbo mode.
        * Fixed automatic switching to new given weapon in turbo mode.
        * Fixed mp_chattime time.
        + Added "!score" button to "!level" panel.
    
    Unofficial_6 1.0.0.1.4:
        * Reverted changes about warmup. Need more think about.
    
    Unofficial_5 1.0.0.1.3:
        * Added exit button "1" to "!score" menu
        * Code improved. Separated business logic about calculating leader from
          showing messages to chat. Added UTIL_RecalculateLeader and it is called from 
          UTIL_ChangeLevel. Added PrintLeaderToChat. 
        * Fixed recalculating leader on TK (GG_RemoveALevel)
        * Fixed saving to top10.txt. The issue was that only 9 players was in !top10. 10-th player
          was never loaded, so on map end his rank was rewritten by the winner.
        * Fixed warmup end right after round_restart (warmup was ending 1 second before round_restart).
        
    Unofficial_4 1.0.0.1.2:
        * Fixed bug with no message about tied with the leader when leader on level 2 (first level gained)
          Fixed FindLeader to return CLIENT (it was returning LEVEL not CLIENT). (!!!)
        * Fixed bug with no message about leaders if stealing level
        * ChangeLevel and FindLeader should come together, because
          each ChangeLevel can change and the CurrentLeader.
        * Fixed CurrentLeader calculation on stealing level
        * Fixed behaviour if multiple leaders found on intermission
    
    Unofficial_3 1.0.0.1.1:
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
    
    Unofficial_2:
        * Fixed gg_import
        * Redesigned join message panel

    Unofficial:
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
    + Save levels on disconnect and restore on reconnect.
    * Fix warmup end right after round_restart (warmup is ending 1 second before round_restart).
    * Sometimes "!scores" shows wrong levels if it was many knife battles.
      I can not figure out algorythm to reproduce this bug.
    + Add option to reload ammo on player kill.
