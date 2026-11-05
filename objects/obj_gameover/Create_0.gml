// Ignore taps for a moment, so the finger that was steering doesn't skip this screen
readyTimer = round(room_speed * 0.6);

// Check for a new high score:
//   Campaign  -> one best score per speed
//   Free play -> one best score per level and speed
newHighScore = false;
var s = global.speedIndex;

if (global.freePlay)
{
    var lvl = global.level;
    if (global.totalScore > global.freeBest[lvl][s])
    {
        global.freeBest[lvl][s] = global.totalScore;
        newHighScore = true;
        ini_open("snakego_save.ini");
        ini_write_real("freeplay", "L" + string(lvl) + "_" + global.speedNames[s], global.totalScore);
        ini_close();
    }
}
else if (global.totalScore > global.highScores[s])
{
    global.highScores[s] = global.totalScore;
    newHighScore = true;

    // Save it so it's still there next time the game is opened
    ini_open("snakego_save.ini");
    ini_write_real("highscores", global.speedNames[s], global.totalScore);
    ini_close();
}
