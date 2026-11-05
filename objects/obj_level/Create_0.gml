// =====================================================================
// obj_level: builds the current level in rm_game from its map in global.levels
// (the maps are in obj_menu's Create event). Runs at the start of every level.
// Order matters: walls and blocks first, then the snake, then the apple
// (so the apple never appears inside something).
// =====================================================================
var L = global.levels[global.level - 1];

// --- Border walls (only on levels that have them; otherwise the snake wraps around) ---
if (L.walls)
{
	var w;
	w = instance_create_layer(0, 224, "Instances", obj_wall);   w.image_yscale = 13;   // left
	w = instance_create_layer(672, 224, "Instances", obj_wall); w.image_yscale = 13;   // right
	w = instance_create_layer(336, 32, "Instances", obj_wall);  w.image_xscale = 20;   // top (under the HUD bar)
	w = instance_create_layer(336, 416, "Instances", obj_wall); w.image_xscale = 20;   // bottom
}

// --- Blocks, and where the snake starts ---
// Map columns 1..20 are x = 32..640; map rows 1..11 are y = 64..384.
var startX = 96;
var startY = 352;
for (var r = 0; r < array_length(L.map); r++)
{
	var rowText = L.map[r];
	for (var c = 1; c <= string_length(rowText); c++)
	{
		var ch = string_char_at(rowText, c);
		var cellX = 32 * c;
		var cellY = 32 * (r + 2);

		if (ch == "#") instance_create_layer(cellX, cellY, "Instances", obj_obstacle);
		if (ch == "S")
		{
			startX = cellX;
			startY = cellY;
		}
	}
}

// --- The snake (its Create event adds the body behind the head) and the first apple ---
instance_create_layer(startX, startY, "Instances", obj_snakeHead);
instance_create_layer(0, 0, "Instances", obj_apple);
