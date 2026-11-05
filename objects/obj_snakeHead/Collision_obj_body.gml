// Crashed: play the crash sound once, then show the end screen
if (crashed) exit;
crashed = true;

global.playSound(global.sndCrash);
global.playSound(global.sndCrashFx);
room_goto(rm_gameover);
