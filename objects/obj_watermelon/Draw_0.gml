if (bonusTimer > 3 * room_speed || (bonusTimer % 10 < 5)) 
{
    draw_self();
}

// Draw a small timer bar above the watermelon
draw_set_color(c_yellow);
draw_rectangle(x - 16, y - 24, x - 16 + (32 * (bonusTimer / (10 * room_speed))), y - 20, false);