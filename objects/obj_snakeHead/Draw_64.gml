// --- HUD BAR across the top (rows 0-1 of the room are kept free for it) ---
// Fonts: 0 = XS, 1 = S, 2 = M, 3 = L (see obj_menu Create)
var w = display_get_gui_width();

// Dark background strip so the text never sits on top of the game
draw_set_color(make_color_rgb(8, 12, 24));
draw_rectangle(0, 0, w, 31, false);
draw_set_color(c_white);

// Left: "SCORE 140"
global.drawText(20, 16, "SCORE", 0, global.colSub, fa_left, fa_middle);
global.drawText(20 + global.textWidth("SCORE", 0) + 8, 16, string(global.totalScore), 2, global.colText, fa_left, fa_middle);

// Middle: "Level 1/3 · Normal"
var levelText = "Level " + string(level) + "/" + string(totalLevels) + "  ·  " + global.speedNames[global.speedIndex];
global.drawText(w / 2, 16, levelText, 1, global.colText, fa_center, fa_middle);

// Right: apple icon + "4/10"
var appleText = string(points) + "/" + string(applesPerLevel);
var appleTextW = global.textWidth(appleText, 2);
global.drawText(w - 20, 16, appleText, 2, global.colText, fa_right, fa_middle);
draw_sprite_ext(spr_apple, 0, w - 20 - appleTextW - 14, 16, 0.6, 0.6, 0, c_white, 1);

// --- PAUSE OVERLAY ---
if (global.paused)
{
	var h = display_get_gui_height();

	// Darken the play area
	draw_set_alpha(0.65);
	draw_set_color(c_black);
	draw_rectangle(0, 32, w, h, false);
	draw_set_alpha(1);
	draw_set_color(c_white);

	global.drawText(w / 2, h / 2 - 10, "Paused", 3, global.colText, fa_center, fa_middle);
	global.drawText(w / 2, h / 2 + 34, "Press P or Esc to continue", 1, global.colSub, fa_center, fa_middle);
}
