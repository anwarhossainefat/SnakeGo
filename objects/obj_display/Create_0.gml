// =====================================================================
// obj_display: makes the game fit any window, screen or browser.
// The game world is always 672 x 416. It is scaled to fill the window
// (keeping its shape, with dark bars at the sides if needed), and drawn at
// the window's full resolution so everything stays sharp.
// This object is persistent: it's created once by the menu and lives in every room.
// =====================================================================
baseW = 672;
baseH = 416;
cam   = camera_create_view(0, 0, baseW, baseH);   // a camera that always shows the whole game area
lastW = -1;
lastH = -1;
isBrowser = (os_browser != browser_not_a_browser);
fullscreenOn = false;   // the game remembers this itself (macOS can report it late)

// Colour of the bars around the game when the window is a different shape
window_set_colour(make_color_rgb(8, 12, 24));

// Turn on view 0 in the current room and point it at the whole game area
setupRoomView = function()
{
	view_enabled    = true;
	view_visible[0] = true;
	view_camera[0]  = cam;
	view_xport[0]   = 0;
	view_yport[0]   = 0;
	lastW = -1;   // force a resize on the next step
};

// Match the drawing resolution to the window size
fitToWindow = function()
{
	var winW, winH;
	if (isBrowser)
	{
		// In a web page, make the game canvas as big as the browser window
		winW = browser_width;
		winH = browser_height;
		if (window_get_width() != winW || window_get_height() != winH) window_set_size(winW, winH);
	}
	else
	{
		winW = window_get_width();
		winH = window_get_height();
	}

	if (winW <= 0 || winH <= 0) return;
	if (winW == lastW && winH == lastH) return;   // nothing changed
	lastW = winW;
	lastH = winH;

	// Biggest size that fits while keeping the 672 x 416 shape
	var fit   = min(winW / baseW, winH / baseH);
	var surfW = max(1, floor(baseW * fit));
	var surfH = max(1, floor(baseH * fit));

	view_wport[0] = surfW;
	view_hport[0] = surfH;
	surface_resize(application_surface, surfW, surfH);

	// The GUI (HUD, menus, text) keeps using 672 x 416 coordinates, lined up exactly with the game area
	display_set_gui_maximize(surfW / baseW, surfH / baseH, (winW - surfW) / 2, (winH - surfH) / 2);
};

setupRoomView();
fitToWindow();

// On a computer, open a bigger window (about 85% of the screen) a moment after starting
if (!isBrowser)
{
	alarm[0] = 1;
}
