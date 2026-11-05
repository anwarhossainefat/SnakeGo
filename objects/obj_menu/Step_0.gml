// =====================================================================
// MENU: two screens
//   "home"   -> choose a speed, then Campaign (starts right away) or Free play
//   "levels" -> Free play: choose one of the level cards
// Layout numbers here must match Draw GUI.
// =====================================================================
var cx = room_width / 2;

// Mouse/finger position. Room coordinates match the menu layout exactly (both are 672 x 416),
// and GameMaker keeps them correct on every platform, including the web version.
var mx = device_mouse_x(0);
var my = device_mouse_y(0);
var tapped = device_mouse_check_button_pressed(0, mb_left) && !global.rotateNeeded;
var enter  = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

// Start a game: Campaign (from level 1) or Free play on one level
var startGame = function(_freePlay, _level)
{
	global.playSound(global.sndSelect);
	global.freePlay   = _freePlay;
	global.level      = _level;
	global.totalScore = 0;
	global.gameWon    = false;
	room_goto(rm_game);
};

if (global.menuScreen == "home")
{
	// --- Speed: Up/Down (or W/S), or tap a row ---
	if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
	{
		global.speedIndex = max(0, global.speedIndex - 1);
		global.playSound(global.sndTick);
	}
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
	{
		global.speedIndex = min(2, global.speedIndex + 1);
		global.playSound(global.sndTick);
	}
	if (tapped)
	{
		for (var i = 0; i < 3; i++)
		{
			var yy = 168 + i * 36;
			if (point_in_rectangle(mx, my, cx - 152, yy - 16, cx + 152, yy + 16) && global.speedIndex != i)
			{
				global.speedIndex = i;
				global.playSound(global.sndTick);
			}
		}
	}

	// --- Mode: Left/Right (or A/D) to highlight, Enter to choose; or tap a button ---
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) ||
	    keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
	{
		global.modeFocus = 1 - global.modeFocus;
		global.playSound(global.sndTick);
	}

	var chooseMode = enter ? global.modeFocus : -1;
	if (tapped)
	{
		if (point_in_rectangle(mx, my, cx - 180, 270, cx - 10, 326)) chooseMode = 0;
		if (point_in_rectangle(mx, my, cx + 10, 270, cx + 180, 326)) chooseMode = 1;
	}

	// Tap/click "Source code on GitHub" at the bottom to open the project's repository (in a new tab on the web)
	if (tapped)
	{
		var creditW = global.textWidth("by Anwar Hossain Efat  ·  CS 5539, Idaho State University  ·  ", 0);
		var linkW   = global.textWidth("Source code on GitHub", 0);
		var linkX   = cx - (creditW + linkW) / 2 + creditW;
		if (point_in_rectangle(mx, my, linkX - 6, 394, linkX + linkW + 6, 416))
		{
			url_open_ext("https://github.com/anwarhossainefat/SnakeGo", "_blank");
		}
	}

	if (chooseMode == 0)
	{
		global.modeFocus = 0;
		startGame(false, 1);
	}
	else if (chooseMode == 1)
	{
		global.modeFocus  = 1;
		global.menuScreen = "levels";
		global.playSound(global.sndSelect);
	}
}
else // "levels"
{
	// --- Move between the cards: arrow keys / WASD (4 cards per row) ---
	var n = global.levelCount;
	var f = global.levelFocus;
	if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"))) f -= 1;
	if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) f += 1;
	if (keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"))) f -= 4;
	if (keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"))) f += 4;
	f = clamp(f, 0, n - 1);
	if (f != global.levelFocus)
	{
		global.levelFocus = f;
		global.playSound(global.sndTick);
	}

	var playLevel = enter ? global.levelFocus : -1;
	var goBack = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

	if (tapped)
	{
		// Tap a card to play that level
		for (var k = 0; k < n; k++)
		{
			var x0 = 32 + (k mod 4) * 156;
			var y0 = 70 + (k div 4) * 134;
			if (point_in_rectangle(mx, my, x0, y0, x0 + 140, y0 + 120)) playLevel = k;
		}
		// Tap Back
		if (point_in_rectangle(mx, my, 32, 334, 152, 370)) goBack = true;
	}

	if (playLevel >= 0)
	{
		global.levelFocus = playLevel;
		startGame(true, playLevel + 1);
	}
	else if (goBack)
	{
		global.menuScreen = "home";
		global.playSound(global.sndTick);
	}
}

// --- Sound: M, or tap "Sound on/off" in the top-right corner ---
if (keyboard_check_pressed(ord("M")) || (tapped && point_in_rectangle(mx, my, room_width - 110, 0, room_width, 32)))
{
	global.toggleSound();
}
