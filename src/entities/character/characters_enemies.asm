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

;init_player::
;    call man_entity_alloc ; Deja en l el indice
;    push de             ; Guardar índice del jugador
;    ld h, CMP_SPRIT_H
;    ; Load sprite atributes
;    ld a, PLAYER_START_Y
;    ld [hl+], a
;    ld a, PLAYER_START_X
;    ld [hl+], a
;    ld a, TILE_COWBOY
;    ld [hl+], a
;    xor a
;    ld [hl], a
;    ld hl, wPlayerDirection
;    set 0, [hl]
;
;    ; Inicializar flags de física (GROUNDED = activado al inicio)
;    pop de              ; Recuperar índice del jugador (en E)
;    ld h, CMP_PHYS_H
;    ld a, e
;    add PHY_FLAGS
;    ld l, a
;    ld a, (1 << PHY_FLAG_GROUNDED)  ; Solo GROUNDED activado
;    ld [hl], a
;    ret

; ESTE ES EL BUENO, LUEGO LO DESCOMENTAMOS
init_player::
    call man_entity_alloc ; Deja en l el indice

    ld b, PLAYER_START_Y ; Y coordinate
    ld c, PLAYER_START_X  ; X coordinate
    ld d, TILE_COWBOY ; tile
    ld e, 0   ; tile properties
    call set_entity_sprite

    ld hl, wPlayerDirection
    set 0, [hl]

    ld h, CMP_ATTR_H
    ld l, PHY_FLAGS
    set PHY_FLAG_GROUNDED, [hl]
    res PHY_FLAG_JUMPING, [hl]
    ret