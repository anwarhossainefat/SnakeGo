// End screen: "You win!" after the last level, otherwise "Game over"
// Fonts: 0 = XS, 1 = S, 2 = M, 3 = L (see obj_menu Create)
var cx = room_width / 2;   // the GUI is always 672 x 416, whatever the window size
var cy = room_height / 2;
var s  = global.speedIndex;

if (global.gameWon)
{
	global.drawText(cx, cy - 92, "You win!", 3, global.colGreen, fa_center, fa_middle);
	global.drawText(cx, cy - 52, "You cleared all 3 levels", 1, global.colSub, fa_center, fa_middle);
}
else
{
	global.drawText(cx, cy - 92, "Game over", 3, global.colText, fa_center, fa_middle);
	global.drawText(cx, cy - 52, "The snake crashed", 1, global.colSub, fa_center, fa_middle);
}

// Final score, big
global.drawText(cx, cy - 14, "FINAL SCORE", 0, global.colSub, fa_center, fa_middle);
global.drawText(cx, cy + 20, string(global.totalScore), 3, global.colText, fa_center, fa_middle, 1, 0.8);

// Best score for this speed
global.drawText(cx, cy + 58, "Best on " + global.speedNames[s] + ": " + string(global.highScores[s]), 1, global.colSub, fa_center, fa_middle);

// Flashing "New high score!" message
if (newHighScore && (current_time div 400) mod 2 == 0)
{
	global.drawText(cx, cy + 88, "New high score!", 2, global.colGold, fa_center, fa_middle);
}

global.drawText(cx, cy + 128, global.isTouch ? "Tap for menu" : "Press R or click for menu", 1, global.colText, fa_center, fa_middle);
