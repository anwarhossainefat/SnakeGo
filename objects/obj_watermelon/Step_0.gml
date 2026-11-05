bonusTimer -= 1; // Count down every frame

if (bonusTimer <= 0) 
{
    instance_destroy(); // Disappear after 10 seconds
}