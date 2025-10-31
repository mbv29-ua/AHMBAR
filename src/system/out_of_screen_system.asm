INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Out of Screen", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine returns C=1 if the entity is out
;; of screen and C=0 otherwise.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		C=1 if out of screen, C=0 if not
;; WARNING: Destroys A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_out_of_screen::
	
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_Y
	ld l, a
	ld b, [hl] ; Load Y in B

	add (SPR_X-SPR_Y)
	ld l, a
	ld c, [hl] ; Load X in C

	; Verificar Y (valores válidos: 16-160 para estar visible)
	; Y < 16 = arriba de pantalla, Y > 160 = abajo de pantalla
	ld a, b
	cp 16
	ret c ; Y < 16, fuera arriba

	ld a, 161
	cp b
	ret c ; Y >= 161, fuera abajo
	
	; Verificar X (valores válidos: 8-168 para estar visible)
	; X < 8 = izquierda de pantalla, X > 168 = derecha de pantalla
	ld a, c
	cp 8
	ret c ; X < 8, fuera izquierda

	ld a, 169
	cp c  ; X >= 169, fuera derecha
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Destroys the entity if it is outside the screen
;;
;; INPUT:
;;		E
;; OUTPUT:
;;		-
;; WARNING: Destroys A, HL, E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

destroy_entity_out_of_screen::
	call is_out_of_screen
	ret nc
	ld l, e
	call man_entity_free
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Destroys the entity that are outside the screen
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-
;; WARNING: Destroys A, HL, E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

destroy_entities_out_of_screen::
	ld hl, destroy_entity_out_of_screen
	call man_entity_for_each_not_living_out_of_screen
	ret

