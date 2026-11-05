// --- LEVEL SETTINGS ---
// The level number and maps come from the menu (see obj_menu Create); obj_level built this level.
level          = global.level;
totalLevels    = global.levelCount;
levelName      = global.levels[level - 1].name;
applesPerLevel = 10;   // Apples needed to clear a level (in Campaign; Free play never ends)

// Seconds per move: the menu speed times this level's factor (later levels are faster)
var factor = global.levelFactor[min(level, array_length(global.levelFactor)) - 1];
moveSpeed = global.speedBase[global.speedIndex] * factor;
global.paused = false;

// "Get ready" countdown at the start of every level: 5 seconds, or until any key/tap
readyTimer = 5 * room_speed;

moveTimer = round(moveSpeed * room_speed);

// --- MOVEMENT ---
Direction = "right";  // The direction the snake is actually moving (every level starts facing right)
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

// Highlighted button in the pause menu: 0 = Resume, 1 = Restart, 2 = Main menu
pauseFocus = 0;

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
	BodyPart[i] = instance_create_layer(x - 32 * i, y, "Instances", obj_body);   // body behind the head, to the left
}


//audio_play_sound(Sound1, 1000, true);
