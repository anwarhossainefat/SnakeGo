// --- SOUND ON/OFF (M) ---
if (keyboard_check_pressed(ord("M")))
{
	global.toggleSound();
}

// --- PAUSE: P or Esc, or the II button in the HUD ---
// Mouse/finger position. Room coordinates match the menu/HUD layout exactly (both are 672 x 416),
// and GameMaker keeps them correct on every platform, including the web version.
var mx = device_mouse_x(0);
var my = device_mouse_y(0);
var tapped = device_mouse_check_button_pressed(0, mb_left);
var onPauseButton = point_in_rectangle(mx, my, room_width - 44, 0, room_width, 32);

if (keyboard_check_pressed(ord("P")) || keyboard_check_pressed(vk_escape) || (tapped && onPauseButton))
{
	global.paused = !global.paused;
	pauseFocus = 0;          // the pause menu always opens on "Resume"
	global.playSound(global.sndPause);
	tapped = false;          // this tap was used for pausing, not steering
	swipeActive = false;
}
else if (global.paused)
{
	// --- PAUSE MENU: Resume / Restart / Main menu ---
	// Up/Down (or W/S) to highlight, Enter/Space to choose, or tap a button. Layout matches Draw GUI.
	if (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"))) { pauseFocus = max(0, pauseFocus - 1); global.playSound(global.sndTick); }
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) { pauseFocus = min(2, pauseFocus + 1); global.playSound(global.sndTick); }

	var choice = (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) ? pauseFocus : -1;
	if (tapped)
	{
		for (var b = 0; b < 3; b++)
		{
			var by = 196 + b * 46;
			if (point_in_rectangle(mx, my, room_width / 2 - 110, by - 19, room_width / 2 + 110, by + 19)) choice = b;
		}
	}

	if (choice == 0)
	{
		// Resume
		global.paused = false;
		global.playSound(global.sndPause);
	}
	else if (choice == 1)
	{
		// Restart: Campaign from level 1, Free play the same level. Same speed.
		global.paused     = false;
		global.totalScore = 0;
		global.gameWon    = false;
		if (!global.freePlay) global.level = 1;
		global.playSound(global.sndSelect);
		room_restart();
	}
	else if (choice == 2)
	{
		// Back to the menu (Free play returns to the level grid)
		global.paused = false;
		global.playSound(global.sndSelect);
		room_goto(rm_menu);
	}
}

// Freeze everything while paused, or while a phone is held upright (see obj_display)
if (global.paused || global.rotateNeeded) exit;

// --- GET READY (start of every level) ---
// Wait 5 seconds, or until the player presses a key (not M or F) or taps.
// Pressing an arrow/WASD key to start also makes that the first turn (handled just below).
if (readyTimer > 0)
{
	readyTimer--;
	var anyKey = keyboard_check_pressed(vk_anykey) && !keyboard_check_pressed(ord("M")) && !keyboard_check_pressed(ord("F"));
	if (anyKey || tapped) readyTimer = 0;
	if (readyTimer > 0) exit;
}

moveTimer --;

// Count down the floating "+points" text
if (popupTimer > 0) popupTimer--;

// --- KEYBOARD STEERING ---
if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up))    queueTurn("up");
if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down))  queueTurn("down");
if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left))  queueTurn("left");
if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) queueTurn("right");

// --- SWIPE STEERING (phones and tablets; a mouse drag works too) ---
// Put a finger down, slide it about 20 pixels in a direction, and the snake turns that way.
// You can keep the finger down and swipe again for the next turn.
if (tapped)
{
	swipeActive = true;
	swipeX = mx;
	swipeY = my;
}

if (swipeActive && device_mouse_check_button(0, mb_left))
{
	var dx = mx - swipeX;
	var dy = my - swipeY;
	if (max(abs(dx), abs(dy)) > 20)
	{
		if (abs(dx) > abs(dy)) queueTurn(dx > 0 ? "right" : "left");
		else                   queueTurn(dy > 0 ? "down" : "up");
		swipeX = mx;
		swipeY = my;
	}
}

if (device_mouse_check_button_released(0, mb_left))
{
	swipeActive = false;
}

// --- MOVE ---
if(moveTimer <= 0)
{
	// Take the next queued turn, if there is one
	if (array_length(dirQueue) > 0)
	{
		Direction = dirQueue[0];
		array_delete(dirQueue, 0, 1);
	}

	prevHeadX = x;
	prevHeadY = y;

	if(Direction == "up")
	{
		y-=32;
		image_angle = 0;
	}

	if(Direction == "down")
	{
		y+=32;
		image_angle = 180;
	}

	if(Direction == "left")
	{
		x-=32;
		image_angle = 90;
	}

	if(Direction == "right")
	{
		x+=32;
		image_angle = 270;
	}

	// Wrap around the edges, but only in levels with no walls (Level 1).
	// Keeps the head on the grid: x 32..640, y 64..384 (the HUD bar is above y 64).
	if (!instance_exists(obj_wall))
	{
		var top = 64;
		if (x < 32)               x = room_width - 32;
		if (x > room_width - 32)  x = 32;
		if (y < top)              y = room_height - 32;
		if (y > room_height - 32) y = top;
	}

	// Each body part moves into the spot of the part in front of it
	for(i=1; i< startBodyParts + points; i+=1)
	{
		var prevX = BodyPart[i].x;
		var prevY = BodyPart[i].y;

		BodyPart[i].x = prevHeadX;
		BodyPart[i].y = prevHeadY;

		prevHeadX = prevX;
		prevHeadY = prevY;
	}

	moveTimer = round(moveSpeed * room_speed);
}
