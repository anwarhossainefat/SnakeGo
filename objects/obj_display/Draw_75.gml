// Draw GUI End: drawn on top of everything else.
// "Rotate your phone" screen when a phone/tablet is held upright.
if (!global.rotateNeeded) exit;

// Cover the whole window (not just the game area), in GUI coordinates
var x1 = -guiOffX / guiScale;
var y1 = -guiOffY / guiScale;
var x2 = (lastW - guiOffX) / guiScale;
var y2 = (lastH - guiOffY) / guiScale;
draw_set_color(make_color_rgb(11, 16, 32));
draw_rectangle(x1, y1, x2, y2, false);

var cx = baseW / 2;
var cy = baseH / 2;

// Two phone outlines: upright -> sideways
draw_set_color(global.colSub);
draw_roundrect_ext(cx - 120, cy - 150, cx - 76, cy - 74, 12, 12, true);   // upright phone
draw_roundrect_ext(cx - 119, cy - 149, cx - 77, cy - 75, 12, 12, true);
draw_set_color(global.colGreen);
draw_roundrect_ext(cx + 40, cy - 134, cx + 116, cy - 90, 12, 12, true);   // sideways phone
draw_roundrect_ext(cx + 41, cy - 133, cx + 115, cy - 91, 12, 12, true);
draw_set_color(c_white);
global.drawText(cx - 18, cy - 112, ">", 3, global.colText, fa_center, fa_middle, 1, 0.8);

// Message (drawn a bit larger, because the game area is small on an upright phone)
global.drawText(cx, cy - 20, "Rotate your phone", 3, global.colText, fa_center, fa_middle, 1, 1.1);
global.drawText(cx, cy + 40, "SnakeGo plays sideways", 1, global.colSub, fa_center, fa_middle, 1, 2);
