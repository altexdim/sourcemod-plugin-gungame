Changelog
---------
	Current:
		* Write leaders to chat, not in hint
		* Disable second line on spawn to chat if custom kill per level = 1 (annoying line)
		- Disable "congratulation" line (there is a sound)
		+ Added line "is leading on level X"
		* Fixed possible bug for random winner sound

	Unofficial_3 1.0.0.1.1:
		* Version changed :)
	
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
    1) Enable hookusermessage after fix for https://bugs.alliedmods.net/show_bug.cgi?id=3817
    2) Add sqlite and mysql support for top players stats
	3) Add grenade warmup
	4) Fix gg_rebuild to recreate top10panel
	5) Fix recreation of top10panel after first win when no top10.txt file found (KvGotoFirstSubKey(KvRank) returns false on empty file in LoadRank)
    6) Redesign all menus (0. Exit -> 1. Exit)
	7) What is wrong with randon number generator? GetRandomInt(0,12) give one
	   the same value on server start even i use SetRandomSeed().
	8) And once again wrong top10.txt
	9) Colorize nick names in chat by team color and colorize levels by yellow color.

