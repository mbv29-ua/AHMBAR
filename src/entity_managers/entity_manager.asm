INCLUDE "entities/entities.inc"


SECTION "Entity Manager Code", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Writes in all the memory positions assigned to
;; entities the value $00 and sets the sentinel.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC and HL.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_init::
	ld hl, ENTITIES_MEM_START
	ld bc, ENTITIES_MEM_SIZE
	call memreset_65536

	ld hl, sentinel_attr ;; SET SENTINEL AT THE END OF THE ARRAY OF ENTITIES
	ld [hl], $FF

	ld hl, ATTR_BASE
	set E_BIT_SENTINEL, [hl]
	ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine finds the first free entity,
;; declared it as used and returns the corresponding
;; index.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      L: Returns the index of the entity
;; WARNING: Destroys A, DE and H.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_alloc::
	;call man_find_sentinel
	;res E_BIT_SENTINEL, [hl]
	call man_find_first_free
	ld [hl], (1<<E_BIT_FREE) ; %01000000
	; set E_BIT_FREE, [hl]
	; set E_BIT_SENTINEL, [hl]

	push hl
	call set_last_not_free
	pop hl
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine finds the first free entity and
;; returns the corresponding index.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      L: Returns the index of the entity
;; WARNING: Destroys A, DE and H.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_find_first_free::
	ld hl, ATTR_BASE - ATTR_SIZE
	ld de, ATTR_SIZE
	.loop
		add hl, de 
		ld a, [hl]
		cp ENTITY_CMP_SENTINEL
		ret z

		bit E_BIT_FREE, a 
		ret z 

		jr .loop
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine marks the entities above the last
;; active one with the sentinel bit.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, DE and H.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_last_not_free::
	ld hl, ATTR_BASE + ATTR_SIZE * (NUM_ENTITIES-1) ; HL starts in the last entity
	ld de, -ATTR_SIZE
	.loop
		bit E_BIT_FREE, [hl]
		ret nz

		set E_BIT_SENTINEL, [hl]
		add hl, de
		jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine finds the sentinel and returns
;; the corresponding index.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      L: Returns the index of the entity with the sentinel
;; WARNING: Destroys A, DE and H.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_find_sentinel::
	ld hl, ATTR_BASE - ATTR_SIZE 
	ld de, ATTR_SIZE

	.loop
	add hl, de 
	ld a, [hl]
	cp ENTITY_CMP_SENTINEL
	ret z

	bit E_BIT_SENTINEL, a 
	ret nz

	jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine finds the sentinel and returns
;; the corresponding index.
;;
;; INPUT:
;;      L: Index of the entity to free.
;; OUTPUT:
;;      -
;; WARNING: Destroys H.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_free::
	call reset_entity_sprite
	; call reset_entity_attributes

	ld h, CMP_ATTR_H
	res E_BIT_FREE, [hl] 
	call set_last_not_free
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processed the routine specified
;; in HL for all the entities.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;     HL: Address of the routine to be processed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each::
	ld de, ATTR_BASE
	.loop
		ld	a, [de]
		bit E_BIT_SENTINEL, a 
		ret nz
		bit E_BIT_FREE, a
		jr z, .next

		push af
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop af

		.next:
			ld a, e 
			add ATTR_SIZE
			ld e, a 
			jr .loop


;; -------------------------------------------------------------------
;; man_entity_for_each_of_type
;;
;;    INPUT:
;;    B  -> Bit a comprobar (0–7) (p. ej)
;;	  C  ->	Componente de flags
;;    HL -> Dirección de la rutina a ejecutar (callback)
;;
;;    Recorre todas las entidades y llama a la rutina si el bit indicado por B está activo.
;; -------------------------------------------------------------------

man_entity_for_each_type::

	ld de, ATTR_BASE
	.loop
		ld	a, [de]
		bit E_BIT_SENTINEL, a 
		ret nz
		bit E_BIT_FREE, a
		jr z, .next

		push de
		;; We move DE to the specified entity flag
		ld a, e
		add c
		ld e, a

		;; We check the bit
		ld	a, [de]
		and b 		; We keep the common 1s
		pop de
		jr z, .next

		push bc
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop bc

		.next:
			ld a, e 
			add ATTR_SIZE
			ld e, a 
			jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as movable entities.
;;
;; INPUT:
;;		HL: Routine to apply to each movable entity
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_movable::
	ld b, (1<<E_BIT_MOVABLE)
	ld c, INTERACTION_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as enemies.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_enemy::
	ld b, (1<<E_BIT_ENEMY)
	ld c, ATT_ENTITY_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as collidable entities.
;;
;; INPUT:
;;		HL: Routine to apply to each collidable entity
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_collidable::
	ld b, (1<<E_BIT_COLLIDABLE)
	ld c, INTERACTION_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as intelligent enemies.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_intelligent_enemy::
	ld b, (1<<E_BIT_INTELLIGENT_ENEMY)
	ld c, ATT_ENTITY_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities affected by gravity.
;;
;; INPUT:
;;		HL: Routine
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_gravity::
	ld b, (1<<E_BIT_GRAVITY)
	ld c, INTERACTION_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities affected when they are ouside the screen.
;;
;; INPUT:
;;		HL: Routine
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_not_living_out_of_screen::
	ld b, (1<<E_BIT_DIES_OUT_OF_SCREEN)
	ld c, INTERACTION_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as bullets.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_bullet::
	ld b, (1<<E_BIT_BULLET)
	ld c, ATT_ENTITY_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; dying entities.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_dying::
	ld b, (1<<E_BIT_DYING)
	ld c, ATT_ENTITY_FLAGS
	call man_entity_for_each_type
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as enemies.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_ambar::
	ld b, (1<<AMBAR_COLLECT)
	ld c, PHY_FLAGS
	call man_entity_for_each_type
	ret