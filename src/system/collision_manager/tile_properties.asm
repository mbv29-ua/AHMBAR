INCLUDE "system/collision_manager/tile_properties.inc"

SECTION "Tile Properties Functions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_properties
;;; Returns the property flags for a given tile ID
;;;
;;; Input:
;;;   A = Tile ID (0x00-0xFF)
;;; Output:
;;;   A = Property flags byte
;;;   Z flag = set if tile has no properties (empty)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_properties::
    ld hl, tile_properties_table
    ld l, a         ; Use tile ID as offset (HL = $XX00 + tile_id)
    ld a, [hl]      ; Load property byte
    or a            ; Set Z flag if properties == 0
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_solid
;;; Checks if a tile blocks movement
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag = clear if solid, set if not solid
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_solid::
    call get_tile_properties
    bit 0, a        ; Test TILE_PROP_SOLID bit
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_deadly
;;; Checks if a tile kills the player
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag = clear if deadly, set if not deadly
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_deadly::
    call get_tile_properties
    bit 1, a        ; Test TILE_PROP_DEADLY bit
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_door
;;; Checks if a tile is a door/level transition
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag = clear if door, set if not door
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_door::
    call get_tile_properties
    bit 2, a        ; Test TILE_PROP_DOOR bit
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_collectible
;;; Checks if a tile can be collected (hearts, etc.)
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag = clear if collectible, set if not collectible
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_collectible::
    call get_tile_properties
    bit 3, a        ; Test TILE_PROP_COLLECTIBLE bit
    ret
