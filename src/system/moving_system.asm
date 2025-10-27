INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"
INCLUDE "system/sprite_constants.inc"


DEF PLAYER_HEIGHT EQU 8
DEF PLAYER_WIDTH  EQU 8

SECTION "Moving system variables", WRAM0

temporal_new_y_position: DS 1
temporal_new_x_position: DS 1 


SECTION "Moving system", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine computes the expected position
;; for the E-th entity position. Expected means
;; that it could be not the final position, e.g.
;; there is a collision with a solid object.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, C and D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

compute_expected_entity_position::
	; Load y
	ld d, CMP_SPRIT_H
	ld a, [de]
	; Add vy 
	ld h, CMP_PHYS_H
	ld l, e 
	add [hl]
	; y -> y+vy
	ld [temporal_new_y_position], a

	inc e
	; Load x
	ld d, CMP_SPRIT_H
	ld a, [de]
    ; Add vx
	ld h, CMP_PHYS_H
	ld l, e 
	inc l
	add [hl]
	; x -> x+vx
	ld [temporal_new_x_position], a

	dec e; we return e to its original value
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the E-th entity position.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, C and D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

new_update_entity_position::
	; Load y
	ld hl, temporal_new_y_position
	ld a, [hl]
	ld d, CMP_SPRIT_H
	ld [de], a

	inc e

	; Load x
	ld hl, temporal_new_x_position
	ld a, [hl]
	ld d, CMP_SPRIT_H
	ld [de], a
	dec e
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the E-th entity position.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys ???
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;update_all_entities_positions::
;	;ld hl, original_update_entity_position
;	ld hl, new_update_entity_position
;	call man_entity_for_each ;;; de <- direccion deatributos entidad ;;; Cambiar por man_entity_for_each_movable
;	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Moves the entity taking into account speeds
;; and solid tiles.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_entity::
	call compute_expected_entity_position
	call manage_entity_solid_collision
	call new_update_entity_position
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves each movable entity. <= But they are affected by 
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_all_entities_positions::
	ld hl, move_entity
	call man_entity_for_each ;;; de <- direccion deatributos entidad ;;; Cambiar por man_entity_for_each_movable
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the E-th entity position
;; to snap it to the tile grid and sets vertical
;; speed to 0
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

up_tile_snap::
	ld hl, temporal_new_y_position
	ld a, [hl]
	call convert_y_to_ty
	call get_uppermost_y_coordinate_below_tile
	ld hl, temporal_new_y_position
	ld [hl], a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the E-th entity position
;; to snap it to the tile grid and sets vertical
;; speed to 0
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, C and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

down_tile_snap::
	ld hl, temporal_new_y_position
	ld a, [hl]
	call convert_y_to_ty
	call get_lowermost_y_coordinate_above_tile
	ld hl, temporal_new_y_position
	ld [hl], a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the E-th entity position
;; to snap it to the tile grid and sets vertical
;; speed to 0
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, C and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left_tile_snap::
	ld hl, temporal_new_x_position
	ld a, [hl]
	call convert_x_to_tx
	call get_leftmost_x_coordinate_after_tile
	ld hl, temporal_new_x_position
	ld [hl], a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the E-th entity position
;; to snap it to the tile grid and sets vertical
;; speed to 0
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, C and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right_tile_snap::
	ld hl, temporal_new_x_position
	ld a, [hl]
	call convert_x_to_tx
	call get_rightmost_x_coordinate_before_tile
	ld hl, temporal_new_x_position
	ld [hl], a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This checks if there is a collision with a solid
;; tile and, in that case, manages the collision.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_entity_solid_collision::
	.vertical_movement:
		ld hl, temporal_new_y_position
		ld d, CMP_SPRIT_H
		ld a, [de]
		cp [hl] ; current - expected
		jr  z, .horizontal_movement
		jr nc, .check_up
		call manage_down_collisions
		jr .horizontal_movement
		.check_up:
			call manage_up_collisions
			jr .horizontal_movement
		
	.horizontal_movement:
		ld hl, temporal_new_x_position
		ld d, CMP_SPRIT_H
		inc e
		ld a, [de]
		cp [hl] ; current - expected
		;ret z
		jr nc, .snap_to_left
		.snap_to_right:
			dec e
			call manage_right_collisions
		ret
		.snap_to_left:
			dec e
			call manage_left_collisions
		ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This checks if there is a down collision, and
