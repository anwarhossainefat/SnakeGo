// Calculate bonus: (Remaining Time / Total Time) * Max Points
// If you eat it instantly, you get ~500. If you eat it at the last second, you get ~10.
var speedBonus = round((other.bonusTimer / (10 * room_speed)) * other.maxBonus);

global.totalScore += speedBonus;

// Optional: Add to 'points' if you want it to help level progression
// points += 1; 

instance_destroy(other); // Remove the watermelon