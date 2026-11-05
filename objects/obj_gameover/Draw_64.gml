draw_set_halign(fa_center); // Center the text
draw_set_valign(fa_middle);

// Draw "GAME OVER" in the middle of the screen
draw_text_transformed(display_get_gui_width()/2, display_get_gui_height()/2 - 20, "GAME OVER", 2, 2, 0);

// Draw the Final Score below it
draw_text(display_get_gui_width()/2, display_get_gui_height()/2 + 20, "Final Score: " + string(global.totalScore));

// Draw Restart Instruction
draw_text(display_get_gui_width()/2, display_get_gui_height()/2 + 50, "Press R to Restart");