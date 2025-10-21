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

	; Marcar como grounded
	ld a, l
	add PHY_FLAGS
	ld l, a
	set PHY_FLAG_GROUNDED, [hl]
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
	res PHY_FLAG_GROUNDED, [hl]
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


Delay60Cycles:
    ld b, 60          ; número aproximado de iteraciones
.delay_loop:
    dec b
    jr nz, .delay_loop
    ret

DelayFrame:
    ld b, 120
.outer:
    ld c, 60
.inner:
    dec c
    jr nz, .inner
    dec b
    jr nz, .outer
    ret