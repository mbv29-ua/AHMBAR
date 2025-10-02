include "constants.inc"

SECTION "Character Sprites", ROM0

Cowboy_Sprites::
    DB $00,$00,$00,$00,$01,$01,$03,$03
    DB $01,$00,$00,$03,$06,$01,$0F,$00
    DB $03,$00,$03,$00,$03,$00,$03,$03
    DB $00,$03,$00,$03,$00,$02,$00,$02
    DB $00,$00,$00,$00,$80,$80,$C0,$C0
    DB $80,$00,$00,$C0,$60,$80,$70,$80
    DB $C0,$10,$C8,$0F,$C8,$C8,$C0,$C0
    DB $00,$C0,$00,$40,$00,$40,$00,$40
Cowboy_Sprites_End::

Load_Character_Sprites::
    ld hl, Cowboy_Sprites
    ld de, $8000 + (TILE_COWBOY * 16)
    ld bc, Cowboy_Sprites_End - Cowboy_Sprites
    call Copy_Memory
    ret

Init_Player::
    ld a, PLAYER_START_X
    ld [wPlayerX], a
    ld a, PLAYER_START_Y
    ld [wPlayerY], a
    xor a
    ld [wPlayerVelY], a
    ld a, 1
    ld [wPlayerGrounded], a
    ret

Render_Player::
    ld hl, OAM_PLAYER
    ld a, [wPlayerY]
    ld [hl+], a
    ld a, [wPlayerX]
    ld [hl+], a
    ld a, TILE_COWBOY
    ld [hl+], a
    xor a
    ld [hl], a
    ret