// =====================================================================
// MENU SCREEN (two screens: "home" and "levels"). Layout matches Step.
// Fonts: 0 = XS, 1 = S, 2 = M, 3 = L (see Create)
// =====================================================================
var cx = room_width / 2;   // the GUI is always 672 x 416, whatever the window size
var panel = make_color_rgb(30, 41, 59);
var dark  = make_color_rgb(11, 16, 32);

if (global.menuScreen == "home")
{
	// A little snake chasing an apple above the title, made from the same skin pieces as the game
	var sy = 44;
	draw_sprite_ext(spr_skin_tail, 0, cx - 96, sy, global.art, global.art, 180, c_white, 1);
	for (var k = 0; k < 4; k++)
	{
		draw_sprite_ext(spr_skin_body, 0, cx - 64 + k * 32, sy, global.art, global.art, 0, c_white, 1);
	}
	var tongueOut = (current_time mod 2400) < 300;
	draw_sprite_ext(spr_skin_head, tongueOut ? 1 : 0, cx + 64, sy, global.art, global.art, 0, c_white, 1);
	var bob = 1 + 0.06 * sin(current_time / 250);
	draw_sprite_ext(spr_apple, 0, cx + 136, sy, bob * global.art, bob * global.art, 0, c_white, 1);

	// Title
	global.drawText(cx, 102, "SnakeGo", 3, global.colText, fa_center, fa_middle);

	// --- SPEED ROWS --- (the selected one sits inside a green outlined pill)
	for (var i = 0; i < 3; i++)
	{
		var yy = 168 + i * 36;
		var selected = (i == global.speedIndex);

		if (selected)
		{
			draw_set_color(global.colGreen);
			draw_roundrect_ext(cx - 152, yy - 16, cx + 152, yy + 16, 32, 32, false);
			draw_set_color(panel);
			draw_roundrect_ext(cx - 150, yy - 14, cx + 150, yy + 14, 28, 28, false);
			draw_set_color(c_white);
		}

		var nameCol = selected ? global.colText  : global.colSub;
		var multCol = selected ? global.colGreen : global.colSub;
		global.drawText(cx - 128, yy, global.speedNames[i], 2, nameCol, fa_left, fa_middle);
		global.drawText(cx, yy, "x" + string(global.speedMult[i]) + " points", 1, multCol, fa_center, fa_middle);
		global.drawText(cx + 128, yy, "Best " + string(global.highScores[i]), 1, nameCol, fa_right, fa_middle);
	}

	// --- MODE BUTTONS --- (the highlighted one is green; tap either to choose it)
	var titles = ["Campaign", "Free play"];
	var subs   = ["All " + string(global.levelCount) + " levels in a row", "Pick a level, play forever"];
	for (var b = 0; b < 2; b++)
	{
		var bx1 = (b == 0) ? cx - 180 : cx + 10;
		var bx2 = bx1 + 170;
		var bcx = (bx1 + bx2) / 2;
		var focused = (b == global.modeFocus);

		draw_set_color(focused ? global.colGreen : panel);
		draw_roundrect_ext(bx1, 270, bx2, 326, 24, 24, false);
		draw_set_color(c_white);

		global.drawText(bcx, 290, titles[b], 2, focused ? dark : global.colText, fa_center, fa_middle);
		global.drawText(bcx, 311, subs[b], 0, focused ? dark : global.colSub, fa_center, fa_middle);
	}

	// --- CONTROLS HINT --- (touch or keyboard)
	if (global.isTouch)
	{
		global.drawText(cx, 384, "Tap a speed, then Campaign or Free play  ·  Swipe to steer  ·  Tap  II  to pause", 0, global.colSub, fa_center, fa_middle);
	}
	else
	{
		global.drawText(cx, 384, "Up/Down speed  ·  Left/Right mode  ·  Enter choose  ·  P pause  ·  M sound  ·  F fullscreen", 0, global.colSub, fa_center, fa_middle);
	}
}
else // "levels"
{
	// --- HEADER ---
	global.drawText(cx, 30, "Free play  ·  Choose a level", 2, global.colText, fa_center, fa_middle);
	global.drawText(cx, 52, "Speed: " + global.speedNames[global.speedIndex] + "  (x" + string(global.speedMult[global.speedIndex]) + " points)", 0, global.colSub, fa_center, fa_middle);

	// --- LEVEL CARDS --- 4 per row: a mini map, the level name, and its best score at this speed
	for (var k = 0; k < global.levelCount; k++)
	{
		var L  = global.levels[k];
		var x0 = 32 + (k mod 4) * 156;
		var y0 = 70 + (k div 4) * 134;
		var focused = (k == global.levelFocus);

		// Card (green outline when highlighted)
		if (focused)
		{
			draw_set_color(global.colGreen);
			draw_roundrect_ext(x0 - 2, y0 - 2, x0 + 142, y0 + 122, 18, 18, false);
		}
		draw_set_color(panel);
		draw_roundrect_ext(x0, y0, x0 + 140, y0 + 120, 16, 16, false);

		// Mini map: 20 x 11 cells, 5 px each
		var mx0 = x0 + 20;
		var my0 = y0 + 10;
		draw_set_color(make_color_rgb(20, 27, 45));
		draw_rectangle(mx0, my0, mx0 + 99, my0 + 54, false);
		if (L.walls)
		{
			draw_set_color(make_color_rgb(71, 85, 105));
			draw_rectangle(mx0 - 2, my0 - 2, mx0 + 101, my0 + 56, true);
			draw_rectangle(mx0 - 1, my0 - 1, mx0 + 100, my0 + 55, true);
		}
		for (var r = 0; r < array_length(L.map); r++)
		{
			var rowText = L.map[r];
			for (var c = 1; c <= string_length(rowText); c++)
			{
				var ch = string_char_at(rowText, c);
				if (ch == "#" || ch == "S")
				{
					draw_set_color(ch == "#" ? make_color_rgb(99, 102, 241) : global.colGreen);
					var px = mx0 + (c - 1) * 5;
					var py = my0 + r * 5;
					draw_rectangle(px, py, px + 4, py + 4, false);
				}
			}
		}
		draw_set_color(c_white);

		// Text
		var best = global.freeBest[k + 1][global.speedIndex];
		global.drawText(x0 + 70, y0 + 78, "Level " + string(k + 1) + (L.walls ? "" : "  ·  wraps"), 0, global.colSub, fa_center, fa_middle);
		global.drawText(x0 + 70, y0 + 95, L.name, 1, global.colText, fa_center, fa_middle);
		global.drawText(x0 + 70, y0 + 110, "Best " + string(best), 0, best > 0 ? global.colGold : global.colSub, fa_center, fa_middle);
	}

	// --- BACK BUTTON ---
	draw_set_color(panel);
	draw_roundrect_ext(32, 334, 152, 370, 24, 24, false);
	draw_set_color(c_white);
	global.drawText(92, 352, "< Back", 2, global.colText, fa_center, fa_middle);

	// --- CONTROLS HINT ---
	if (global.isTouch)
	{
		global.drawText(cx + 80, 352, "Tap a level to play", 0, global.colSub, fa_center, fa_middle);
	}
	else
	{
		global.drawText(cx + 80, 352, "Arrows choose  ·  Enter play  ·  Esc back", 0, global.colSub, fa_center, fa_middle);
	}
}

// Sound status, top-right corner (tap/click it, or press M)
global.drawText(room_width - 16, 16, global.soundOn ? "Sound on" : "Sound off", 0, global.soundOn ? global.colSub : global.colGold, fa_right, fa_middle);
