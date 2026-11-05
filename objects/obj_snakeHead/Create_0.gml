// --- LEVEL SETTINGS ---
// Work out which level we're on from the room
if (room == Room1)      level = 1;
else if (room == Room2) level = 2;
else                    level = 3;

totalLevels    = 3;
applesPerLevel = 10;   // Apples needed to clear a level

// Seconds per move: depends on the speed chosen in the menu and the level.
// The table is in obj_menu's Create event.
moveSpeed = global.levelSpeeds[global.speedIndex][level - 1];
global.paused = false;

moveTimer = round(moveSpeed * room_speed);

// --- MOVEMENT ---
Direction = "up";  // The direction the snake is actually moving
dirQueue  = [];    // Turns the player pressed that haven't happened yet (max 2)

// Add a turn to the queue (used by both the keyboard and swipes).
// Quick double turns (e.g. right then down) both happen, one per move.
queueTurn = function(_dir)
{
	if (array_length(dirQueue) >= 2) return;

	// Compare with the last queued turn (or the current direction if nothing is queued)
	var lastDir = (array_length(dirQueue) > 0) ? dirQueue[array_length(dirQueue) - 1] : Direction;

	// Ignore the same direction, or reversing into yourself
	var isReverse = (_dir == "up"    && lastDir == "down")
	             || (_dir == "down"  && lastDir == "up")
	             || (_dir == "left"  && lastDir == "right")
	             || (_dir == "right" && lastDir == "left");

	if (_dir != lastDir && !isReverse)
	{
		array_push(dirQueue, _dir);
	}
};

// Swipe tracking
swipeActive = false;
swipeX = 0;
swipeY = 0;

// --- SCORE / PROGRESS ---
applesEatenCount = 0;
points = 0;        // Apples eaten in this level
applePoints = 10 * global.speedMult[global.speedIndex];  // Faster speed = more points (watermelon points are set in obj_watermelon)

// Floating "+points" text shown where food is eaten
popupText   = "";
popupTimer  = 0;
popupX      = 0;
popupY      = 0;
popupColour = c_white;

// Stops the crash code running twice if the head hits two things at once
crashed = false;

// Particle system for the "eaten" bursts (drawn above the snake)
if (!variable_global_exists("ps") || !part_system_exists(global.ps))
{
	global.ps = part_system_create();
	part_system_depth(global.ps, -1000);
}

// --- BODY ---
startBodyParts = 3;

BodyPart[0] = obj_snakeHead;

for(i=1; i < startBodyParts; i+=1)
{
	BodyPart[i] = instance_create_layer(x, y+32*i, "Instances", obj_body);
}


//audio_play_sound(Sound1, 1000, true);
