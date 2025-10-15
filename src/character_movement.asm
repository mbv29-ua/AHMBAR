INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

SECTION "Character Movement", ROM0

move_character::
    call read_pad

    ld hl, PRESSED_BUTTONS
    bit DPAD_DOWN, [hl]
    jr z, .next1
    ld a, [Player.wPlayerY]
    dec a
    ld [Player.wPlayerY], a

    .next1:
    bit DPAD_UP, [hl]
    jr z, .next2
    ld a, [Player.wPlayerY]
    inc a
    ld [Player.wPlayerY], a

    .next2:
    bit DPAD_LEFT, [hl]
    jr z, .next3
    ld a, [Player.wPlayerX]
    inc a
    ld [Player.wPlayerX], a

    .next3:
    bit DPAD_RIGHT, [hl]
    jr z, .end
    ld a, [Player.wPlayerX]
    dec a
    ld [Player.wPlayerX], a

    .end:
    ret
