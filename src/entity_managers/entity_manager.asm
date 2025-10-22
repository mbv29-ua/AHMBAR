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
	call man_find_sentinel ;; hl = address con sentinel
	res E_BIT_SENTINEL, [hl]

	;; aqui habria que hacer un algo para pasar todos los datos de esa entidad a la otra

	ld de, ATTR_SIZE
	sub l, e  ;; solo usar este borrado si no es para el personaje principal que lo tenemos en el 0
	set E_BIT_SENTINEL, [hl]




	;; Coger los datos del sentinel e intercambiarlos por el que lo quiero borrar
	;; get y luego set en la direccion del que queria borrar







