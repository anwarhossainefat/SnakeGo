// Make the window about 85% of the screen size (keeping the game's shape)
var fit = min(display_get_width() * 0.85 / baseW, display_get_height() * 0.85 / baseH);
window_set_size(round(baseW * fit), round(baseH * fit));

// Centre it once the new size has taken effect
alarm[1] = 2;
