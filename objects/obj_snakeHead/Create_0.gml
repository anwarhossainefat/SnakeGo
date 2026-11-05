// --- LEVEL SETTINGS ---
// Work out which level we're on from the room
if (room == Room1)      level = 1;
else if (room == Room2) level = 2;
else                    level = 3;

totalLevels    = 3;
applesPerLevel = 10;   // Apples needed to clear a level

// Seconds per move for each level (smaller = faster). Change these to tune difficulty.
if (level == 1)      moveSpeed = 0.25;
else if (level == 2) moveSpeed = 0.18;
else                 moveSpeed = 0.13;

moveTimer = round(moveSpeed * room_speed);

// --- MOVEMENT ---
Direction = "up";  // The direction the snake is actually moving
dirQueue  = [];    // Turns the player pressed that haven't happened yet (max 2)

// --- SCORE / PROGRESS ---
applesEatenCount = 0;
points = 0;        // Apples eaten in this level

// --- BODY ---
startBodyParts = 3;

BodyPart[0] = obj_snakeHead;

for(i=1; i < startBodyParts; i+=1)
{
	BodyPart[i] = instance_create_layer(x, y+32*i, "Instances", obj_body);
}


//audio_play_sound(Sound1, 1000, true);
