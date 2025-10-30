INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

DEF MOVING_COOLDOWN 		EQU 10 ; About three seconds
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

	; Starts cooldown
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_JUMPING_COOLDOWN
	ld l, a 
	ld [hl], JUMPING_COOLDOWN 

	call unset_grounded

	; Enemy jumps with direction

	push de ; we want to keep E
	ld l, e
	call get_entity_definition_component
	ld h, d
	ld l, e
	call get_enemy_definition_vy
	ld b, a
	call get_enemy_definition_vx
	ld c, a
	pop de ; we want to keep E

	push de
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_ATTR
	ld l, a 
	bit E_BIT_FLIP_X, [hl]
	ld l, e  ; Recuperamos el indice
	ld a, c
	jr z, .continue
	
	; We flip the direction of the speed
	call oposite_of_a

	.continue:
	ld c, 0
	ld d, a
	ld e, 0
	call set_entity_physics

	pop de
	ret

	.update_cooldown:
		dec [hl] ; decrements cooldown 
		call set_horizontal_speed_to_zero
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; With this AI, an enemy throws rocks randomly
;; every quarter of second.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AI_throwing_rocks::
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_SPAWN_ENEMIES
	ld l, a 

	ld a, [hl]
	or [hl] ; We check if the spawning counter is at zero
	jr nz, .update_cooldown 

	; Spawn a rock
	ld a, [wRandomNumber]
	cp 160
	ret nc ; If there is no carry, we do not throw the rock

	push de
	ld b, 16
	ld c, a
	ld hl, falling_rock
	call enemy_spawn
	pop de
	
	; Starts cooldown
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_SPAWN_ENEMIES
	ld l, a 

	ld [hl], 20
	ret

	.update_cooldown:
		dec [hl] ; decrements cooldown 
	ret
