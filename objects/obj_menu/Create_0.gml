// --- ONE-TIME SETUP ---
// This runs the first time the menu opens (when the game starts).
// Coming back to the menu later keeps the chosen speed and high scores.
if (!variable_global_exists("speedIndex"))
{
    // Speed options: 0 = Slow, 1 = Normal, 2 = Fast
    global.speedNames = ["Slow", "Normal", "Fast"];
    global.speedMult  = [1, 2, 3];   // Points multiplier for each speed
    global.speedIndex = 1;           // Start on "Normal"

    // Seconds per move for Level 1, 2, 3 at each speed (smaller = faster)
    global.levelSpeeds = [
        [0.30, 0.22, 0.16],   // Slow
        [0.25, 0.18, 0.13],   // Normal
        [0.18, 0.13, 0.09]    // Fast
    ];

    // Load the saved high score for each speed (0 if never played)
    global.highScores = [0, 0, 0];
    ini_open("snakego_save.ini");
    for (var i = 0; i < 3; i++)
    {
        global.highScores[i] = ini_read_real("highscores", global.speedNames[i], 0);
    }
    ini_close();

    global.totalScore = 0;
    global.gameWon    = false;
    global.paused     = false;
}
