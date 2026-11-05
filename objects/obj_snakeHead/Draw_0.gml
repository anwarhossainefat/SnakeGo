// =====================================================================
// Draw the whole snake with realistic skin pieces.
// The body objects are invisible; they're only used for collisions.
// Pieces: spr_skin_head, spr_skin_body (straight), spr_skin_corner, spr_skin_tail
// They are made in 3x detail and drawn at global.art scale (1/3) so they stay sharp when the game is big.
// =====================================================================

// 1) List the segment positions from head to tail.
//    Skip duplicates: a newly grown tail piece sits on top of the old tail until the snake moves.
var segX = [x];
var segY = [y];
for (var j = 1; j < startBodyParts + points; j++)
{
	var bx = BodyPart[j].x;
	var by = BodyPart[j].y;
	var last = array_length(segX) - 1;
	if (bx != segX[last] || by != segY[last])
	{
		array_push(segX, bx);
		array_push(segY, by);
	}
}
var n = array_length(segX);

// Direction from one cell to a neighbouring cell: 0 right, 90 up, 180 left, 270 down.
// Also handles the Level 1 wrap-around, where neighbours can be on opposite edges.
var dirTo = function(x1, y1, x2, y2)
{
	var dx = x2 - x1;
	var dy = y2 - y1;
	if (dx > 32)  dx = -32;
	if (dx < -32) dx = 32;
	if (dy > 32)  dy = -32;
	if (dy < -32) dy = 32;
	if (dx > 0) return 0;
	if (dx < 0) return 180;
	if (dy < 0) return 90;
	return 270;
};

// 2) Draw from the tail up to the neck, so pieces nearer the head are on top
for (var k = n - 1; k >= 1; k--)
{
	var toFront = dirTo(segX[k], segY[k], segX[k - 1], segY[k - 1]); // towards the head

	if (k == n - 1)
	{
		// Tail: the sprite's wide end is on its left side, so turn that side to face the body
		draw_sprite_ext(spr_skin_tail, 0, segX[k], segY[k], global.art, global.art, toFront - 180, c_white, 1);
	}
	else
	{
		var toBack = dirTo(segX[k], segY[k], segX[k + 1], segY[k + 1]); // towards the tail

		if ((toFront - toBack + 360) mod 360 == 180)
		{
			// Straight piece
			draw_sprite_ext(spr_skin_body, 0, segX[k], segY[k], global.art, global.art, toFront mod 180, c_white, 1);
		}
		else
		{
			// Corner piece: the sprite joins LEFT and DOWN, so rotate it to join toFront and toBack
			var first = ((toBack - toFront + 360) mod 360 == 90) ? toFront : toBack;
			draw_sprite_ext(spr_skin_corner, 0, segX[k], segY[k], global.art, global.art, (first + 180) mod 360, c_white, 1);
		}
	}
}

// 3) Head on top, facing away from the neck. The tongue flicks out every 2.4 seconds.
var headAngle = (n > 1) ? dirTo(segX[1], segY[1], x, y) : 90;
var tongueOut = (current_time mod 2400) < 300;
draw_sprite_ext(spr_skin_head, tongueOut ? 1 : 0, x, y, global.art, global.art, headAngle, c_white, 1);

// =====================================================================
// Floating "+points" text that drifts up and fades where food was eaten
// =====================================================================
if (popupTimer > 0)
{
	var progress = 1 - popupTimer / room_speed; // 0 at start, 1 at the end
	global.drawText(popupX, popupY - 20 * progress, popupText, 2, popupColour, fa_center, fa_middle, 1 - progress);
}
