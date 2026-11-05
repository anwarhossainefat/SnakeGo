// Begin Step: check the window size every frame (it may have been resized or gone fullscreen)
fitToWindow();

// F switches fullscreen on and off
if (keyboard_check_pressed(ord("F")))
{
	fullscreenOn = !fullscreenOn;
	window_set_fullscreen(fullscreenOn);
}
