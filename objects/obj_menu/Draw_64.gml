// --- MENU SCREEN ---
// Fonts: 0 = XS, 1 = S, 2 = M, 3 = L (see Create)
var cx = room_width / 2;   // the GUI is always 672 x 416, whatever the window size

// A little snake chasing an apple above the title, made from the same skin pieces as the game
var sy = 64;
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
global.drawText(cx, 126, "SnakeGo", 3, global.colText, fa_center, fa_middle);
global.drawText(cx, 164, "Choose your speed", 1, global.colSub, fa_center, fa_middle);

// Speed options. The selected one sits inside a green outlined pill.
for (var i = 0; i < 3; i++)
{
	var yy = 204 + i * 40;
	var selected = (i == global.speedIndex);

	if (selected)
	{
		draw_set_color(global.colGreen);
		draw_roundrect_ext(cx - 152, yy - 18, cx + 152, yy + 18, 34, 34, false);
		draw_set_color(make_color_rgb(30, 41, 59));
		draw_roundrect_ext(cx - 150, yy - 16, cx + 150, yy + 16, 30, 30, false);
		draw_set_color(c_white);
	}

	var nameCol  = selected ? global.colText  : global.colSub;
	var multCol  = selected ? global.colGreen : global.colSub;

	global.drawText(cx - 128, yy, global.speedNames[i], 2, nameCol, fa_left, fa_middle);
	global.drawText(cx, yy, "x" + string(global.speedMult[i]) + " points", 1, multCol, fa_center, fa_middle);
	global.drawText(cx + 128, yy, "Best " + string(global.highScores[i]), 1, nameCol, fa_right, fa_middle);
}

// Start prompt (gently pulsing) and controls
var pulse = 0.65 + 0.35 * sin(current_time / 300);
global.drawText(cx, 338, "Press Enter to play", 2, global.colText, fa_center, fa_middle, pulse);
global.drawText(cx, 372, "Arrows / WASD move  ·  P pause  ·  R restart  ·  M sound  ·  F fullscreen", 0, global.colSub, fa_center, fa_middle);

// Sound status, top-right corner
global.drawText(room_width - 16, 16, global.soundOn ? "Sound on" : "Sound off", 0, global.soundOn ? global.colSub : global.colGold, fa_right, fa_middle);
