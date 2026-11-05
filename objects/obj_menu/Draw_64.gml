// --- MENU SCREEN ---
// Fonts: 0 = XS, 1 = S, 2 = M, 3 = L (see Create)
var cx = room_width / 2;   // the GUI is always 672 x 416, whatever the window size

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
		draw_set_color(make_color_rgb(30, 41, 59));
		draw_roundrect_ext(cx - 150, yy - 14, cx + 150, yy + 14, 28, 28, false);
		draw_set_color(c_white);
	}

	var nameCol = selected ? global.colText  : global.colSub;
	var multCol = selected ? global.colGreen : global.colSub;

	// Best score shown for the chosen mode: campaign best, or this level's free-play best
	var best = (global.menuChoice == 0) ? global.highScores[i] : global.freeBest[global.menuChoice][i];

	global.drawText(cx - 128, yy, global.speedNames[i], 2, nameCol, fa_left, fa_middle);
	global.drawText(cx, yy, "x" + string(global.speedMult[i]) + " points", 1, multCol, fa_center, fa_middle);
	global.drawText(cx + 128, yy, "Best " + string(best), 1, nameCol, fa_right, fa_middle);
}

// --- MODE / LEVEL PICKER ---
draw_set_color(make_color_rgb(30, 41, 59));
draw_roundrect_ext(cx - 190, 272, cx + 190, 308, 36, 36, false);
draw_set_color(c_white);
global.drawText(cx - 168, 290, "<", 2, global.colGreen, fa_left, fa_middle);
global.drawText(cx + 168, 290, ">", 2, global.colGreen, fa_right, fa_middle);

var modeText;
if (global.menuChoice == 0)
{
	modeText = "Campaign  ·  all " + string(global.levelCount) + " levels";
}
else
{
	modeText = "Free play  ·  Level " + string(global.menuChoice) + ": " + global.levels[global.menuChoice - 1].name;
}
global.drawText(cx, 290, modeText, 1, global.colText, fa_center, fa_middle);

// --- PLAY BUTTON --- (tap/click it, or press Enter). It gently pulses.
var pulse = 0.85 + 0.15 * sin(current_time / 300);
draw_set_color(global.colGreen);
draw_set_alpha(pulse);
draw_roundrect_ext(cx - 90, 316, cx + 90, 356, 40, 40, false);
draw_set_alpha(1);
draw_set_color(c_white);
global.drawText(cx, 336, "Play", 2, make_color_rgb(11, 16, 32), fa_center, fa_middle);

// --- CONTROLS HINT --- (touch or keyboard)
if (global.isTouch)
{
	global.drawText(cx, 390, "Tap a speed and a mode, then Play  ·  Swipe to steer  ·  Tap  II  to pause", 0, global.colSub, fa_center, fa_middle);
}
else
{
	global.drawText(cx, 390, "Up/Down speed  ·  Left/Right mode  ·  Enter play  ·  P pause  ·  M sound  ·  F fullscreen", 0, global.colSub, fa_center, fa_middle);
}

// Sound status, top-right corner (tap/click it, or press M)
global.drawText(room_width - 16, 16, global.soundOn ? "Sound on" : "Sound off", 0, global.soundOn ? global.colSub : global.colGold, fa_right, fa_middle);
