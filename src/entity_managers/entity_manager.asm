INCLUDE "entities/entities.inc"

SECTION "Entity Manager RAM variables", WRAM0

has_been_freed:: DS 1


SECTION "Entity Manager Code", ROM0


;; INPUT
;; 	HL: Address of component entities
;; WARNING: DESTROYS HL, BC

man_entity_init::
	ld hl, ENTITIES_MEM_START
	ld bc, ENTITIES_MEM_SIZE
	call memreset_65536

	ld hl, sentinel_attr ;; SET SENTINEL AT THE END OF THE ARRAY OF ENTITIES
	ld [hl], $FF

	ld hl, ATTR_BASE
	set E_BIT_SENTINEL, [hl]
	ret 


;; 	OUT 
;;		L: RETURNS THE INDEX OF THE ENTITY
;; WARNING: DESTROYS HL, DE, A 
man_entity_alloc::
	call man_find_sentinel
	res E_BIT_SENTINEL, [hl]

	call man_find_first_free

	set E_BIT_FREE, [hl]
	set E_BIT_SENTINEL, [hl]
	ret

;; INPUT
;; 	OUT 
;;		L: RETURNS THE INDEX OF THE ENTITY 
;; WARNING: DESTROYS HL, DE, A

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


;; output hl: direccion del que tiene el sentinel a 1
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

;; INPUT
;; 	HL: PROCESS ROUTINE ADDRESS
man_entity_for_each::
	ld de, ATTR_BASE
	.loop

	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	bit E_BIT_SENTINEL, a 
	jr nz, .process_and_exit

	push af
	push de
	push hl
	call helper_call_hl
	.return
	pop hl
	pop de
	pop af


	.continue
	ld a, e 
	add ATTR_SIZE
	ld e, a 
	
	jr .loop

	.process_and_exit:
	push af
	push de
	push hl
	call helper_call_hl
	pop hl
	pop de
	pop af	

	.exit
		ret



;; INPUT: 
;;	   L: INDEX ENTITY TO DELETE 
man_entity_free::
	;; Necesito direccion que quiero borrar
	;; Buscar sentinel quitar el bit de sentinel y ponerselo al anterior del sentinel es decir, restar 4 para pasar a la entidad anterior
	
	ld d, CMP_SPRIT_H
	ld e, l  
	push de
	call man_find_sentinel ;; hl = address con sentinel
	ld h, CMP_ATTR_H
	res E_BIT_SENTINEL, [hl] 

	ld h, CMP_SPRIT_H
	
	ld c,  8

	pop de
	.loop:
	push hl 
	push de
	ld b, 4

	call memcpy_256
	pop de 
	pop hl 

	inc h 
	inc d 
	dec c 
	jr nz, .loop 

	call reset_entity_sprite

	ld h, CMP_ATTR_H
	ld a, l 
	sub 4 
	ld l, a 
	set E_BIT_SENTINEL, [hl]

	ret

man_entity_for_each_movable::
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop

	bit E_BIT_SENTINEL, a 
	jr nz, .process_and_exit

	bit E_BIT_MOVABLE, a
	jr z, .continue

	push af
	push de
	push hl
	call helper_call_hl
	.return
	pop hl
	pop de
	pop af


	.continue
	ld a, e 
	add ATTR_SIZE
	ld e, a 
	
	jr .loop

	.process_and_exit:
	bit E_BIT_MOVABLE, a
	jr z, .exit
	push af
	push de
	push hl
	call helper_call_hl
	pop hl
	pop de
	pop af	

	.exit
		ret


;; -------------------------------------------------------------------
;; man_entity_for_each_of_type
;;
;;    INPUT:
;;    B  -> Bit a comprobar (0–7)
;;    HL -> Dirección de la rutina a ejecutar (callback)
;;
;;    Recorre todas las entidades y llama a la rutina si el bit B está activo.
;; -------------------------------------------------------------------
man_entity_for_each_type::
	
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop		
		ld a, [de]
		ld c, a 

		;; mascara
		ld a, 1 
		ld d, b 
		.mask_loop:
			or a 
			dec d 
			jr c, .mask_done ;; si era b = 0 nos salimos
			sla a 
			jr nz, .mask_loop
		.mask_done:
			and c 
			jr z, .next
		
		jr z, .next

		push af
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop af	

		.next:
		bit E_BIT_SENTINEL, a 
		ret nz

		ld a, e 
		add ATTR_SIZE
		ld e, a 
		jr .loop



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as enemies.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_enemy::
	
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop		
		ld a, [de]
		bit E_BIT_ENEMY, a
		jr z, .next

		push af
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop af	

		.next:
		bit E_BIT_SENTINEL, a 
		ret nz

		ld a, e 
		add ATTR_SIZE
		ld e, a 
		jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities identified as intelligent enemies.
;;
;; INPUT:
;;		HL: Routine to apply to each enemy
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_intelligent_enemy::
	
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop		
		ld a, [de]
		bit E_BIT_INTELLIGENT_ENEMY, a
		jr z, .next

		push af
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop af	

		.next:
		bit E_BIT_SENTINEL, a 
		ret nz

		ld a, e 
		add ATTR_SIZE
		ld e, a 
		jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities affected by gravity.
;;
;; INPUT:
;;		HL: Routine
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_gravity::
	
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop:
		ld b, 0
		ld c, INTERACTION_FLAGS
		call add_bc_de

		ld a, [bc]				; BC is the address of the INTERACTION_FLAGS
		bit E_BIT_GRAVITY, a
		jr z, .next

		push af
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop af	

		.next:
		ld a, [de]				; DE is the address of the ATT_ENTITY_FLAGS
		bit E_BIT_SENTINEL, a 
		ret nz

		ld a, e 
		add ATTR_SIZE
		ld e, a 
		jr .loop



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine processes a routine only for those
;; entities affected when they are ouside the screen.
;;
;; INPUT:
;;		HL: Routine
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_entity_for_each_not_living_out_of_screen::
	
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop:
		ld b, 0
		ld c, INTERACTION_FLAGS
		call add_bc_de

		ld a, [bc]				; BC is the address of the INTERACTION_FLAGS
		bit E_BIT_OUT_OF_SCREEN, a
		jr nz, .next

		push af
		push de
		push hl
		call helper_call_hl
		pop hl
		pop de
		pop af	

		.next:
		ld a, [de]				; DE is the address of the ATT_ENTITY_FLAGS
		bit E_BIT_SENTINEL, a 
		ret nz

		;; Estas tres lineas deberia hacerlas el free
		ld a, [has_been_freed]
		or a ; We check if it is zero
		jr z, .loop ; if it has been freed, then we do not increase the index

		ld a, e 
		add ATTR_SIZE
		ld e, a 
		jr .loop
