INCLUDE "constants.inc"

SECTION "Character Sprites", ROM0

Cowboy_Sprites::
    ; Bola negra (jugador)
    DB $00,$00,$3C,$3C,$7E,$7E,$FF,$FF
    DB $FF,$FF,$7E,$7E,$3C,$3C,$00,$00
Cowboy_Sprites_End::

Goal_Sprite::
    ; Cuadrado objetivo (meta del nivel)
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
Goal_Sprite_End::

Load_Character_Sprites::
    ; Cargar sprite de la bola negra (jugador)
    ld hl, Cowboy_Sprites
    ld de, $8100
    ld bc, Cowboy_Sprites_End - Cowboy_Sprites
    call Copy_Memory

    ; Cargar sprite del cuadrado objetivo
    ld hl, Goal_Sprite
    ld de, $8110
    ld bc, Goal_Sprite_End - Goal_Sprite
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