moveTimer --;

// Count down the floating "+points" text
if (popupTimer > 0) popupTimer--;

// --- READ INPUT ---
// Each key press is saved in a small queue, so quick double turns
// (e.g. right then down) both happen, one per move.
var pressed = "";
if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up))    pressed = "up";
if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down))  pressed = "down";
if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left))  pressed = "left";
if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) pressed = "right";

if (pressed != "" && array_length(dirQueue) < 2)
{
	// Compare with the last queued turn (or the current direction if nothing is queued)
	var lastDir = (array_length(dirQueue) > 0) ? dirQueue[array_length(dirQueue) - 1] : Direction;

	// Ignore pressing the same direction, or reversing into yourself
	var isReverse = (pressed == "up"    && lastDir == "down")
	             || (pressed == "down"  && lastDir == "up")
	             || (pressed == "left"  && lastDir == "right")
	             || (pressed == "right" && lastDir == "left");

	if (pressed != lastDir && !isReverse)
	{
		array_push(dirQueue, pressed);
	}
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
