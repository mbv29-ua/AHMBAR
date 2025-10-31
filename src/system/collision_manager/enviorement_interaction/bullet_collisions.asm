INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Bullet collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;; INPUT:
;;      E: Bullet index
;;
;;; WARNING: Destroys A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_bullet_enemy_collision::
    ;push de
    ;call get_entity_sprite ; B = Y coordinate, C = X coordinate
    ;pop de

    ld h, CMP_ATTR_H
    ld l, -4

    .next_enemy:
        ld a, l
        add 4
        ld l, a

        push hl
        call is_damageable_enemy
        pop hl
        jr z, .next_enemy

        push de
        push hl
        call are_entities_colliding
        pop hl
        pop de
        jr c, .collision 

        bit E_BIT_SENTINEL, [hl]
        ret nz                      ; Exit if there are no more entities
        jr .next_enemy
    
    .collision:
        call damage_enemy
        ld l, e                 ; We need the bullet index in L
        call man_entity_free
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_all_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_all_bullets_enemy_collision::
    ld hl, check_bullet_enemy_collision
    call man_entity_for_each_bullet
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_bullet_wall_collision::
	ld l, e
	call get_entity_sprite ; B = Y coordinate, C = X coordinate
    push hl
	call get_tile_at_position_y_x  ; A = tile ID
    pop hl
	call is_tile_solid
	ret nz
	call man_entity_free
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_all_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_all_bullets_wall_collision::
	ld hl, check_bullet_wall_collision
	call man_entity_for_each_bullet
	ret

