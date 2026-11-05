draw_set_color(c_white); // Sets text color to white
draw_set_halign(fa_left);
draw_set_valign(fa_top);  // Reset in case the end screen changed it
draw_text(20, 20, "Score: " + string(global.totalScore));
