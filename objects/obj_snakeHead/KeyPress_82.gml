// Restart: Campaign goes back to Level 1, Free play restarts the same level. Same speed.
global.totalScore = 0;
global.gameWon    = false;
if (!global.freePlay) global.level = 1;
room_restart();
