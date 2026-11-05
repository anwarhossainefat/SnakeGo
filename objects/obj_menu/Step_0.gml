// Choose a speed with Up/Down (or W/S)
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
{
    global.speedIndex = max(0, global.speedIndex - 1);
}

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
{
    global.speedIndex = min(2, global.speedIndex + 1);
}

// Start a new game with Enter or Space
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
{
    global.totalScore = 0;
    global.gameWon    = false;
    room_goto(Room1);
}
