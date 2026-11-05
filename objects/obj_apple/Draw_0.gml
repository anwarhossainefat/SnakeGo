// A gentle "breathing" pulse so the apple catches the eye
var s = 1 + 0.06 * sin(current_time / 250);
// The sprite is drawn in 3x detail, so scale it by global.art (1/3)
draw_sprite_ext(sprite_index, 0, x, y, s * global.art, s * global.art, 0, c_white, 1);
