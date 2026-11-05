// Tap or click anywhere to go back to the menu (after a short delay)
if (readyTimer > 0)
{
    readyTimer--;
    exit;
}

if (device_mouse_check_button_pressed(0, mb_left) && !global.rotateNeeded)
{
    room_goto(rm_menu);
}
