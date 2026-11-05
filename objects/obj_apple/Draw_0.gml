// A gentle "breathing" pulse so the apple catches the eye
var s = 1 + 0.06 * sin(current_time / 250);
draw_sprite_ext(sprite_index, 0, x, y, s, s, 0, c_white, 1);
