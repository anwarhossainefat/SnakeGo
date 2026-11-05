// End screen: shows "YOU WIN!" after the last level, otherwise "GAME OVER"
var cx = display_get_gui_width() / 2;
var cy = display_get_gui_height() / 2;
var s  = global.speedIndex;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (global.gameWon)
{
    draw_set_color(c_lime);
    draw_text_transformed(cx, cy - 75, "YOU WIN!", 2, 2, 0);
    draw_set_color(c_white);
    draw_text(cx, cy - 35, "You cleared all 3 levels!");
}
else
{
    draw_set_color(c_white);
    draw_text_transformed(cx, cy - 75, "GAME OVER", 2, 2, 0);
    draw_text(cx, cy - 35, "The snake crashed!");
}

// Final score and the best score for this speed
draw_set_color(c_white);
draw_text(cx, cy, "Final Score: " + string(global.totalScore));

draw_set_color(c_gray);
draw_text(cx, cy + 28, "Best on " + global.speedNames[s] + ": " + string(global.highScores[s]));

// Flashing "NEW HIGH SCORE!" message
if (newHighScore && (current_time div 400) mod 2 == 0)
{
    draw_set_color(c_yellow);
    draw_text(cx, cy + 58, "NEW HIGH SCORE!");
}

draw_set_color(c_white);
draw_text(cx, cy + 95, "Press R for Menu");

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
