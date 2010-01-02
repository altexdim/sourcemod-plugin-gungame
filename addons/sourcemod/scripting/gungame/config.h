/**
 * Config Setting
 */

new State:ConfigState;
new bool:ConfigReset;

new MapStatus;
new MaxLevelPerRound = 3;
new MinKillsPerLevel = 1;
new bool:TurboMode;
new bool:StripDeadPlayersWeapon;
new bool:AllowLevelUpAfterRoundEnd;
new bool:RemoveBonusWeaponAmmo;
new bool:ReloadWeapon;
new bool:MultiKillChat;
new bool:JoinMessage;
// TODO: Enable after fix for: https://bugs.alliedmods.net/show_bug.cgi?id=3817
// new bool:IntermissionCalcWinner;
new bool:CanStealFirstLevel;
new bool:CanLevelDownOnGrenade;
new VoteLevelLessWeaponCount;
new bool:ObjectiveBonus;
new bool:WorldspawnSuicide;
new Weapons:NadeBonusWeaponId;
new bool:NadeSmoke;
new bool:NadeFlash;
new bool:ExtraNade;
new bool:UnlimitedNades;
new bool:WarmupNades;
new bool:KnifePro;
new KnifeProMinLevel;
new bool:KnifeElite;
new bool:AutoFriendlyFire;
new bool:BotCanWin;
new TotalLevel;
new bool:WarmupEnabled = true;
new bool:DisableWarmupOnRoundEnd = false;
new bool:WarmupInitialized;
new WarmupStartup = 1;
new Warmup_TimeLength = 30;
new WarmupKnifeOnly = 1;
new WarmupReset = 1;
new WarmupCounter;
new bool:IsVotingCalled = false;
new bool:TripleLevelBonus = false;
new bool:KnifeProHE = false;
new bool:ObjectiveBonusWin = false;
new bool:InternalIsActive = true;
new bool:CommitSuicide = true;
new bool:AlltalkOnWin = false;
new bool:RestoreLevelOnReconnect;
new bool:TripleLevelBonusGodMode;
new HandicapMode;
new bool:Top10Handicap;
