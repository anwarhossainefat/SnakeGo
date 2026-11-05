draw_self();

// Floating "+points" text that drifts up and fades where food was eaten
if (popupTimer > 0)
{
	var progress = 1 - popupTimer / room_speed; // 0 at start, 1 at the end

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_alpha(1 - progress);
	draw_set_color(popupColour);

	draw_text(popupX, popupY - 20 * progress, popupText);

	// Reset drawing settings
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
