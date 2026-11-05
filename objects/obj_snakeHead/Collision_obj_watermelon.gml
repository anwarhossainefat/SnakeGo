// Bonus depends on how fast you reach it: (time left / total time) * max points.
// Eat it right away for 5 points; at the last second you still get 1.
var speedBonus = max(1, round((other.bonusTimer / (10 * room_speed)) * other.maxBonus));

global.totalScore += speedBonus;

instance_destroy(other); // Remove the watermelon
