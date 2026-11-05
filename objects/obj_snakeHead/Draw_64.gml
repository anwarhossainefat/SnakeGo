// --- HUD: score (left), level (middle), apples left in this level (right) ---
draw_set_color(c_white);
draw_set_valign(fa_top);  // Reset in case the end screen changed it

draw_set_halign(fa_left);
draw_text(20, 20, "Score: " + string(global.totalScore));

draw_set_halign(fa_center);
draw_text(display_get_gui_width() / 2, 20, "Level " + string(level) + "/" + string(totalLevels));

draw_set_halign(fa_right);
draw_text(display_get_gui_width() - 20, 20, "Apples: " + string(points) + "/" + string(applesPerLevel));

draw_set_halign(fa_left);
