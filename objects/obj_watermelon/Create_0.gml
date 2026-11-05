// Pick a random empty cell on the snake's 32px grid (same as apples), also avoiding the apple
var cols = (room_width div 32) - 1;
var rows = (room_height div 32) - 1;

var cellFree = function(_x, _y)
{
    return !place_meeting(_x, _y, obj_wall) &&
           !place_meeting(_x, _y, obj_obstacle) &&
           !place_meeting(_x, _y, obj_body) &&
           !place_meeting(_x, _y, obj_snakeHead) &&
           !place_meeting(_x, _y, obj_apple);
};

// Try random cells; if the board is too full, simply skip this watermelon
var found = false;
for (var tries = 0; tries < 400 && !found; tries++)
{
    x = 32 * irandom_range(1, cols);
    y = 32 * irandom_range(2, rows); // Row 2+ keeps it below the HUD bar
    found = cellFree(x, y);
}
if (!found) instance_destroy();

bonusTimer = 10 * room_speed; // 10 seconds worth of frames
// Points depend on how fast you eat it, times the speed multiplier from the menu
var mult = global.speedMult[global.speedIndex];
maxBonus = 50 * mult;         // Points if eaten instantly
minBonus = 10 * mult;         // Points if eaten at the last second
