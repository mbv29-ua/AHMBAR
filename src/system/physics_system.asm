INCLUDE "entities/entities.inc"

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
	call Delay60Cycles

	;; ========== APLICAMOS GRAVEDAD ==========

	ld a, [hl]
	add GRAVITY
	ld [hl], a 
	ld b, a 
		

	
	


	;; ========== SUMAMOS Y + VY ==========
	ld a, [de]
	add b
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

	;; ========== ESTO SE TENDRA QUE MOVER POR EL MAPA DE COLISIONES SOLO ES PARA PROBAR LA GRAVEDAD Y EL SALTO ==========
	dec e 
	ld l, e 

	ld a, [de]
	cp $72
	jr c, .no_floor
	    ld a, $72
	    ld [de], a
	    xor a
	    ld [hl], a ;; y = 72 vy = 0

	    ld a, l 
	    add PHY_FLAGS
	    ld l, a 

	    set PHY_FLAG_GROUNDED, [hl]

	    jr .end
	    
	.no_floor:
		ld a, l 
	    add PHY_FLAGS
	    ld l, a 

	    res PHY_FLAG_GROUNDED, [hl]

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