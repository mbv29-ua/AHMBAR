INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "tile_properties.inc"

SECTION "Solid Collision Detection", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_position
;;; Gets the tile ID at a specific pixel position
;;;
;;; Input:
;;;   B = Y position (pixels)
;;;   C = X position (pixels)
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_position::
    ; Tile X = (X + SCX - 8) / 8
    ldh a, [rSCX]
    add c
    sub 8           ; OAM offset
    srl a
    srl a
    srl a
    ld e, a         ; E = Tile X

    ; Tile Y = (Y + SCY - 17) / 8
    ldh a, [rSCY]
    add b
    sub 17
    srl a
    srl a
    srl a
    ld d, a         ; D = Tile Y

    ; Calculate tilemap offset: Tile Y * 32 + Tile X
    ; Using 16-bit arithmetic to avoid overflow
    ; HL = Tile Y * 32
    ld h, 0
    ld l, d         ; HL = Tile Y
    add hl, hl      ; * 2
    add hl, hl      ; * 4
    add hl, hl      ; * 8
    add hl, hl      ; * 16
    add hl, hl      ; * 32

    ; Add Tile X
    ld d, 0         ; DE = Tile X
    add hl, de      ; HL = (Tile Y * 32) + Tile X

    ; Calculate full address: $9800 + offset
    ld de, $9800
    add hl, de

    ; Read tile at position
    ld a, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_entity_position
;;; Gets the tile ID at an entity's specific pixel position
;;;
;;; Input:
;;;   E = Entity index (points to Y component)
;;;   B = Y offset to add to entity's Y position
;;;   C = X offset to add to entity's X position
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE, BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_entity_position::
    ; Get entity Y position
    ld d, CMP_SPRIT_H
    ld a, [de]      ; A = entity Y
    add b           ; Add Y offset
    ld b, a         ; B = final Y position

    ; Get entity X position
    inc e
    ld a, [de]      ; A = entity X
    add c           ; Add X offset
    ld c, a         ; C = final X position
    dec e           ; Restore E to point to entity Y

    ; Now call get_tile_at_position with B=Y, C=X
    call get_tile_at_position
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_entity_position_x
;;; Gets the tile ID at an entity's specific pixel position
;;; VARIANT: E points to X component instead of Y
;;;
;;; Input:
;;;   E = Entity index (points to X component)
;;;   B = Y offset to add to entity's Y position
;;;   C = X offset to add to entity's X position
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE, BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_entity_position_x::
    ; Get entity X position
    ld d, CMP_SPRIT_H
    ld a, [de]      ; A = entity X
    add c           ; Add X offset
    ld c, a         ; C = final X position

    ; Get entity Y position
    dec e
    ld a, [de]      ; A = entity Y
    add b           ; Add Y offset
    ld b, a         ; B = final Y position
    inc e           ; Restore E to point to X

    ; Now call get_tile_at_position with B=Y, C=X
    call get_tile_at_position
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_right
;;; Checks if moving right would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_right::
    ; Check right edge of entity sprite (8x8 tile)
    ; NOTE: E points to X component when called from physics_system
    push de

    ; Get entity X position
    ld d, CMP_SPRIT_H
    ld a, [de]          ; A = entity X
    add 7               ; Add 7 pixels (right edge of 8x8 sprite: 0-7)
    ld c, a             ; C = X position to check

    ; Get entity Y position - check top half
    dec e
    ld a, [de]          ; A = entity Y
    add 2               ; Check at Y+2 (upper part of sprite)
    ld b, a             ; B = Y position to check
    inc e               ; Restore E
    pop de

    push de
    call get_tile_at_position

    ; Check if tile is solid (only 0x80 and 0x81)
    cp $80
    jr z, .is_solid_right
    cp $81
    jr z, .is_solid_right

    ; Top half OK, check bottom half at Y+5
    ld d, CMP_SPRIT_H
    ld a, [de]          ; A = entity X
    add 7               ; Right edge again
    ld c, a             ; C = X position to check

    dec e
    ld a, [de]          ; A = entity Y
    add 5               ; Check at Y+5 (lower part of sprite)
    ld b, a             ; B = Y position to check
    inc e               ; Restore E

    call get_tile_at_position

    ; Check if tile is solid
    cp $80
    jr z, .is_solid_right
    cp $81
    jr z, .is_solid_right

    ; Not solid
    xor a               ; Z = 1 (no collision)
    pop de
    ret

