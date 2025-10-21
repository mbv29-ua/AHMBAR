;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TILE PROPERTIES SYSTEM
;;; Defines properties for collision detection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Property bit flags (can be combined with OR)
DEF TILE_PROP_SOLID       EQU %00000001  ; Blocks movement (walls, floors, platforms)
DEF TILE_PROP_DEADLY      EQU %00000010  ; Kills player (spikes)
DEF TILE_PROP_DOOR        EQU %00000100  ; Triggers level transition
DEF TILE_PROP_COLLECTIBLE EQU %00001000  ; Can be collected (hearts)

; Common combinations
DEF TILE_PROP_EMPTY       EQU 0
DEF TILE_PROP_WALL        EQU TILE_PROP_SOLID
DEF TILE_PROP_SPIKE       EQU TILE_PROP_SOLID | TILE_PROP_DEADLY
