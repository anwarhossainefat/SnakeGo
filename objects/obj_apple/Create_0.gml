// Snap to grid logic
var gridSize = 32;
var validSpot = false;

// Keep looking for a spot until we find one that is empty
while (validSpot == false)
{
    // Generate random coordinates (Your original math)
    x = -16 + 32 * round(random_range(32, room_width - 32) / 32);
    y = -16 + 32 * round(random_range(32, room_height - 32) / 32);

    // Check if this spot touches a wall, obstacle, or snake body
    if (!place_meeting(x, y, obj_wall) && 
        !place_meeting(x, y, obj_obstacle) && 
        !place_meeting(x, y, obj_body) &&
        !place_meeting(x, y, obj_snakeHead))
    {
        validSpot = true; // Found a safe spot!
    }
}