applesEatenCount = 0;

moveSpeed = 0.5; //The smaller, the faster
moveTimer = moveSpeed * room_speed
Direction = "up";

points = 0;
startBodyParts = 3;

BodyPart[0] = obj_snakeHead;

for(i=1; i < startBodyParts; i+=1)
{
	BodyPart[i] = instance_create_layer(x, y+32*i, "Instances", obj_body);
}


//audio_play_sound(Sound1, 1000, true);