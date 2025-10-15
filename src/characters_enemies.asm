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
    ld a, PLAYER_START_X
    ld [Player.wPlayerX], a
    ld a, PLAYER_START_Y
    ld [Player.wPlayerY], a
    ret

render_player::
    call wait_vblank
    ld hl, OAM_PLAYER
    ld a, [Player.wPlayerY]
    ld [hl+], a
    ld a, [Player.wPlayerX]
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    xor a
    ld [hl], a
    ret