Changelog
---------
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
	* What is wrong with randon number generator? GetRandomInt(0,12) give one
	  the same value on server start even i use SetRandomSeed().
	* And once again something wrong top10.txt, not correctly calculated after player win.
	* Colorize nick names in chat by red/blue color.
	* Colorize nick name on top left corner on gg win.
	* Fix bug with no message about tied with the leader when leader on level 2 (first level gained)
	* Fix bug with no message about leaders if stealing level

