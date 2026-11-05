// Menu layout (shared with Draw GUI):
//   speed rows at y = 168, 204, 240   ·   mode/level picker at y = 290   ·   Play button at y = 336

// --- KEYBOARD ---
// Up/Down (or W/S): choose a speed
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

// Left/Right (or A/D): Campaign, or Free play on level 1, 2, 3 ...
var pick = 0;
if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"))) pick = -1;
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) pick = 1;

var startGame = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

// --- TAPS / CLICKS ---
if (device_mouse_check_button_pressed(0, mb_left) && !global.rotateNeeded)
{
    // Mouse/finger position. Room coordinates match the menu layout exactly (both are 672 x 416),
    // and GameMaker keeps them correct on every platform, including the web version.
    var mx = device_mouse_x(0);
    var my = device_mouse_y(0);
    var cx = room_width / 2;

    // Tap a speed to choose it
    for (var i = 0; i < 3; i++)
    {
        var yy = 168 + i * 36;
        if (point_in_rectangle(mx, my, cx - 152, yy - 16, cx + 152, yy + 16) && global.speedIndex != i)
        {
            global.speedIndex = i;
            global.playSound(global.sndTick);
        }
    }

    // Tap the arrows on the mode picker (or its middle, to go forward)
    if (point_in_rectangle(mx, my, cx - 190, 272, cx - 110, 308)) pick = -1;
    else if (point_in_rectangle(mx, my, cx - 110, 272, cx + 190, 308)) pick = 1;

    // Tap the Play button
    if (point_in_rectangle(mx, my, cx - 90, 316, cx + 90, 356)) startGame = true;

    // Tap "Sound on/off" in the top-right corner
    if (point_in_rectangle(mx, my, room_width - 110, 0, room_width, 32)) global.toggleSound();
}

// Change the mode/level, wrapping around: Campaign -> Level 1 -> ... -> Level 8 -> Campaign
if (pick != 0)
{
    var choices = global.levelCount + 1;
    global.menuChoice = (global.menuChoice + pick + choices) mod choices;
    global.playSound(global.sndTick);
}

// --- START ---
if (startGame)
{
    global.playSound(global.sndSelect);
    global.freePlay   = (global.menuChoice > 0);
    global.level      = global.freePlay ? global.menuChoice : 1;
    global.totalScore = 0;
    global.gameWon    = false;
    room_goto(rm_game);
}

// M switches sound on/off
if (keyboard_check_pressed(ord("M")))
{
    global.toggleSound();
}
