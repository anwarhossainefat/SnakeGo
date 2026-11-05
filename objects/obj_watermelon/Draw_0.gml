// The watermelon is drawn 40x40 (bigger than the apple, since it's a bonus) from a 3x-detail sprite,
// but its collision mask is spr_body: exactly one 32x32 grid cell.
// Blink during the last 3 seconds, otherwise pulse gently
var blinkOff = (bonusTimer <= 3 * room_speed) && (bonusTimer % 10 >= 5);
if (!blinkOff)
{
    var s = 1 + 0.05 * sin(current_time / 200);
    draw_sprite_ext(sprite_index, 0, x, y, s * global.art, s * global.art, 0, c_white, 1);
}

// Timer bar just above it: a dark track with a yellow fill that shrinks
var barFill = bonusTimer / (10 * room_speed);
draw_set_color(make_color_rgb(51, 65, 85));
draw_rectangle(x - 16, y - 18, x + 16, y - 15, false);
draw_set_color(make_color_rgb(250, 204, 21));
draw_rectangle(x - 16, y - 18, x - 16 + 32 * barFill, y - 15, false);
draw_set_color(c_white);
