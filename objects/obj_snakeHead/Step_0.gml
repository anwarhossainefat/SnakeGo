// --- SOUND ON/OFF (M) ---
if (keyboard_check_pressed(ord("M")))
{
	global.toggleSound();
}

// --- PAUSE: P or Esc, the pause button in the HUD, or tap anywhere while paused ---
var mx = device_mouse_x_to_gui(0);   // finger / mouse position in GUI coordinates (672 x 416)
var my = device_mouse_y_to_gui(0);
var tapped = device_mouse_check_button_pressed(0, mb_left);
var onPauseButton = point_in_rectangle(mx, my, room_width - 44, 0, room_width, 32);

if (keyboard_check_pressed(ord("P")) || keyboard_check_pressed(vk_escape)
	|| (tapped && (global.paused || onPauseButton)))
{
	global.paused = !global.paused;
	global.playSound(global.sndPause);
	tapped = false;          // this tap was used for pausing, not steering
	swipeActive = false;
}

// Freeze everything while paused, or while a phone is held upright (see obj_display)
if (global.paused || global.rotateNeeded) exit;

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
