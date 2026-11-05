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

// Every 4th apple, spawn a watermelon
if (applesEatenCount % 4 == 0) 
{
    // Use the same safe spawning logic as your apple
    var bonusX = -16 + 32 * round(random_range(32, room_width - 32) / 32);
    var bonusY = -16 + 32 * round(random_range(32, room_height - 32) / 32);

    instance_create_layer(bonusX, bonusY, "Instances", obj_watermelon);
}