// --- MENU SCREEN ---
var cx = display_get_gui_width() / 2;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title
draw_set_color(c_lime);
draw_text_transformed(cx, 75, "SNAKEGO", 3, 3, 0);

draw_set_color(c_white);
draw_text(cx, 145, "Choose your speed");

// Speed options: the selected one is yellow with arrows
for (var i = 0; i < 3; i++)
{
    var label = global.speedNames[i]
              + "   x" + string(global.speedMult[i]) + " points"
              + "   Best: " + string(global.highScores[i]);

    if (i == global.speedIndex)
    {
        draw_set_color(c_yellow);
        label = ">  " + label + "  <";
    }
    else
    {
        draw_set_color(c_gray);
    }

    draw_text(cx, 185 + i * 34, label);
}

// Instructions
draw_set_color(c_white);
draw_text(cx, 310, "Up/Down: choose speed     Enter/Space: start");

draw_set_color(c_gray);
draw_text(cx, 350, "In game:  Arrows/WASD move    P/Esc pause    R restart");

// Reset drawing settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
