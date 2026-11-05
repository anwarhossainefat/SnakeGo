// Walls are long stretched instances, so draw them as one solid slate-grey rectangle
// (stretching a sprite would distort it)
draw_set_color(make_color_rgb(51, 65, 85));
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
draw_set_color(c_white);
