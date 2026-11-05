// Draw Begin runs before every other object's Draw, so the board ends up underneath everything.
// (The rooms' Background layers are hidden, because they would be drawn on top of this.)

// Fill the whole room with the dark navy background first
draw_clear(make_color_rgb(11, 16, 32));

// A subtle checkerboard over the playing area (cell centres x 32..640, y 64..384).
var colA = make_color_rgb(20, 27, 45);
var colB = make_color_rgb(24, 32, 53);

for (var cx = 32; cx <= room_width - 32; cx += 32)
{
	for (var cy = 64; cy <= room_height - 32; cy += 32)
	{
		draw_set_color((((cx + cy) div 32) mod 2 == 0) ? colA : colB);
		draw_rectangle(cx - 16, cy - 16, cx + 15, cy + 15, false);
	}
}

draw_set_color(c_white);
