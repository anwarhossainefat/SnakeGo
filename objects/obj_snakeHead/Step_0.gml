moveTimer --;

// Steering: WASD or arrow keys.
// The image_angle checks stop the snake from reversing into itself.
if((keyboard_check(ord("W")) || keyboard_check(vk_up)) && image_angle != 180)
{
	Direction = "up";
}

if((keyboard_check(ord("S")) || keyboard_check(vk_down)) && image_angle != 0)
{
	Direction = "down";
}

if((keyboard_check(ord("A")) || keyboard_check(vk_left)) && image_angle != 270)
{
	Direction = "left";
}

if((keyboard_check(ord("D")) || keyboard_check(vk_right)) && image_angle != 90)
{
	Direction = "right";
}

prevHeadX = x;
prevHeadY = y;

if(moveTimer <= 0)
{
	if(Direction = "up")
	{
		y-=32;
		image_angle = 0;
	}

	if(Direction = "down")
	{
		y+=32;
		image_angle = 180;
	}

	if(Direction = "left")
	{
		x-=32;
		image_angle = 90;
	}

	if(Direction = "right")
	{
		x+=32;
		image_angle = 270;
	}

	// Wrap around the edges, but only in levels with no walls (Level 1).
	// Keeps the head on the grid: x 32..640, y 32..352.
	if (!instance_exists(obj_wall))
	{
		if (x < 32)               x = room_width - 32;
		if (x > room_width - 32)  x = 32;
		if (y < 32)               y = room_height - 32;
		if (y > room_height - 32) y = 32;
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

	moveTimer = moveSpeed * room_speed;
}
