INCLUDE "constants.inc"

SECTION "Character Sprites", ROM0

Cowboy_Sprites::
    DB $00,$00,$3C,$3C,$7E,$7E,$FF,$FF
    DB $FF,$FF,$7E,$7E,$3C,$3C,$00,$00
    DB $00,$00,$18,$18,$3C,$3C,$7E,$7E
    DB $7E,$7E,$3C,$3C,$18,$18,$00,$00
Cowboy_Sprites_End::

Load_Character_Sprites::
    ld hl, Cowboy_Sprites
    ld de, $8100
    ld bc, Cowboy_Sprites_End - Cowboy_Sprites
    call Copy_Memory
    ret

Init_Player::
    ld a, PLAYER_START_X
    ld [wPlayerX], a
    ld a, PLAYER_START_Y
    ld [wPlayerY], a
    ret

Render_Player::
    ld hl, OAM_PLAYER
    ld a, [wPlayerY]
    ld [hl+], a
    ld a, [wPlayerX]
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    xor a
    ld [hl], a
    ret