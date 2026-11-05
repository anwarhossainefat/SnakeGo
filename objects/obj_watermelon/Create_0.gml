// Pick a random empty cell on the snake's 32px grid (same as apples)
var cols = (room_width div 32) - 1;
var rows = (room_height div 32) - 1;
var validSpot = false;

while (!validSpot)
{
    x = 32 * irandom_range(1, cols);
    y = 32 * irandom_range(2, rows); // Row 2+ keeps it below the HUD bar

    // Not on a wall, obstacle, the snake, or the apple
    if (!place_meeting(x, y, obj_wall) &&
        !place_meeting(x, y, obj_obstacle) &&
        !place_meeting(x, y, obj_body) &&
        !place_meeting(x, y, obj_snakeHead) &&
        !place_meeting(x, y, obj_apple))
    {
        validSpot = true;
    }
}

bonusTimer = 10 * room_speed; // 10 seconds worth of frames
// Points depend on how fast you eat it, times the speed multiplier from the menu
var mult = global.speedMult[global.speedIndex];
maxBonus = 50 * mult;         // Points if eaten instantly
minBonus = 10 * mult;         // Points if eaten at the last second
