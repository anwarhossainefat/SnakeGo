// Check for a new high score at the speed the player chose
newHighScore = false;

var s = global.speedIndex;
if (global.totalScore > global.highScores[s])
{
    global.highScores[s] = global.totalScore;
    newHighScore = true;

    // Save it so it's still there next time the game is opened
    ini_open("snakego_save.ini");
    ini_write_real("highscores", global.speedNames[s], global.totalScore);
    ini_close();
}
