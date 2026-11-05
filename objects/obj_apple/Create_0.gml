// Pick a random empty cell on the snake's 32px grid.
// Columns 1-20 and rows 1-11 (x 32..640, y 32..352), which is inside the walls.
var cols = (room_width div 32) - 1;
var rows = (room_height div 32) - 1;
var validSpot = false;

while (!validSpot)
{
    x = 32 * irandom_range(1, cols);
    y = 32 * irandom_range(1, rows);

    // Only accept the cell if nothing else is there
    if (!place_meeting(x, y, obj_wall) &&
        !place_meeting(x, y, obj_obstacle) &&
        !place_meeting(x, y, obj_body) &&
        !place_meeting(x, y, obj_snakeHead))
    {
        validSpot = true;
    }
}