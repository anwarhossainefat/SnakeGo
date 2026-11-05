// Pick a random empty cell on the snake's 32px grid.
// Columns 1-20 (x 32..640) and rows 2-12 (y 64..384).
// Rows 0-1 are the HUD bar and top wall, so food never appears under the text.
var cols = (room_width div 32) - 1;
var rows = (room_height div 32) - 1;
var validSpot = false;

while (!validSpot)
{
    x = 32 * irandom_range(1, cols);
    y = 32 * irandom_range(2, rows);

    // Only accept the cell if nothing else is there
    if (!place_meeting(x, y, obj_wall) &&
        !place_meeting(x, y, obj_obstacle) &&
        !place_meeting(x, y, obj_body) &&
        !place_meeting(x, y, obj_snakeHead))
    {
        validSpot = true;
    }
}
