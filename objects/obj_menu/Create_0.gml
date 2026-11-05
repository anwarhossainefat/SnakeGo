// --- ONE-TIME SETUP ---
// This runs the first time the menu opens (when the game starts).
// Coming back to the menu later keeps the chosen speed and high scores.
if (!variable_global_exists("speedIndex"))
{
    // All sprites (snake, food, blocks, font) are made in 3x detail and drawn at 1/3 scale,
    // so they stay sharp when the game is scaled up to fill a big window or screen.
    global.art = 1 / 3;

    // Phones and tablets: show touch hints (swipe/tap) instead of keyboard hints
    global.isTouch = (os_type == os_android || os_type == os_ios);
    global.rotateNeeded = false;   // set by obj_display when a phone is held upright

    // obj_display (persistent) scales the game to fit the window or browser, and handles F for fullscreen
    instance_create_depth(0, 0, 0, obj_display);

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
        { spr: spr_font_xs, lineH: 13.33, mid: 6.67,
          adv: [2.77, 3.54, 5.75, 7.08, 7.16, 11.05, 7.29, 3.58, 4.1, 4.1, 5.94, 7.4, 3.51, 5.12, 3.51, 4.17, 7.26, 4.65, 6.85, 7, 7.33, 6.92, 7.04, 6.34, 7.04, 7.04, 3.51, 3.62, 7.4, 7.4, 7.4, 5.98, 10.99, 8.01, 7.25, 8.1, 7.94, 6.66, 6.47, 8.24, 8.2, 3.05, 6.38, 7.73, 6.22, 10.15, 8.35, 8.45, 7.09, 8.5, 7.18, 7.16, 7.26, 8.09, 8.01, 11.22, 7.92, 7.85, 7.18, 4.1, 4.17, 4.1, 5.3, 5.16, 3.86, 6.32, 6.86, 6.41, 6.86, 6.51, 4.28, 6.88, 6.73, 2.88, 2.88, 6.26, 2.88, 9.91, 6.73, 6.7, 6.86, 6.86, 4.36, 6.04, 3.89, 6.73, 6.46, 9.23, 6.26, 6.47, 6.22, 5, 3.95, 5, 7.4, 3.51] },
        // 1 = S: Inter SemiBold 14px (normal text)
        { spr: spr_font_s, lineH: 17.33, mid: 8.5,
          adv: [3.53, 4.5, 7.32, 9.01, 9.1, 14.06, 9.28, 4.56, 5.22, 5.22, 7.55, 9.42, 4.46, 6.52, 4.46, 5.31, 9.23, 5.92, 8.72, 8.91, 9.32, 8.81, 8.95, 8.07, 8.96, 8.95, 4.46, 4.61, 9.42, 9.42, 9.42, 7.61, 13.98, 10.19, 9.23, 10.32, 10.11, 8.48, 8.23, 10.48, 10.44, 3.88, 8.11, 9.84, 7.92, 12.91, 10.63, 10.76, 9.03, 10.82, 9.14, 9.1, 9.24, 10.3, 10.19, 14.28, 10.08, 9.99, 9.14, 5.22, 5.31, 5.22, 6.74, 6.57, 4.92, 8.04, 8.73, 8.16, 8.73, 8.28, 5.44, 8.76, 8.57, 3.67, 3.67, 7.97, 3.67, 12.6, 8.57, 8.53, 8.73, 8.73, 5.56, 7.69, 4.94, 8.57, 8.22, 11.75, 7.96, 8.24, 7.92, 6.36, 5.03, 6.36, 9.42, 4.46] },
        // 2 = M: Inter Bold 17px (numbers, buttons, popups)
        { spr: spr_font_m, lineH: 21, mid: 10.5,
          adv: [4.03, 5.74, 9.38, 11.03, 11.13, 17.27, 11.42, 5.76, 6.41, 6.41, 9.51, 11.54, 5.68, 7.95, 5.68, 6.6, 11.46, 7.33, 10.71, 10.97, 11.49, 10.86, 11.04, 9.89, 11.06, 11.04, 5.68, 5.83, 11.54, 11.54, 11.54, 9.51, 17.28, 12.69, 11.25, 12.58, 12.28, 10.33, 9.98, 12.76, 12.7, 4.77, 9.94, 12.23, 9.61, 15.84, 12.96, 13.1, 11.02, 13.21, 11.17, 11.13, 11.35, 12.44, 12.69, 17.64, 12.55, 12.43, 11.29, 6.41, 6.6, 6.41, 8.28, 8.09, 6.21, 9.87, 10.72, 10, 10.72, 10.12, 6.77, 10.74, 10.58, 4.61, 4.61, 9.86, 4.61, 15.52, 10.58, 10.43, 10.72, 10.72, 6.92, 9.52, 6.22, 10.58, 10.19, 14.45, 9.86, 10.23, 9.73, 7.97, 6.32, 7.97, 11.54, 5.68] },
        // 3 = L: Inter Display ExtraBold 44px (titles)
        { spr: spr_font_l, lineH: 53.33, mid: 26.67,
          adv: [8.79, 11.34, 22.02, 27.95, 29.39, 42.95, 29.16, 12.24, 15.17, 15.17, 24.77, 29.31, 11.19, 19.88, 11.19, 16.69, 29.26, 17.64, 27.01, 27.65, 29.6, 26.75, 27.76, 24.81, 27.61, 27.76, 11.19, 11.28, 29.31, 29.31, 29.31, 25.74, 44.9, 32.46, 28.47, 32.01, 31.05, 27.24, 26.08, 32.46, 31.78, 11.86, 25.22, 31.07, 24.88, 39.98, 32.18, 32.85, 28.12, 32.85, 28.94, 29.39, 28.38, 31, 31.97, 44.71, 31.6, 31.22, 28.3, 15.17, 16.69, 15.17, 20.82, 21.29, 13.94, 24.96, 26.88, 25.01, 26.88, 25.16, 17.47, 26.88, 26.45, 11.52, 11.56, 24.98, 11.52, 39.68, 26.45, 26.1, 26.88, 26.88, 17.32, 23.7, 17.25, 26.45, 25.14, 37.21, 24.17, 25.14, 23.81, 20.3, 16.16, 20.3, 29.31, 11.19] }
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
            draw_sprite_ext(f.spr, g, round(px), py, _scale * global.art, _scale * global.art, 0, _col, _alpha);
            px += f.adv[g] * _scale;
        }
    });

    // Colours used across the game
    global.colText  = make_color_rgb(241, 245, 249);
    global.colSub   = make_color_rgb(148, 163, 184);
    global.colGreen = make_color_rgb(74, 222, 128);
    global.colGold  = make_color_rgb(250, 204, 21);

    // --- SOUND ---
    // Sound on/off is remembered between games (M key toggles it)
    ini_open("snakego_save.ini");
    global.soundOn = ini_read_real("settings", "sound", 1);
    ini_close();

    // The game makes its own retro sound effects in code instead of using sound files.
    // Each sound is a list of notes: [start frequency, end frequency, seconds].
    // Waves: 0 = sine, 1 = square, 2 = triangle, 3 = noise.
    global.makeSound = method(undefined, function(_notes, _wave, _vol)
    {
        var rate  = 22050;   // samples per second
        var total = 0;
        for (var n = 0; n < array_length(_notes); n++) total += round(_notes[n][2] * rate);

        var buf   = buffer_create(total * 2, buffer_fixed, 2);
        var phase = 0;

        for (var j = 0; j < array_length(_notes); j++)
        {
            var f0  = _notes[j][0];
            var f1  = _notes[j][1];
            var len = round(_notes[j][2] * rate);

            for (var s = 0; s < len; s++)
            {
                var t = s / len;
                phase += lerp(f0, f1, t) / rate;
                var p = phase - floor(phase);

                var v;
                if (_wave == 0)      v = sin(p * 2 * pi);
                else if (_wave == 1) v = (p < 0.5) ? 0.6 : -0.6;
                else if (_wave == 2) v = 1 - 4 * abs(p - 0.5);
                else                 v = random_range(-1, 1);

                // Quick fade-in, smooth fade-out for each note
                var env = min(1, s / (0.004 * rate)) * power(1 - t, 1.6);
                buffer_write(buf, buffer_s16, round(v * env * _vol * 32767));
            }
        }
        return audio_create_buffer_sound(buf, buffer_s16, rate, 0, total * 2, audio_mono);
    });

    global.sndEat     = global.makeSound([[620, 940, 0.08]], 2, 0.55);
    global.sndMelon   = global.makeSound([[880, 880, 0.06], [1175, 1175, 0.06], [1568, 1568, 0.10]], 2, 0.5);
    global.sndLevelUp = global.makeSound([[523, 523, 0.09], [659, 659, 0.09], [784, 784, 0.09], [1047, 1047, 0.18]], 1, 0.3);
    global.sndWin     = global.makeSound([[523, 523, 0.12], [659, 659, 0.12], [784, 784, 0.12], [1047, 1047, 0.12], [784, 784, 0.10], [1047, 1047, 0.40]], 1, 0.3);
    global.sndCrash   = global.makeSound([[240, 50, 0.40]], 1, 0.4);
    global.sndCrashFx = global.makeSound([[0, 0, 0.22]], 3, 0.35);
    global.sndTick    = global.makeSound([[1200, 1200, 0.03]], 2, 0.35);
    global.sndSelect  = global.makeSound([[660, 990, 0.12]], 2, 0.45);
    global.sndPause   = global.makeSound([[700, 500, 0.08]], 2, 0.4);

    // Play a sound only if sound is switched on
    global.playSound = method(undefined, function(_snd)
    {
        if (global.soundOn) audio_play_sound(_snd, 1, false);
    });

    // Switch sound on/off and remember the choice
    global.toggleSound = method(undefined, function()
    {
        global.soundOn = !global.soundOn;
        ini_open("snakego_save.ini");
        ini_write_real("settings", "sound", global.soundOn);
        ini_close();
        if (global.soundOn) audio_play_sound(global.sndTick, 1, false);
    });

    // --- EFFECTS ---
    // A small burst of dots when food is eaten (one particle type, reused everywhere)
    global.ptBurst = part_type_create();
    part_type_shape(global.ptBurst, pt_shape_disk);
    part_type_size(global.ptBurst, 0.05, 0.11, -0.002, 0);
    part_type_speed(global.ptBurst, 1.2, 3.0, -0.09, 0);
    part_type_direction(global.ptBurst, 0, 359, 0, 0);
    part_type_alpha2(global.ptBurst, 1, 0);
    part_type_life(global.ptBurst, 16, 28);
}
