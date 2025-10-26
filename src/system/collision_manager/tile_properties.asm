INCLUDE "system/collision_manager/collisions.inc"

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
;get_tile_properties::
;    ; Add tile ID as offset to table base address
;    ld hl, tile_properties_table
;    ld d, 0
;    ld e, a         ; DE = tile ID (0-255)
;    add hl, de      ; HL = table base + tile ID
;    ld a, [hl]      ; Load property byte
;    or a            ; Set Z flag if properties == 0
;    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_solid
;;; Checks if a tile blocks movement
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag: z=1 means it is solid, z=0 means it is not
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_solid::
    and TILE_GROUP_MASK
    cp SOLID_TILE
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_deadly
;;; Checks if a tile kills the player
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag: z=1 means it is deadly, z=0 means it is not
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_deadly::
    and TILE_GROUP_MASK
    cp DEADLY_TILE
    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_door
;;; Checks if a tile is a door/level transition
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag: z=1 means it is door, z=0 means it is not
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_door::
    and TILE_GROUP_MASK
    cp DOOR_TILE
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; is_tile_collectible
;;; Checks if a tile can be collected (hearts, etc.)
;;;
;;; Input:
;;;   A = Tile ID
;;; Output:
;;;   Z flag: z=1 means it is collectible, z=0 means it is not
;;;   A = Property flags (preserved for chaining)
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_tile_collectible::
    and TILE_GROUP_MASK
    cp COLLECTIBLE_TILE
    ret

