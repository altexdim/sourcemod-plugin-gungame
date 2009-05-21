Changelog
---------
	Unofficial_5 1.0.0.1.3:
		* Added exit button "1" to "!score" menu
		* Code improved. Separated buisness logic about calculating leader from
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
	+ Add grenade warmup
	* What is wrong with random number generator? GetRandomInt(0,12) give one
	  the same value on server start even i use SetRandomSeed().
	* Colorize nick names in chat by red/blue color.
	  Is it possible on CSS? (MessageSay2 or etc.)
	* Colorize nick name on top left corner on gg win.
	* Money are not removed on player kill, only on player spawn.
	* Is there a sound if player is on last/nade level?
	  Is it plays on player reaches this level?
	  Is it plays on round start?
