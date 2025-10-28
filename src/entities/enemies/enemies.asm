INCLUDE "entities/entities.inc"
INCLUDE "entities/enemies/enemies.inc"

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
    ; Guardar índice del enemigo
    ;ld b, a  ; B = enemy index

    ; Obtener vida actual del enemigo
    ld h, CMP_ATTR_H
    ;ld l, a  ; L = enemy index
    ld a, l
    add ENTITY_HEALTH  ; A = enemy index + offset ENTITY_HEALTH
    ld l, a  ; HL ahora apunta a ENTITY_HEALTH del enemigo
    dec [hl]  ; A = vida actual

    ; Si tiene menos de 3 de vida, poner a 0
    ;cp 3
    ;ret nz ;jr z, .kill_enemy

    ; Restar 3 de vida
    ;sub 3
    ;ld [hl], a
    ;ret

	;.kill_enemy:
    ; Poner vida a 0
    ;xor a
    ;ld [hl], a

    ; Marcar enemigo como FREE (destruirlo)
    ;ld h, CMP_ATTR_H
    ;ld l, b  ; L = enemy index (recuperado de B)
    ;res E_BIT_FREE, [hl]
	;sub ENTITY_HEALTH
	;ld l, a
	;call man_entity_free
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; kill_enemy
;; If enemy health is 0, enemy is destroyed
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kill_enemy_if_life_is_0::
	ld h, CMP_ATTR_H
	ld a, e
	add ENTITY_HEALTH
	ld l, a
	ld a, [hl]
	or a 		; We check if a is 0
	ld l, e
	call z, man_entity_free
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; kill_enemy
;; If enemy health is 0, enemy is destroyed
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kill_enemies_if_life_is_0::
	ld hl, kill_enemy_if_life_is_0
	call man_entity_for_each_enemy
    ret

 