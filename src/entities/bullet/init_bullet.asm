include "constants.inc"

SECTION "Bullet", ROM0


load_bullet_sprites::
    ld hl, Tile_Bullet
    ld de, VRAM0_START + (TILE_BULLET * TILE_SIZE)
    ld  b, Tile_Bullet_End - Tile_Bullet
    call memcpy_256
    ret


init_bullet::
    call man_entity_alloc ; Returns l=entity index

    ;; Change by some flag
    ld a, [wPlayerDirection]
    cp 1

    ld a, [Player.wPlayerX] ;; We keep the flag
    jr z, .right    
    .left
        sub 8
        jr .skip
    .right
        add 8
    .skip
        ld c, a

    ; Configurar posición Y
    ; ld e, d
    ; add hl, de
    ld a, [Player.wPlayerY]
    ld b, a

	ld d, TILE_BULLET ; tile
	ld e, 0   ; tile properties
	call set_entity_sprite

    ld a, [wPlayerDirection]
    cp 1
    ld b, 0 ; vy 
    jr z, .right_speed
    jr .left_speed

.right_speed
	ld c, BULLET_SPEED ; vx
    jr .skip_speed

.left_speed
	ld c,  -BULLET_SPEED ; vx
    jr .skip_speed

.skip_speed

	call set_entity_physics
    ret