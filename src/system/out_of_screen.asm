INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

SECTION "Out of screen entities", ROM0


;;; THIS DOES NOT WORK PROPERLY. WE SHOULD CHECK FREE ENTITY WORKS PROPERLY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine deletes the E-th entities if it is
;; out of the screen
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and HL (y lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

destroy_if_out_of_screen::

	ld h, SPR_BASE
	ld a, e
	add SPR_Y
	ld l, a
	
	ld a, [hl] ; Y coordinate of the entity
	cp 16
	jr c, .destroy
	cp 144 + 16
	jr nc, .destroy
	
	;; Loads the x coordinate in B and compares with the scroll
	ld h, SPR_BASE
	ld a, e
	add SPR_X
	ld l, a

	ld a, [hl] ; X coordinate
	cp 8
	jr c, .destroy
	cp 160 + 8
	jr nc, .destroy
	
	.not_destroyed:
		ld a, 0
		ld [has_been_freed], a
	ret

	.destroy:
		call man_entity_free
		ld a, 1
		ld [has_been_freed], a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine deletes those entities that
;; cannot live outside the screen
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

delete_out_of_screen_entities::
	ld hl, destroy_if_out_of_screen
	call man_entity_for_each_not_living_out_of_screen
	ret