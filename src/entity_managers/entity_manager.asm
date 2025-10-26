INCLUDE "entities/entities.inc"
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


helper_call_hl::
	jp hl

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

man_entity_for_each_gravity::
	
	ld de, ATTR_BASE
	ld a, [de]
	cp ENTITY_CMP_SENTINEL
	ret z 

	.loop		
		ld a, [de]
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
		bit E_BIT_SENTINEL, a 
		ret nz

		ld a, e 
		add ATTR_SIZE
		ld e, a 
		jr .loop

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




