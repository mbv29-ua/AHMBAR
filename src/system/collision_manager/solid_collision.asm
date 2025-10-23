INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "tile_properties.inc"

SECTION "Solid Collision Detection", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_left
;;; Checks if moving left would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_left::
    ; Check left edge of entity sprite (8x8 tile)
    ; NOTE: E points to X component when called from physics_system

    ld h, CMP_SPRIT_H
    ld l, e

    ; Get entity Y position
    ld b, [hl] ; B = Y position (left edge: pixel 0)
    inc l

    ld c, [hl] ; C = entity X
    dec c      ; C = next pixel at left
    jr c, .at_edge

    call get_tile_at_position
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Top half OK, check bottom half at Y+7
    ld a, b
    add 7
    ld b, a

    call get_tile_at_position
    call is_tile_solid
    ret                 ; Return result from second check

.at_edge:
    cp a                ; Z = 1 (solid collision at edge)
    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_right
;;; Checks if moving right would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_right::
    ; Check right edge of entity sprite (8x8 tile)
    ; NOTE: E points to X component when called from physics_system

    ld h, CMP_SPRIT_H
    ld l, e

    ; Get entity Y position
    ld b, [hl] ; B = Y position (left edge: pixel 0)
    inc l

    ld a, [hl] ; A = entity X
    add 8 ; 7+1 To see next pixel
    ld c, a
    cp 159 ; At edge
    jr nc, .at_edge

    call get_tile_at_position
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Top half OK, check bottom half at Y+7
    ld a, b
    add 7               ; Right edge again
    ld b, a             ; B = Y+7

    call get_tile_at_position
    call is_tile_solid
    ret                 ; Return result from second check

.at_edge:
    cp a                ; Z = 1 (solid collision at edge)
    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_down
;;; Checks if moving down would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;;   A = Tile ID (if needed)
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_down::
    ; Check bottom edge of entity sprite (8x8 tile)
    ld h, CMP_SPRIT_H
    ld l, e

    ; Get entity Y position
    ld a, [hl]          ; A = Y position (left edge: pixel 0)
    add 8               ; Add 8 pixels to check below the sprite
    ld b, a             ; B = Y position to check

    ; Get entity X position
    inc l
    ld c, [hl]          ; C = entity X

    call get_tile_at_position
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Left OK, now check RIGHT side (X+7)
    ld a, c             ; A = entity X
    add 7               ; X + 7 (right part of sprite)
    ld c, a             ; C = X+7 position to check

    call get_tile_at_position
    call is_tile_solid
    ret                 ; Return result from second check



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_up
;;; Checks if moving up would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag: z=1 if solid, z=0 if not
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_up::
    ld h, CMP_SPRIT_H
    ld l, e

    ; Get entity Y position
    ld a, [hl]          ; A = Y position
    dec a               ; Check pixel above the sprite
    ld b, a             ; B = Y position to check

    ; Get entity X position
    inc l
    ld c, [hl]          ; C = entity X

    call get_tile_at_position
    call is_tile_solid
    ret z               ; Return Z=1 if solid collision found

    ; Left OK, now check RIGHT side (X+7)
    ld a, c             ; A = entity X
    add 7               ; X + 7 (right part of sprite)
    ld c, a             ; C = X+7 position to check

    call get_tile_at_position
    call is_tile_solid
    ret                 ; Return result from second check
