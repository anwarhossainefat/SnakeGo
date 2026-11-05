// --- HUD BAR across the top (rows 0-1 of the room are kept free for it) ---
var w = display_get_gui_width();

// Dark background strip so the text never sits on top of the game
draw_set_color(make_color_rgb(8, 12, 24));
draw_rectangle(0, 0, w, 31, false);

// Score (left), level (middle), apples left in this level (right)
draw_set_color(c_white);
draw_set_valign(fa_middle);

draw_set_halign(fa_left);
draw_text(20, 16, "Score: " + string(global.totalScore));

draw_set_halign(fa_center);
draw_text(w / 2, 16, "Level " + string(level) + "/" + string(totalLevels) + "  -  " + global.speedNames[global.speedIndex]);

draw_set_halign(fa_right);
draw_text(w - 20, 16, "Apples: " + string(points) + "/" + string(applesPerLevel));

// --- PAUSE OVERLAY ---
if (global.paused)
{
	var h = display_get_gui_height();

	// Darken the play area
	draw_set_alpha(0.6);
	draw_set_color(c_black);
	draw_rectangle(0, 32, w, h, false);
	draw_set_alpha(1);

	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text_transformed(w / 2, h / 2, "PAUSED", 2, 2, 0);
	draw_text(w / 2, h / 2 + 40, "Press P or Esc to continue");
}

// Reset text alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
