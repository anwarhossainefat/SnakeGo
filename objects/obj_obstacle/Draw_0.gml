// The obstacle is a stretched instance, so fill its area with one rounded block per grid cell
for (var xx = bbox_left + 16; xx < bbox_right; xx += 32)
{
    for (var yy = bbox_top + 16; yy < bbox_bottom; yy += 32)
    {
        draw_sprite(spr_block, 0, xx, yy);
    }
}
