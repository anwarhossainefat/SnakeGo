points += 1;
global.totalScore += 1;

// Grow the snake (Your original logic)
var newBodyX = BodyPart[startBodyParts + points - 2].x;
var newBodyY = BodyPart[startBodyParts + points - 2].y;
BodyPart[startBodyParts + points - 1] = instance_create_layer(newBodyX, newBodyY, "Instances", obj_body);

// Destroy the apple (which triggers the Create event of a new apple)
instance_destroy(other);

// --- NEW CODE: LEVEL PROGRESSION ---
// Check if player collected 10 fruits 
if (points >= 10) 
{
    if (room_exists(room_next(room)))
    {
        room_goto_next(); // Go to Level 2 or 3
    }
    else
    {
        // If there are no more rooms, you win!
        show_message("You Win!");
        game_restart();
    }
}

applesEatenCount += 1;

// Every 4th apple, spawn a watermelon (only if there isn't one already).
// Its Create event picks a free grid cell.
if (applesEatenCount % 4 == 0 && !instance_exists(obj_watermelon))
{
    instance_create_layer(0, 0, "Instances", obj_watermelon);
}