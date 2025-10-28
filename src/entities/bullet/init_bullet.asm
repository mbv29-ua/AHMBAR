INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "src/system/hud/hud_constants.inc"


SECTION "Bullet", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the bullet sprite in the 
;; VRAM.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_bullet_sprites::
    ld hl, Tile_Bullet
    ld de, VRAM0_START + (TILE_BULLET * TILE_SIZE)
    ld  b, Tile_Bullet_End - Tile_Bullet
    call memcpy_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine creates a bullet entity and sets
;; its component initial values
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	ld d, BULLET_SPEED ; vx
    jr .skip_speed

.left_speed
	ld d,  -BULLET_SPEED ; vx
    jr .skip_speed

.skip_speed
	call set_entity_physics

    ; Configurar flags: la bala NO debe existir fuera de bounds
    ; Esto evita que el sistema la haga "wrapear"
    
    ld h, CMP_ATTR_H
    ld a, ATT_ENTITY_FLAGS
    add l
    ld l, a
    set E_BIT_BULLET, [hl]

    ld a, INTERACTION_FLAGS
    add l
    ld l, a
    set E_BIT_DIES_OUT_OF_SCREEN, [hl]  ; Asegurar que NO puede salir de bounds
    ; set E_BIT_COLLIDABLE, a          ; Collides <- We remove this, so it can overlap with a solid tile to be destroyed
    set E_BIT_MOVABLE, [hl]

    ; Restore L
    sub INTERACTION_FLAGS
    ld l, a

    ld h, CMP_AABB_H
    ld a, ENTITY_HEIGHT
    add l
    ld [hl], 8
    inc l
    ld [hl], 8

    ret