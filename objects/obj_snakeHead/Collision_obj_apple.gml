points += 1;
global.totalScore += applePoints;

// Show "+10" where the apple was
popupText   = "+" + string(applePoints);
popupTimer  = room_speed; // 1 second
popupX      = other.x;
popupY      = other.y;
popupColour = global.colText;

// A little red burst where the apple was
part_particles_create_colour(global.ps, other.x, other.y, global.ptBurst, make_color_rgb(239, 68, 68), 10);

// Grow the snake: add a new body part at the tail
var newBodyX = BodyPart[startBodyParts + points - 2].x;
var newBodyY = BodyPart[startBodyParts + points - 2].y;
BodyPart[startBodyParts + points - 1] = instance_create_layer(newBodyX, newBodyY, "Instances", obj_body);

// Destroy the apple (its Destroy event spawns the next one)
instance_destroy(other);

// --- LEVEL PROGRESSION ---
// Eating applesPerLevel apples (set in Create) completes a level
if (points >= applesPerLevel)
{
    if (room_next(room) == rm_gameover)
    {
        // That was the last level: the player wins!
        global.gameWon = true;
        global.playSound(global.sndWin);
        room_goto(rm_gameover);
    }
    else
    {
        global.playSound(global.sndLevelUp);
        room_goto_next(); // Go to Level 2 or 3
    }

    exit; // The level is over, so skip the watermelon code below
}

// Normal apple (the level isn't over)
global.playSound(global.sndEat);

applesEatenCount += 1;

// Every 4th apple, spawn a watermelon (only if there isn't one already).
// Its Create event picks a free grid cell.
if (applesEatenCount % 4 == 0 && !instance_exists(obj_watermelon))
{
    instance_create_layer(0, 0, "Instances", obj_watermelon);
}
