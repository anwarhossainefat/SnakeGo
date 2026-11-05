// The faster you reach the watermelon, the more points you get.
// timeLeft goes from 1 (just appeared) down to 0 (about to vanish),
// so the bonus slides from maxBonus (50) down to minBonus (10).
var timeLeft   = other.bonusTimer / (10 * room_speed);
var speedBonus = round(other.minBonus + (other.maxBonus - other.minBonus) * timeLeft);

global.totalScore += speedBonus;

// Show "+43" (or whatever you earned) in yellow where the watermelon was
popupText   = "+" + string(speedBonus);
popupTimer  = room_speed; // 1 second
popupX      = other.x;
popupY      = other.y;
popupColour = global.colGold;

instance_destroy(other); // Remove the watermelon
