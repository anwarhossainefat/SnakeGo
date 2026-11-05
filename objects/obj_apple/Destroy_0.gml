xPos = -16 + 32 * round(random_range(32, room_width - 32) / 32);
yPos = -16 + 32 * round(random_range(32, room_height - 32) / 32);

instance_create_layer(xPos, yPos, "Instances", obj_apple);