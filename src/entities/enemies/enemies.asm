INCLUDE "entities/entities.inc"
INCLUDE "entities/enemies/enemies.inc"

DEF DEATH_CLOCK_START_VALUE EQU 15 ; 0.25 seconds

SECTION "Entity quantities", WRAM0

wNumberOfEnemies:: DS 1


SECTION "Enemies", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets the enemy initial speed Vx
;; specified in the definition file.
;;
;; INPUT:
;;      HL: Enemy attributes information address
;; OUTPUT:
;;       A: Enemy speed
;; WARNING: Destroys DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_enemy_definition_vx::
	push hl
	ld d, 0
	ld e, ENEMY_INITIAL_VX_SPEED
	add hl, de
	ld a, [hl]
	pop hl
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets the enemy initial speed Vx
;; specified in the definition file.
;;
;; INPUT:
;;      HL: Enemy attributes information address
;; OUTPUT:
;;       A: Enemy speed
;; WARNING: Destroys DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_enemy_definition_vy::
	push hl
	ld d, 0
	ld e, ENEMY_INITIAL_VY_SPEED
	add hl, de
	ld a, [hl]
	pop hl
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; damage_enemy
;; Causes 1 damage to an enemy
;;
;; Input: L = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

damage_enemy::
    ; Obtener vida actual del enemigo
    ld h, CMP_ATTR_H
    ;ld l, a  ; L = enemy index
    ld a, l
    add ENTITY_HEALTH  ; A = enemy index + offset ENTITY_HEALTH
    ld l, a  ; HL ahora apunta a ENTITY_HEALTH del enemigo
    dec [hl]  ; A = vida actual
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; kill_enemy
;; If enemy health is 0, enemy is destroyed
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_if_life_is_0_and_set_death_counter::
	ld h, CMP_ATTR_H
	ld a, e
	add ENTITY_HEALTH
	ld l, a
	ld a, [hl]
	or a 		; We check if a is 0
	ret nz

	; If it is health is 0, we check if the entity was already dying
	ld h, CMP_ATTR_H
	ld l, e
	bit E_BIT_DYING, [hl]	
	call z, set_death_clock
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; kill_enemy
;; If enemy health is 0, enemy is destroyed
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clean_dead_enemy::
	ld h, CMP_ATTR_H
	ld l, e
	bit E_BIT_DYING, [hl]	
	ret z

	ld h, CMP_CONT_H
	ld a, e
	add COUNT_DEATH_CLOCK
	ld l, a
	ld a, [hl]
	or a
	jr z, .clean
		dec [hl]
		ret

	.clean:
		ld l, e
		call man_entity_free ; Receives L as the entity index

		ld hl, wNumberOfEnemies
		dec [hl]
	ret 


 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; kill_enemy
;; If enemy health is 0, enemy is destroyed
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

destroy_dead_enemies::
	ld hl, check_if_life_is_0_and_set_death_counter
	call man_entity_for_each_enemy

	ld hl, clean_dead_enemy
	call man_entity_for_each_enemy
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set death clock to an enemy counter and mark it
;; as a dying enemy.
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_death_clock::
	ld h, CMP_ATTR_H
	ld l, e
	set E_BIT_DYING, [hl]

	ld h, CMP_CONT_H
	ld a, e
	add COUNT_DEATH_CLOCK
	ld l, a
	ld [hl], DEATH_CLOCK_START_VALUE
	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine counts the number of enemies in
;; the scene.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;man_entity_count_number_of_enemies::
;	xor a
;	ld [wNumberOfEnemies], a
;	ld hl, inc_number_of_enemies_counter
;	call man_entity_for_each_enemy
;	ret
;
;
;inc_number_of_enemies_counter::
;	ld hl, wNumberOfEnemies
;	inc [hl]
;	ret
;
;dec_number_of_enemies_counter::
;	ld hl, wNumberOfEnemies
;	inc [hl]
;	ret