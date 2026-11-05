// --- ONE-TIME SETUP ---
// This runs the first time the menu opens (when the game starts).
// Coming back to the menu later keeps the chosen speed and high scores.
if (!variable_global_exists("speedIndex"))
{
    // Speed options: 0 = Slow, 1 = Normal, 2 = Fast
    global.speedNames = ["Slow", "Normal", "Fast"];
    global.speedMult  = [1, 2, 3];   // Points multiplier for each speed
    global.speedIndex = 1;           // Start on "Normal"

    // Seconds per move for Level 1, 2, 3 at each speed (smaller = faster)
    global.levelSpeeds = [
        [0.30, 0.22, 0.16],   // Slow
        [0.25, 0.18, 0.13],   // Normal
        [0.18, 0.13, 0.09]    // Fast
    ];

    // Load the saved high score for each speed (0 if never played)
    global.highScores = [0, 0, 0];
    ini_open("snakego_save.ini");
    for (var i = 0; i < 3; i++)
    {
        global.highScores[i] = ini_read_real("highscores", global.speedNames[i], 0);
    }
    ini_close();

    global.totalScore = 0;
    global.gameWon    = false;
    global.paused     = false;

    // --- TEXT ---
    // The game draws text with its own Inter font, stored as glyph sprites
    // (spr_font_xs/s/m/l, one frame per character), so it looks the same on Mac and in the browser.
    // Each font: the glyph sprite, line height, the "middle" of capital letters, and how far
    // to move right after each character (adv). Characters are ASCII 32-126, plus "·" at the end.
    global.fonts = [
        // 0 = XS: Inter SemiBold 11px (small labels, help text)
        { spr: spr_font_xs, lineH: 14, mid: 7,
          adv: [2.77, 3.53, 5.75, 7.08, 7.16, 11.05, 7.28, 3.58, 4.11, 4.11, 5.94, 7.41, 3.5, 5.12, 3.5, 4.17, 7.25, 4.66, 6.86, 7, 7.33, 6.92, 7.03, 6.34, 7.05, 7.03, 3.5, 3.62, 7.41, 7.41, 7.41, 5.98, 10.98, 8, 7.25, 8.11, 7.94, 6.66, 6.47, 8.23, 8.2, 3.05, 6.38, 7.73, 6.22, 10.14, 8.36, 8.45, 7.09, 8.5, 7.17, 7.16, 7.27, 8.09, 8, 11.22, 7.92, 7.84, 7.17, 4.11, 4.17, 4.11, 5.3, 5.16, 3.86, 6.31, 6.86, 6.41, 6.86, 6.5, 4.28, 6.88, 6.73, 2.88, 2.88, 6.27, 2.88, 9.91, 6.73, 6.7, 6.86, 6.86, 4.36, 6.05, 3.89, 6.73, 6.45, 9.23, 6.25, 6.47, 6.22, 5, 3.95, 5, 7.41, 3.5] },
        // 1 = S: Inter SemiBold 14px (normal text)
        { spr: spr_font_s, lineH: 18, mid: 8.5,
          adv: [3.53, 4.5, 7.33, 9.02, 9.11, 14.06, 9.28, 4.56, 5.22, 5.22, 7.55, 9.42, 4.47, 6.52, 4.47, 5.31, 9.23, 5.92, 8.72, 8.91, 9.33, 8.81, 8.95, 8.06, 8.97, 8.95, 4.47, 4.61, 9.42, 9.42, 9.42, 7.61, 13.98, 10.19, 9.23, 10.31, 10.11, 8.48, 8.23, 10.48, 10.44, 3.88, 8.11, 9.84, 7.92, 12.91, 10.62, 10.77, 9.03, 10.83, 9.14, 9.11, 9.25, 10.3, 10.19, 14.28, 10.08, 9.98, 9.14, 5.22, 5.31, 5.22, 6.73, 6.56, 4.92, 8.05, 8.73, 8.16, 8.73, 8.28, 5.44, 8.75, 8.58, 3.67, 3.67, 7.97, 3.67, 12.61, 8.56, 8.53, 8.73, 8.73, 5.56, 7.69, 4.94, 8.58, 8.22, 11.75, 7.97, 8.23, 7.92, 6.36, 5.03, 6.36, 9.42, 4.47] },
        // 2 = M: Inter Bold 17px (numbers, buttons, popups)
        { spr: spr_font_m, lineH: 22, mid: 10.5,
          adv: [4.03, 5.75, 9.38, 11.03, 11.12, 17.27, 11.42, 5.77, 6.41, 6.41, 9.5, 11.53, 5.67, 7.95, 5.67, 6.59, 11.47, 7.33, 10.7, 10.97, 11.5, 10.86, 11.05, 9.89, 11.06, 11.05, 5.67, 5.83, 11.53, 11.53, 11.53, 9.52, 17.28, 12.69, 11.25, 12.58, 12.28, 10.33, 9.98, 12.77, 12.7, 4.77, 9.94, 12.23, 9.61, 15.84, 12.95, 13.09, 11.02, 13.2, 11.17, 11.12, 11.34, 12.44, 12.69, 17.64, 12.55, 12.42, 11.3, 6.41, 6.59, 6.41, 8.28, 8.09, 6.2, 9.88, 10.72, 10, 10.72, 10.12, 6.77, 10.73, 10.58, 4.61, 4.61, 9.86, 4.61, 15.52, 10.58, 10.42, 10.72, 10.72, 6.92, 9.52, 6.22, 10.58, 10.19, 14.45, 9.86, 10.23, 9.73, 7.97, 6.31, 7.97, 11.53, 5.67] },
        // 3 = L: Inter Display ExtraBold 44px (titles)
        { spr: spr_font_l, lineH: 54, mid: 27,
          adv: [8.78, 11.34, 22.02, 27.95, 29.39, 42.95, 29.16, 12.25, 15.17, 15.17, 24.77, 29.31, 11.19, 19.88, 11.19, 16.69, 29.27, 17.64, 27, 27.66, 29.61, 26.75, 27.77, 24.81, 27.61, 27.77, 11.19, 11.28, 29.31, 29.31, 29.31, 25.73, 44.91, 32.47, 28.47, 32.02, 31.05, 27.25, 26.08, 32.47, 31.78, 11.86, 25.22, 31.06, 24.88, 39.98, 32.19, 32.84, 28.12, 32.84, 28.94, 29.39, 28.38, 31, 31.97, 44.7, 31.61, 31.22, 28.3, 15.17, 16.69, 15.17, 20.81, 21.3, 13.94, 24.97, 26.88, 25.02, 26.88, 25.16, 17.47, 26.88, 26.45, 11.52, 11.56, 24.98, 11.52, 39.69, 26.45, 26.11, 26.88, 26.88, 17.31, 23.7, 17.25, 26.45, 25.14, 37.22, 24.17, 25.14, 23.81, 20.3, 16.16, 20.3, 29.31, 11.19] }
    ];

    // Width in pixels of a string in one of the fonts above
    global.textWidth = method(undefined, function(_str, _font, _scale = 1)
    {
        var f = global.fonts[_font];
        var w = 0;
        for (var i = 1; i <= string_length(_str); i++)
        {
            var o = ord(string_char_at(_str, i));
            var g = (o == 183) ? 95 : o - 32;   // 183 is "·"
            if (g < 0 || g > 95) g = 31;        // anything unknown becomes "?"
            w += f.adv[g];
        }
        return w * _scale;
    });

    // Draw a string. Use it like draw_text, but with a font number, colour and alignment:
    // global.drawText(x, y, "Hello", 1, c_white, fa_center, fa_middle);
    global.drawText = method(undefined, function(_x, _y, _str, _font, _col = c_white, _halign = fa_left, _valign = fa_top, _alpha = 1, _scale = 1)
    {
        var f = global.fonts[_font];
        var px = _x;
        if (_halign == fa_center) px -= global.textWidth(_str, _font, _scale) / 2;
        if (_halign == fa_right)  px -= global.textWidth(_str, _font, _scale);
        var py = _y;
        if (_valign == fa_middle) py -= f.mid * _scale;
        if (_valign == fa_bottom) py -= f.lineH * _scale;
        py = round(py);

        for (var i = 1; i <= string_length(_str); i++)
        {
            var o = ord(string_char_at(_str, i));
            var g = (o == 183) ? 95 : o - 32;
            if (g < 0 || g > 95) g = 31;
            draw_sprite_ext(f.spr, g, round(px), py, _scale, _scale, 0, _col, _alpha);
            px += f.adv[g] * _scale;
        }
    });

    // Colours used across the game
    global.colText  = make_color_rgb(241, 245, 249);
    global.colSub   = make_color_rgb(148, 163, 184);
    global.colGreen = make_color_rgb(74, 222, 128);
    global.colGold  = make_color_rgb(250, 204, 21);
}
