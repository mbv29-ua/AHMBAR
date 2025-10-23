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
    ld b, [hl] ; C = Y position (left edge: pixel 0)
    inc l
    
    ld c, [hl] ; C = entity X
    dec c      ; C = next pixel at left     
    jr c, .at_edge 

    call get_tile_at_position
    call is_tile_solid
    ret z
    
    ; Top half OK, check bottom half at Y+7
    ld a, b
    add 7
    ld b, a

    call get_tile_at_position
    call is_tile_solid
    ret

.at_edge:
    xor a
    dec a               ; Z = 0 (collision)
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
    ld b, [hl] ; C = Y position (left edge: pixel 0)
    inc l
    
    ld a, [hl] ; C = entity X
    add 8 ; 7+1 To see next pixel
    ld c, a
    cp 159 ; At edge
    jr c, .at_edge 

    call get_tile_at_position
    call is_tile_solid
    ret z

    ; Top half OK, check bottom half at Y+7
    ld a, b
    add 7               ; Right edge again
    ld b, a             ; B = Y+7

    call get_tile_at_position
    call is_tile_solid    
    ret

.at_edge
    xor a
    dec a               ; Z = 0 (collision)
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
    ld a, [hl]          ; C = Y position (left edge: pixel 0)
    add 7               ; Add 7 pixels (bottom edge of 8x8 sprite: 0-7)
    ld b, a             ; B = Y position to check

    ; Get entity X position
    inc l    
    ld c, [hl]          ; C = entity X
    inc c               ; Check if that point is out of bounds
    jr c, .at_edge 

    call get_tile_at_position
    call is_tile_solid
    ret z

    ; Left OK, now check RIGHT side (X+7)
    ld a, c             ; A = entity X
    add 7               ; X + 7 (right part of sprite)
    ld c, a             ; C = X+7 position to check

    call get_tile_at_position
    call is_tile_solid
    ret 

.at_edge:
    xor a
    dec a       ; Z = 0 (collision detected)
    ret



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
    ld b, [hl]          ; C = Y position (left edge: pixel 0)
    
    ; Get entity X position
    inc l    
    ld c, [hl]          ; C = entity X
    dec c               ; Check if that point is out of bounds
    jr c, .at_edge 

    call get_tile_at_position
    call is_tile_solid
    ret z

    ; Left OK, now check RIGHT side (X+7)
    ld a, c             ; A = entity X
    add 7               ; X + 7 (right part of sprite)
    ld c, a             ; C = X+7 position to check

    call get_tile_at_position
    call is_tile_solid
    ret 

.at_edge:
    xor a
    dec a       ; Z = 0 (collision detected)
    ret
