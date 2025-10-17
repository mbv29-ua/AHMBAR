INCLUDE "entities/entities.inc"

SECTION "Physics system", ROM0

;; Applies the velocities to the positions of a movable entity
update_entity_position::

	; Load y
	ld d, CMP_SPRIT_H
	ld a, [de]
	; Add vy 
	ld h, CMP_PHYS_H
	ld l, e 
	add [hl]
	; y -> y+vy
	ld [de], a

	inc e
	
	; Load x
	ld d, CMP_SPRIT_H
	ld a, [de]
    ; Add vx
	ld h, CMP_PHYS_H
	ld l, e 
	add [hl]
	; x -> x+vx
	ld [de], a

	ret


;;
;; 
;; Warning: destroys ... (lo que destruya man_entity_for_each) 
update_all_entities_positions::
	ld hl, update_entity_position
	call man_entity_for_each ;;; de <- direccion deatributos entidad ;;; Cambiar por man_entity_for_each_movable
	ret