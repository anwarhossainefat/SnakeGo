// Pick a random empty cell on the snake's 32px grid.
// Columns 1-20 (x 32..640) and rows 2-12 (y 64..384).
// Rows 0-1 are the HUD bar and top wall, so food never appears under the text.
var cols = (room_width div 32) - 1;
var rows = (room_height div 32) - 1;

// Is this cell free of walls, blocks and the snake?
var cellFree = function(_x, _y)
{
    return !place_meeting(_x, _y, obj_wall) &&
           !place_meeting(_x, _y, obj_obstacle) &&
           !place_meeting(_x, _y, obj_body) &&
           !place_meeting(_x, _y, obj_snakeHead);
};

// 1) Try random cells (fast, and almost always works)
var found = false;
for (var tries = 0; tries < 400 && !found; tries++)
{
    x = 32 * irandom_range(1, cols);
    y = 32 * irandom_range(2, rows);
    found = cellFree(x, y);
}

// 2) If the board is very full (long snake in Free play), check every cell in turn
for (var cx = 1; cx <= cols && !found; cx++)
{
    for (var cy = 2; cy <= rows && !found; cy++)
    {
        x = 32 * cx;
        y = 32 * cy;
        found = cellFree(x, y);
    }
}

// 3) No room left at all: remove this apple without spawning another one
if (!found) instance_destroy(id, false);
