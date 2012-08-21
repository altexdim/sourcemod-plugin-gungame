@echo off 

set DIR_SERVER_SOURCEMOD=H:\games\csgo_ds\csgo\addons\sourcemod
set DIR_SERVER_SCRIPTING=%DIR_SERVER_SOURCEMOD%\scripting
set DIR_SERVER_PLUGINS=%DIR_SERVER_SOURCEMOD%\plugins

set DIR_SOURCES_SOURCEMOD=C:\home\altex\git\css_plugins\sm_gungame\addons\sourcemod
set DIR_SOURCES_SCRIPTING=%DIR_SOURCES_SOURCEMOD%\scripting
set DIR_SOURCES_PLUGINS=%DIR_SOURCES_SOURCEMOD%\plugins

set LOG_COMPILE=%DIR_SOURCES_SCRIPTING%\compile_gungame.log

xcopy /e /f /y %DIR_SOURCES_SCRIPTING%\*.* %DIR_SERVER_SCRIPTING%\

cd /d %DIR_SERVER_SCRIPTING%

echo %DATE% %TIME% > %LOG_COMPILE%

:::csgo version

%DIR_SERVER_SCRIPTING%\spcomp gungame.sp WITH_SDKHOOKS=1 WITH_CSGO_SUPPORT=1    >> %LOG_COMPILE%
copy %DIR_SERVER_SCRIPTING%\gungame.smx                 %DIR_SOURCES_PLUGINS%\disabled\gungame_sdkhooks.smx
copy %DIR_SERVER_SCRIPTING%\gungame.smx                 %DIR_SERVER_PLUGINS%\gungame_sdkhooks.smx

%DIR_SERVER_SCRIPTING%\spcomp gungame.sp WITH_CSGO_SUPPORT=1                >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_afk.sp WITH_CSGO_SUPPORT=1            >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_config.sp WITH_CSGO_SUPPORT=1         >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_display_winner.sp WITH_CSGO_SUPPORT=1 >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_logging.sp WITH_CSGO_SUPPORT=1        >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_mapvoting.sp WITH_CSGO_SUPPORT=1      >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_stats.sp WITH_CSGO_SUPPORT=1          >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_tk.sp WITH_CSGO_SUPPORT=1             >> %LOG_COMPILE%
%DIR_SERVER_SCRIPTING%\spcomp gungame_bot.sp WITH_CSGO_SUPPORT=1            >> %LOG_COMPILE%

copy %DIR_SERVER_SCRIPTING%\gungame.smx                 %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_afk.smx             %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_config.smx          %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_display_winner.smx  %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_logging.smx         %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_mapvoting.smx       %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_stats.smx           %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_tk.smx              %DIR_SOURCES_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_bot.smx             %DIR_SOURCES_PLUGINS%\

copy %DIR_SERVER_SCRIPTING%\gungame.smx                 %DIR_SERVER_PLUGINS%\disabled\
copy %DIR_SERVER_SCRIPTING%\gungame_afk.smx             %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_config.smx          %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_display_winner.smx  %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_logging.smx         %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_mapvoting.smx       %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_stats.smx           %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_tk.smx              %DIR_SERVER_PLUGINS%\
copy %DIR_SERVER_SCRIPTING%\gungame_bot.smx             %DIR_SERVER_PLUGINS%\


cd /d %DIR_SOURCES_SCRIPTING%