;; in that case, manages the collision.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_down_collisions::
	call new_check_entity_collision_down
	ret nz

	call set_vertical_speed_to_zero
	call down_tile_snap
	call set_grounded
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This checks if there is an up collision, and
;; in that case, manages the collision.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_up_collisions::
	call new_check_entity_collision_up
	ret nz
	call set_vertical_speed_to_zero
	call up_tile_snap 
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This checks if there is a left collision, and
;; in that case, manages the collision.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_left_collisions::
	call new_check_entity_collision_left
	ret nz
	;call set_horizontal_speed_to_zero
	call left_tile_snap
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This checks if there is a right collision, and
;; in that case, manages the collision.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_right_collisions::
	call new_check_entity_collision_right
	ret nz
	;call set_horizontal_speed_to_zero
	call right_tile_snap
	ret








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gets the tile ID at a specific pixel position
;;;
;;; Input:
;;;      -
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;get_tile_at_expected_position::
;	ld hl, temporal_new_y_position
;	ld b, [hl]
;	ld hl, temporal_new_x_position
;	ld c, [hl]
;	call get_tile_at_position
;	ret








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves the E-th entity one pixel
;; to the left.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_entity_one_pixel_to_left::
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_X
	ld l, a
	dec [hl]
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves each entity one pixel to the
;; left. This is useful for scrolling correctly.
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_all_entities_positions_one_pixel_to_left::
	ld hl, move_entity_one_pixel_to_left
	call man_entity_for_each
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves the E-th entity one pixel
;; to the right.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_entity_one_pixel_to_right::
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_X
	ld l, a
	inc [hl]
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves each entity one pixel to the
;; right. It is useful for scrolling correctly.
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_all_entities_positions_one_pixel_to_right::
	ld hl, move_entity_one_pixel_to_right
	call man_entity_for_each
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves the E-th entity one pixel
;; down.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_entity_one_pixel_down::
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_Y
	ld l, a
	inc [hl]
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves each entity one pixel down,
;; It is useful for scrolling correctly.
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_all_entities_positions_one_pixel_down::
	ld hl, move_entity_one_pixel_down
	call man_entity_for_each
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves the E-th entity one pixel
;; up.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_entity_one_pixel_up::
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_Y
	ld l, a
	dec [hl]
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine moves each entity one pixel up.
;; It is useful for scrolling correctly.
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_all_entities_positions_one_pixel_up::
	ld hl, move_entity_one_pixel_up
	call man_entity_for_each
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine flips the sprite of the E-th
;; and changes its Vx speed and its Vy to point
;; towards the player.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

apply_enemy_intelligent_behavior::
	
	ld a, [Player.wPlayerX]
	ld b, a

	; Compare coordinates X
	ld h, CMP_SPRIT_H
	ld a, e
	add SPR_X
	ld l, a
	ld a, [hl] ; Entity position

	cp b
	jr nc, .left_oriented

	.right_oriented:

		; Set orientation
		ld h, CMP_SPRIT_H
		ld a, e
		add SPR_ATTR
		ld l, a
		set E_BIT_FLIP_X, [hl] ; 1 means flipped
		
		; Set vertical speed
		ld h, CMP_PHYS_H
		ld a, e
		add PHY_VX
		ld l, a

		ld a, [hl]
		call abs_value_a
		ld [hl], a

	ret

	.left_oriented:

		ld h, CMP_SPRIT_H
		ld a, e
		add SPR_ATTR
		ld l, a
		res E_BIT_FLIP_X, [hl] ; 0 means original

		; Set vertical speed
		ld h, CMP_PHYS_H
		ld a, e
		add PHY_VX
		ld l, a

		ld a, [hl]
		call abs_value_a
		call oposite_of_a
		ld [hl], a

	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine flips the sprite of intelligent 
;; enemies so look at the player.
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

apply_intelligent_behavior_to_enemies::
	ld hl, apply_enemy_intelligent_behavior
	call man_entity_for_each_intelligent_enemy
	ret