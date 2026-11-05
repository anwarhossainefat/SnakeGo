// Begin Step: check the window size every frame (it may have been resized or gone fullscreen)
fitToWindow();

// On a phone or tablet held upright, ask the player to turn it sideways (the game waits meanwhile)
global.rotateNeeded = global.isTouch && (lastH > lastW);

// F switches fullscreen on and off
if (keyboard_check_pressed(ord("F")))
{
	fullscreenOn = !fullscreenOn;
	window_set_fullscreen(fullscreenOn);
}
