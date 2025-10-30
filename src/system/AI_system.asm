INCLUDE "entities/entities.inc"


SECTION "AI System", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes the enemy AI.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

process_entity_AI::
	;; HL contains the address of the routine,
	;; so we save it since we want to use HL
    push de ; We save E

	ld h, CMP_AI_H
	ld a, AI_ROUTINE_1
	add e
	ld l, a

	; VER SI ESTO DE AQUI SE PUEDE CAMBIAR
	; O SE PUEDE HACER UN HELPER DE
	push hl
	ld a, [hl]
	inc l
	ld l, [hl]
	ld h, a
	call helper_call_hl
	pop hl

	ld h, CMP_AI_H
	ld a, AI_ROUTINE_2
	add e
	ld l, a

	push hl
	ld a, [hl]
	inc l
	ld l, [hl]
	ld h, a
	call helper_call_hl
	pop hl

	pop de
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine applies AI behavior to all the 
;; affected entities
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

process_all_enemies_AIs::
	ld hl, process_entity_AI
	call man_entity_for_each_enemy
	ret
