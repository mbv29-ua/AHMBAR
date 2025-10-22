INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

SECTION "Physics system", ROM0

;; Applies the velocities to the positions of a movable entity
update_entity_position::

	; LOAD Y
	ld d, CMP_SPRIT_H
	ld a, [de]
	; LOAD VY 
	ld h, CMP_PHYS_H
	ld l, e 

	;; HACER CONTADOR PARA SKIPEAR FRAMES
	;call Delay60Cycles

	;; ========== APLICAMOS GRAVEDAD ==========
	ld a, [hl]
	add GRAVITY
	ld [hl], a
	ld b, a 
		

	
	


	;; ========== SUMAMOS Y + VY (con colisiones) ==========
	ld a, [de]
	add b
	ld [de], a      ; Actualizar Y temporalmente

	; Guardar estado
	push de
	push bc

	; Verificar colisión vertical
	ld a, b
	cp 0
	jr z, .no_vertical_movement
	jr nc, .moving_down

.moving_up:
	call check_solid_collision_up
	jr z, .apply_y_movement  ; No hay colisión, aplicar movimiento
	; Hay colisión arriba, cancelar movimiento vertical
	pop bc
	pop de
	ld a, [de]
	sub b           ; Revertir movimiento
	ld [de], a

	; Detener velocidad vertical
	ld h, CMP_PHYS_H
	ld l, e
	xor a
	ld [hl], a
	jr .handle_x

.moving_down:
	call check_solid_collision_down
	jr z, .apply_y_movement  ; No hay colisión, aplicar movimiento
	; Hay colisión abajo (suelo detectado)
	pop bc
	pop de
	ld a, [de]
	sub b           ; Revertir movimiento
	ld [de], a

	; Detener velocidad vertical y marcar como grounded
	ld h, CMP_PHYS_H
	ld l, e
	xor a
	ld [hl], a      ; vy = 0

	; Marcar como grounded y resetear jumping
	ld a, l
	add PHY_FLAGS
	ld l, a
	ld a, [hl]
	set PHY_FLAG_GROUNDED, a
	res PHY_FLAG_JUMPING, a
	ld [hl], a
	jr .handle_x

.apply_y_movement:
	pop bc
	pop de
	; Movimiento ya aplicado, desmarcar grounded si se movió
	ld h, CMP_PHYS_H
	ld l, e
	ld a, l
	add PHY_FLAGS
	ld l, a
	ld a, [hl]
	res PHY_FLAG_GROUNDED, a
	ld [hl], a
	jr .handle_x

.no_vertical_movement:
	pop bc
	pop de

.handle_x:
	;; ========== SUMAMOS X + VX (con colisiones) ==========
	inc e

	ld d, CMP_SPRIT_H
	ld h, CMP_PHYS_H
	ld l, e

	; Cargar velocidad X
	ld a, [hl]
	or a
	jr z, .no_x_movement  ; Si vx = 0, no hay movimiento

	; Guardar vx
	ld b, a

	; Aplicar movimiento temporalmente
	ld a, [de]
	add b
	ld [de], a

	; Guardar estado
	push de
	push bc

	; Verificar colisión horizontal
	ld a, b
	cp 0
	jr nc, .moving_right

.moving_left:
	call check_solid_collision_left
	jr z, .apply_x_movement  ; No hay colisión
	; Hay colisión, revertir
	pop bc
	pop de
	ld a, [de]
	sub b
	ld [de], a
	jr .end

.moving_right:
	call check_solid_collision_right
	jr z, .apply_x_movement  ; No hay colisión
	; Hay colisión, revertir
	pop bc
	pop de
	ld a, [de]
	sub b
	ld [de], a
	jr .end

.apply_x_movement:
	pop bc
	pop de
	jr .end

.no_x_movement:
.end:
	ret


;;
;; 
;; Warning: destroys ... (lo que destruya man_entity_for_each) 
update_all_entities_positions::
	ld hl, update_entity_position
	call man_entity_for_each ;;; de <- direccion deatributos entidad ;;; Cambiar por man_entity_for_each_movable
	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine applies gravity to the L-th entity.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys BC and DE

apply_gravity_to_entity::
	;; HL contains the address of the routine,
	;; so we save it since we want to use HL
	ld d, HIGH(ATTR_BASE)
    ld e, PHY_FLAGS
    ld a, [de]
    bit PHY_FLAG_GROUNDED, a
    ret nz

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
	call man_entity_for_each ;;; Cambiar por man_entity_for_each_ gravity
	ret