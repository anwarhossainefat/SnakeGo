// Blink during the last 3 seconds, otherwise pulse gently
var blinkOff = (bonusTimer <= 3 * room_speed) && (bonusTimer % 10 >= 5);
if (!blinkOff)
{
    var s = 1 + 0.05 * sin(current_time / 200);
    draw_sprite_ext(sprite_index, 0, x, y, s, s, 0, c_white, 1);
}

// Timer bar above it: a dark track with a yellow fill that shrinks
var barFill = bonusTimer / (10 * room_speed);
draw_set_color(make_color_rgb(51, 65, 85));
draw_rectangle(x - 14, y - 22, x + 14, y - 19, false);
draw_set_color(make_color_rgb(250, 204, 21));
draw_rectangle(x - 14, y - 22, x - 14 + 28 * barFill, y - 19, false);
draw_set_color(c_white);