.is_solid_right:
    xor a
    dec a               ; Z = 0 (collision)
    pop de
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_left
;;; Checks if moving left would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_left::
    ; Check left edge of entity sprite (8x8 tile)
    ; NOTE: E points to X component when called from physics_system
    push de

    ; Get entity X position
    ld d, CMP_SPRIT_H
    ld a, [de]          ; A = entity X
    or a                ; Check if X = 0
    jr z, .at_edge      ; If at edge, treat as solid
    ld c, a             ; C = X position (left edge: pixel 0)

    ; Get entity Y position - check top half
    dec e
    ld a, [de]          ; A = entity Y
    add 2               ; Check at Y+2 (upper part of sprite)
    ld b, a             ; B = Y position to check
    inc e               ; Restore E
    pop de

    push de
    call get_tile_at_position

    ; Check if tile is solid (only 0x80 and 0x81)
    cp $80
    jr z, .is_solid_left
    cp $81
    jr z, .is_solid_left

    ; Top half OK, check bottom half at Y+5
    ld d, CMP_SPRIT_H
    ld a, [de]          ; A = entity X
    ld c, a             ; Left edge again

    dec e
    ld a, [de]          ; A = entity Y
    add 5               ; Check at Y+5 (lower part of sprite)
    ld b, a             ; B = Y position to check
    inc e               ; Restore E

    call get_tile_at_position

    ; Check if tile is solid
    cp $80
    jr z, .is_solid_left
    cp $81
    jr z, .is_solid_left

    ; Not solid
    xor a               ; Z = 1 (no collision)
    pop de
    ret

.is_solid_left:
.at_edge:
    xor a
    dec a               ; Z = 0 (collision)
    pop de
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_down
;;; Checks if moving down would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;;   A = Tile ID (if needed)
;;; Destroys: BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_down::
    ; Check bottom edge of entity sprite (8x8 tile)
    push de
    ld d, CMP_SPRIT_H
    ld a, [de]          ; A = entity Y
    add 7               ; Add 7 pixels (bottom edge of 8x8 sprite: 0-7)
    ld b, a             ; B = Y position to check

    ; Get entity X position
    inc e
    ld a, [de]          ; A = entity X

    ; Check LEFT side (X+1)
    inc a               ; X + 1 (left part of sprite, avoiding extreme edge)
    ld c, a             ; C = X position to check
    dec e               ; Restore E
    pop de

    push de
    push bc             ; Save B (Y position)
    call get_tile_at_position
    pop bc              ; Restore B

    ; Check if left side tile is solid (only 0x80 and 0x81)
    cp $80
    jr z, .is_solid_down
    cp $81
    jr z, .is_solid_down

    ; Left OK, now check RIGHT side (X+6)
    ld d, CMP_SPRIT_H
    inc e
    ld a, [de]          ; A = entity X
    add 6               ; X + 6 (right part of sprite, avoiding extreme edge)
    ld c, a             ; C = X position to check
    dec e               ; Restore E

    push bc             ; Save BC before second call
    call get_tile_at_position
    pop bc              ; Restore BC

    ; Check if right side tile is solid (only 0x80 and 0x81)
    cp $80
    jr z, .is_solid_down
    cp $81
    jr z, .is_solid_down

    ; Both sides are air - not solid
    xor a       ; Z = 1 (no collision)
    pop de
    ret

.is_solid_down:
    xor a
    dec a       ; Z = 0 (collision detected)
    pop de
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_up
;;; Checks if moving up would collide with solid tile
;;;
;;; Input:
;;;   E = Entity index
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_up::
    ; Check top edge of entity sprite (8x8 tile)
    push de
    ld d, CMP_SPRIT_H
    ld a, [de]          ; A = entity Y
    ; Top edge is pixel 0, no offset needed
    ld b, a             ; B = Y position to check

    ; Get entity X position
    inc e
    ld a, [de]          ; A = entity X

    ; Check LEFT side (X+1)
    inc a               ; X + 1 (left part of sprite, avoiding extreme edge)
    ld c, a             ; C = X position to check
    dec e               ; Restore E
    pop de

    push de
    push bc             ; Save positions
    call get_tile_at_position
    pop bc              ; Restore positions

    ; Check if left side tile is solid (only 0x80 and 0x81)
    cp $80
    jr z, .is_solid_up
    cp $81
    jr z, .is_solid_up

    ; Left OK, now check RIGHT side (X+6)
    ld d, CMP_SPRIT_H
    inc e
    ld a, [de]          ; A = entity X
    add 6               ; X + 6 (right part of sprite, avoiding extreme edge)
    ld c, a             ; C = X position to check
    dec e               ; Restore E

    push bc             ; Save BC before second call
    call get_tile_at_position
    pop bc              ; Restore BC

    ; Check if right side tile is solid (only 0x80 and 0x81)
    cp $80
    jr z, .is_solid_up
    cp $81
    jr z, .is_solid_up

    ; Both sides are air - not solid
    xor a       ; Z = 1 (no collision)
    pop de
    ret

.is_solid_up:
    xor a
    dec a       ; Z = 0 (collision detected)
    pop de
    ret
