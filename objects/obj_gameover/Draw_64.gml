// End screen: shows "YOU WIN!" after the last level, otherwise "GAME OVER"
var cx = display_get_gui_width() / 2;
var cy = display_get_gui_height() / 2;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (global.gameWon)
{
    draw_set_color(c_lime);
    draw_text_transformed(cx, cy - 40, "YOU WIN!", 2, 2, 0);
    draw_set_color(c_white);
    draw_text(cx, cy, "You cleared all 3 levels!");
}
else
{
    draw_set_color(c_white);
    draw_text_transformed(cx, cy - 40, "GAME OVER", 2, 2, 0);
    draw_text(cx, cy, "The snake crashed!");
}

// Final score and restart instruction
draw_set_color(c_white);
draw_text(cx, cy + 30, "Final Score: " + string(global.totalScore));
draw_text(cx, cy + 60, "Press R to Play Again");

// Reset text alignment so other text draws normally
draw_set_halign(fa_left);
draw_set_valign(fa_top);
