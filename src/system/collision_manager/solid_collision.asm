INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Solid Collision Detection", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Checks if moving left would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_entity_collision_left:: ;; (Y,X) and (Y+7,X)

    ; Check left edge of entity sprite (8x8 tile)
    ; Get entity Y position
    ld hl, temporal_new_y_position
    ld b, [hl] ; B = Y position (left edge: pixel 0)

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld a, [hl] ; A = X position
    ld c, a

    call get_tile_at_position_y_x
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Top half OK, check bottom half at Y+7
    ; Get entity Y position
    ld hl, temporal_new_y_position
    ld a, [hl] ; B = Y position (left edge: pixel 0)
    add 7
    ld b, a

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld c, [hl] ; A = X position

    call get_tile_at_position_y_x
    call is_tile_solid
    ret                 ; Return result from second check


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Checks if moving right would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_entity_collision_right:: ;; (Y,X+7) and (Y+7,X+7)
    ; Check right edge of entity sprite (8x8 tile)
    ; NOTE: E points to X component when called from physics_system

    ; Get entity Y position
    ld hl, temporal_new_y_position
    ld b, [hl] ; B = Y position (left edge: pixel 0)

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld a, [hl]
    add 7
    ld c, a

    call get_tile_at_position_y_x
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Top half OK, check bottom half at Y+7
    ld hl, temporal_new_y_position
    ld a, [hl] ; B = Y position (left edge: pixel 0)
    add 7               ; Right edge again
    ld b, a             ; B = Y+7

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld a, [hl]
    add 7
    ld c, a

    call get_tile_at_position_y_x
    call is_tile_solid
    ret                 ; Return result from second check


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Checks if moving down would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_entity_collision_down:: ;; (Y+7,X) and (Y+7,X+7)
    ; Check bottom edge of entity sprite (8x8 tile)

    ; Get entity Y position
    ld hl, temporal_new_y_position
    ld a, [hl]          ; A = Y position (left edge: pixel 0)
    add 7               ; Add 7 pixels to check below the sprite
    ld b, a             ; B = Y position to check

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld c, [hl]          ; C = entity X

    call get_tile_at_position_y_x
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found
    call is_tile_platform
    ret z               ; Return Z=1 if solid collision found

    ; Left OK, now check RIGHT side (X+7)
    ld hl, temporal_new_y_position
    ld a, [hl]          ; A = Y position (left edge: pixel 0)
    add 7               ; Add 7 pixels to check below the sprite
    ld b, a             ; B = Y position to check

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld a, [hl]          ; C = entity X
    add 7               ; X + 7 (right part of sprite)
    ld c, a             ; C = X+7 position to check

    call get_tile_at_position_y_x
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found
    call is_tile_platform
    ret                 ; Return result from second check


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Checks if moving up would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_entity_collision_up:: ;; (Y,X) and (Y,X+7)

    ; Get entity Y position
    ld hl, temporal_new_y_position
    ld b, [hl]          ; B = Y position

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld c, [hl]          ; C = entity X

    call get_tile_at_position_y_x
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Left OK, now check RIGHT side (X+7)
    ld hl, temporal_new_y_position
    ld b, [hl]          ; B = Y position

    ; Get entity X position
    ld hl, temporal_new_x_position
    ld a, [hl]          ; C = entity X
    add 7               ; X + 7 (right part of sprite)
    ld c, a             ; C = X+7 position to check

    call get_tile_at_position_y_x
    call is_tile_solid
    ret                 ; Return result from second check

