Changelog
---------
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

TODO
----
    1) Enable hookusermessage after fix for https://bugs.alliedmods.net/show_bug.cgi?id=3817
    2) Add sqlite and mysql support for top players stats
	3) Add grenade warmup
	4) Fix gg_reload to recreate top10panel
	5) Fix recreation of top10panel after first win when no top10.txt file found (HasRank)
