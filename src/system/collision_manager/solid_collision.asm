INCLUDE "constants.inc"
INCLUDE "system/collision_manager/tile_properties.inc"

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

    ; Tile Y = (Y + SCY - 16) / 8
    ldh a, [rSCY]
    add b
    sub 16          ; OAM offset
    srl a
    srl a
    srl a
    ld d, a         ; D = Tile Y

    ; Calculate tilemap offset: Tile Y * 32 + Tile X
    ld a, d
    sla a           ; * 2
    sla a           ; * 4
    sla a           ; * 8
    sla a           ; * 16
    sla a           ; * 32
    add e           ; + Tile X
    ld e, a

    ; Calculate full address: $9800 + offset
    ld hl, $9800
    ld d, 0
    add hl, de

    ; Read tile at position
    ld a, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_right
;;; Checks if moving right would collide with solid tile
;;;
;;; Input:
;;;   None (uses Player position)
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_right::
    ; Check right edge of player sprite
    ld a, [Player.wPlayerY]
    ld b, a
    ld a, [Player.wPlayerX]
    add PLAYER_X_SPEED + 7  ; Right edge + movement
    ld c, a

    call get_tile_at_position
    call is_tile_solid
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_left
;;; Checks if moving left would collide with solid tile
;;;
;;; Input:
;;;   None (uses Player position)
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_left::
    ; Check left edge of player sprite
    ld a, [Player.wPlayerY]
    ld b, a
    ld a, [Player.wPlayerX]
    sub PLAYER_X_SPEED      ; Left edge - movement
    ld c, a

    call get_tile_at_position
    call is_tile_solid
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_down
;;; Checks if moving down would collide with solid tile
;;;
;;; Input:
;;;   None (uses Player position)
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;;   A = Tile ID (if needed)
;;; Destroys: BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_down::
    ; Check bottom edge of player sprite
    ld a, [Player.wPlayerY]
    add 7                   ; Bottom edge + movement (considering gravity)
    ld b, a
    ld a, [Player.wPlayerX]
    add 4                   ; Center of sprite
    ld c, a

    call get_tile_at_position
    call is_tile_solid
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_solid_collision_up
;;; Checks if moving up would collide with solid tile
;;;
;;; Input:
;;;   None (uses Player position)
;;; Output:
;;;   Z flag = clear if collision (blocked), set if free
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_solid_collision_up::
    ; Check top edge of player sprite
    ld a, [Player.wPlayerY]
    sub 2                   ; Top edge - movement
    ld b, a
    ld a, [Player.wPlayerX]
    add 4                   ; Center of sprite
    ld c, a

    call get_tile_at_position
    call is_tile_solid
    ret
