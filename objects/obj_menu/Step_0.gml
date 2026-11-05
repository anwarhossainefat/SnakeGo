// Choose a speed with Up/Down (or W/S)
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
{
    global.speedIndex = max(0, global.speedIndex - 1);
    global.playSound(global.sndTick);
}

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
{
    global.speedIndex = min(2, global.speedIndex + 1);
    global.playSound(global.sndTick);
}

// --- TAPS / CLICKS ---
var startGame = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (device_mouse_check_button_pressed(0, mb_left) && !global.rotateNeeded)
{
    // Mouse/finger position. Room coordinates match the menu/HUD layout exactly (both are 672 x 416),
    // and GameMaker keeps them correct on every platform, including the web version.
    var mx = device_mouse_x(0);
    var my = device_mouse_y(0);
    var cx = room_width / 2;

    // Tap a speed to choose it
    for (var i = 0; i < 3; i++)
    {
        var yy = 204 + i * 40;
        if (point_in_rectangle(mx, my, cx - 152, yy - 18, cx + 152, yy + 18) && global.speedIndex != i)
        {
            global.speedIndex = i;
            global.playSound(global.sndTick);
        }
    }

    // Tap the Play button
    if (point_in_rectangle(mx, my, cx - 90, 318, cx + 90, 358)) startGame = true;

    // Tap "Sound on/off" in the top-right corner
    if (point_in_rectangle(mx, my, room_width - 110, 0, room_width, 32)) global.toggleSound();
}

// Start a new game with Enter, Space, or the Play button
if (startGame)
{
    global.playSound(global.sndSelect);
    global.totalScore = 0;
    global.gameWon    = false;
    room_goto(Room1);
}

// M switches sound on/off
if (keyboard_check_pressed(ord("M")))
{
    global.toggleSound();
}
