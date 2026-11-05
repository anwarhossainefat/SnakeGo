// --- HUD BAR across the top (rows 0-1 of the room are kept free for it) ---
var w = display_get_gui_width();

// Dark background strip so the text never sits on top of the game
draw_set_color(make_color_rgb(25, 25, 25));
draw_rectangle(0, 0, w, 31, false);

// Score (left), level (middle), apples left in this level (right)
draw_set_color(c_white);
draw_set_valign(fa_middle);

draw_set_halign(fa_left);
draw_text(20, 16, "Score: " + string(global.totalScore));

draw_set_halign(fa_center);
draw_text(w / 2, 16, "Level " + string(level) + "/" + string(totalLevels));

draw_set_halign(fa_right);
draw_text(w - 20, 16, "Apples: " + string(points) + "/" + string(applesPerLevel));

// Reset text alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
