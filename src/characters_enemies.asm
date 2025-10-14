INCLUDE "constants.inc"

SECTION "Character Sprites", ROM0



Load_Character_Sprites::
    ; Cargar sprite de la bola negra (jugador)
    ld hl, Cowboy_Sprites
    ld de, $8100
    ld bc, Cowboy_Sprites_End - Cowboy_Sprites
    call memcpy_65536

    ; Cargar sprite del cuadrado objetivo
    ld hl, Goal_Sprite
    ld de, $8110
    ld bc, Goal_Sprite_End - Goal_Sprite
    call memcpy_65536
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