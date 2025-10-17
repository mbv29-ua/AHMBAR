INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

SECTION "Character Sprites", ROM0


load_cowboy_sprites::
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

init_player::
    call man_entity_alloc ; Deja en l el indice
    ld h, CMP_SPRIT_H
    ; Load sprite atributes
    ld a, PLAYER_START_Y
    ld [hl+], a
    ld a, PLAYER_START_X
    ld [hl+], a
    ld a, TILE_COWBOY
    ld [hl+], a
    xor a
    ld [hl], a
    ld hl, wPlayerDirection
    set 0, [hl]
    ret