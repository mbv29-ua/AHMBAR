INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"


SECTION "Enemy collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if an enemy is colliding
;; with the player.
;;
;; INPUT
;;      E: Enemy entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_player_enemy_collision::
    ld a, [wSpikeCooldown]
    or a
    ret nz 

    ld l, 0 ; Player entity index
    call are_entities_colliding
    call c, enemy_damage ; If collide, then damage the player - Call it with a different name
    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks the collisions of the player
;; with the enemies.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_enemy_collision::
    ld hl, check_player_enemy_collision
    call man_entity_for_each_enemy
    ret