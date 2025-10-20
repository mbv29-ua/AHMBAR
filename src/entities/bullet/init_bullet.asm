include "constants.inc"

SECTION "Bullet", ROM0

init_bullet::
    call man_entity_alloc ; Returns l=entity index

    ld a, [wPlayerDirection]
    cp 1
    jr z, .right
    jr .left

.right
    ld a, [Player.wPlayerX]
    add 8
    ld c, a
    jr .skip

.left
    ld a, [Player.wPlayerX]
    sub 8
    ld c, a
    jr .skip

.skip
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