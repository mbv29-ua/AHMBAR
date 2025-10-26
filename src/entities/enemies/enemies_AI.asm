INCLUDE "entities/entities.inc"

DEF MOVING_COOLDOWN 		EQU 60 ; About three seconds
DEF JUMPING_COOLDOWN 		EQU 120 ; About three seconds
DEF ENEMY_JUMPING_SPEED 	EQU 2 ; About three seconds


SECTION "Enemies AI", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine does nothing. It is used to 
;; indicate that there is no behaviour.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

No_AI::
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; With this AI, an enemy jumps every certain amount
;; of time given by JUMPING_COOLDOWN with a jumping
;; speed given by ENEMY_JUMPING_SPEED. It is necessary
;; that the enemy is grounded in order to jump.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;; WARNING: 	Destroys A, DE and HL
;; CONFLICTS: 	Must not be used in conjunction with:
;;				- AI_flying_enemy_up_and_down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AI_jumping_enemy::
	call is_floating
	ret z ; if not, then is grounded, and we continue

	ld h, CMP_CONT_H
	ld a, e
	add COUNT_JUMPING_COOLDOWN
	ld l, a 

	ld a, [hl]
	or [hl] ; We check if the component is zero
	jr nz, .update_cooldown 

	; Enemy jumps
	ld h, CMP_PHYS_H
	ld a, e
	add PHY_VY
	ld l, a 
	ld [hl], -ENEMY_JUMPING_SPEED 

	; Starts cooldown
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_JUMPING_COOLDOWN
	ld l, a 
	ld [hl], JUMPING_COOLDOWN 

	call unset_grounded
	ret

	.update_cooldown:
		dec [hl] ; decrements cooldown 
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; With this AI, an enemy changes its flies up
;; and down changing its direction every certain
;; amount of time.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;; WARNING: Destroys A, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AI_flying_enemy_up_and_down::
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_MOVING_COOLDOWN
	ld l, a 

	ld a, [hl]
	or [hl] ; We check if the component is zero
	jr nz, .update_cooldown 

	; Enemy changes flying direction
	ld h, CMP_PHYS_H
	ld a, e
	add PHY_VY
	ld l, a 

	ld a, [hl]
	call oposite_of_a
	ld [hl], a
	
	; Starts cooldown
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_MOVING_COOLDOWN
	ld l, a 

	ld [hl], MOVING_COOLDOWN 
	ret

	.update_cooldown:
		dec [hl] ; decrements cooldown 
	ret

