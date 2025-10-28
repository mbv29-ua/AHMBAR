INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

SECTION "Physics system", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine applies gravity to the E-th entity.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE

apply_gravity_to_entity::
	;; HL contains the address of the routine,
	;; so we save it since we want to use HL
    push hl

	;; Load entity physics addres in HL
	ld h, CMP_PHYS_H
	ld l, e

	;; Load Vy in BC
	ld b, [hl] ; Load current Vy in A
	inc hl
	ld c, [hl]

	;; Load GRAVITY in DE
	ld d, 0
	ld e, GRAVITY

	;; Add and store
	call add_bc_de

	;; To avoid infinite acceleration
	ld a, MAX_GRAVITY
	cp b
	jr nz, .store_new_speed ; if equal, we limit the gravity
	ld b, MAX_GRAVITY-1

	.store_new_speed:
	ld [hl], c
	dec hl
	ld [hl], b

	pop hl
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine applies gravity to all the 
;; affected entities
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 

apply_gravity_to_affected_entities::
	ld hl, apply_gravity_to_entity
	;ld b, E_BIT_GRAVITY
	call man_entity_for_each_gravity ;;; Cambiar por man_entity_for_each_ gravity
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine stops the gravity to all 
;;; to the L-th entity.if it is grounded
;;;
;;; INPUT:
;;;		E: Entity index
;;; OUTPUT:
;;;		-	
;;; WARNING: Destroys BC and DE
;
;;; Creo que finalmente esta no es necesaria
;
;vertical_speed_to_zero_if_grounded_to_entity::
;	push hl 
;	ld h, CMP_ATTR_H
;    ld l, PHY_FLAGS
;    bit PHY_FLAG_JUMPING, [hl]
;    pop hl
;    ret nz
;
;    push hl 
;	ld h, CMP_ATTR_H
;    ld l, PHY_FLAGS
;    bit PHY_FLAG_GROUNDED, [hl]
;    pop hl
;    ret z
;
;	call new_check_entity_collision_down
;	ret z
;
;	push hl
;	; Detener velocidad vertical
;	ld h, CMP_PHYS_H
;	ld l, e
;
;	xor a	
;	ld [hl+], a      ; vy = 0
;	ld [hl], a
;
;	pop hl
;	ret
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine stops the gravity to all 
;;; entities affected by gravity that are grounded
;;;
;;; INPUT:
;;;		-
;;; OUTPUT:
;;;		-	
;;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;vertical_speed_to_zero_if_grounded::
;	ld hl, vertical_speed_to_zero_if_grounded_to_entity
;	call man_entity_for_each ;;; Cambiar por man_entity_for_each_ gravity
;	ret