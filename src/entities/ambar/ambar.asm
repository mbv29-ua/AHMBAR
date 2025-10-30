INCLUDE "entities/entities.inc"

DEF DEATH_CLOCK_START_VALUE EQU 15

SECTION "Ambar entity", ROM0




;; funcion cuando el juegador toque la entidad, incrementar countar, hago animacion, elimini identidad
collect_ambar::
    ;; counter inc
    ld h, CMP_ATTR_H
	ld l, e
	bit E_BIT_DYING, [hl]	
	call z, set_ambar_clock
    
    ret

clean_collected_ambar::
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
	ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set death clock to an enemy counter and mark it
;; as a dying enemy.
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_ambar_clock::
	ld h, CMP_ATTR_H
	ld l, e
	set E_BIT_DYING, [hl]

	ld h, CMP_CONT_H
	ld a, e
	add COUNT_DEATH_CLOCK
	ld l, a
	ld [hl], DEATH_CLOCK_START_VALUE
	ret