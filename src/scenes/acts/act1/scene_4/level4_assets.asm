INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"


SECTION "Level 4 Tiles", ROM0

INCLUDE "system/ambar_macros.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the scene 4.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scene_4_enemy_spawner::
	; call load_darkfrog_tiles

	; ld  b, $78
	; ld  c, $40
	; ld hl, jumping_frog
	; call enemy_spawn

	ret

init_ambars_level4::
    ; Spawn ambars at specific locations for level 4
    ; Position in tiles (Y, X) -> in pixels (Y*8, X*8)
    
	SPAWN_AMBAR_AT_TILE 5, 5
    SPAWN_AMBAR_AT_TILE 10, 10
    SPAWN_AMBAR_AT_TILE 15, 15

    ret