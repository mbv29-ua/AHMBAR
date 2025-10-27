INCLUDE "system/collision_manager/collisions.inc"

SECTION "Tile Properties Functions", ROM0

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

