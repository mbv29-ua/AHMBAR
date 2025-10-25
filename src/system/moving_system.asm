INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

DEF PLAYER_HEIGHT EQU 8
DEF PLAYER_WIDTH  EQU 8

SECTION "Moving system variables", WRAM0

temporal_new_y_position: DS 1
temporal_new_x_position: DS 1 


SECTION "Moving system", ROM0


; e index
set_grounded::
	ld h, CMP_ATTR_H
	ld a, e
	add PHY_FLAGS
	ld l, a
    set PHY_FLAG_GROUNDED, [hl]
    res PHY_FLAG_JUMPING, [hl]
    ret

unset_grounded::
	ld h, CMP_ATTR_H
	ld a, e
	add PHY_FLAGS
	ld l, a
    res PHY_FLAG_GROUNDED, [hl]
    ret

set_speed_to_zero:
	ld h, CMP_PHYS_H
	ld l, e
	xor a	
	ld [hl+], a      ; vy = 0
	ld [hl], a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine computes the expected position
;; for the E-th entity position.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, C and D

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
;; This routine updates the E-th entity position
;; to snap it to the tile grid and sets vertical
;; speed to 0
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, DE and HL

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

right_tile_snap::
	ld hl, temporal_new_x_position
	ld a, [hl]
	call convert_x_to_tx
	call get_rightmost_x_coordinate_before_tile
	ld hl, temporal_new_x_position
	ld [hl], a
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Moves the entity taking into account speeds
;; and solid tiles.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, B, DE and HL

move_entity::
	call compute_expected_entity_position
	call manage_entity_solid_collision
	call new_update_entity_position
	ret



new_update_all_entities_positions::
	ld hl, move_entity
	call man_entity_for_each ;;; de <- direccion deatributos entidad ;;; Cambiar por man_entity_for_each_movable
	ret




manage_entity_solid_collision::
	.vertical_movement:
		ld hl, temporal_new_y_position
		ld d, CMP_SPRIT_H
		ld a, [de]
		cp [hl] ; current - expected
		jr  z, .horizontal_movement
		jr nc, .check_up

			call new_check_entity_collision_down
			jr nz, .horizontal_movement
			call set_vertical_speed_to_zero
			call down_tile_snap
			call set_grounded

		jr .horizontal_movement
		.check_up:
			call new_check_entity_collision_up
			jr nz, .horizontal_movement
			call set_vertical_speed_to_zero
			call up_tile_snap 
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
			call new_check_entity_collision_right
			ret nz
			call set_horizontal_speed_to_zero
			call right_tile_snap
		ret
		.snap_to_left:
			dec e
			call new_check_entity_collision_left
			ret nz
			call set_horizontal_speed_to_zero
			call left_tile_snap
		ret




