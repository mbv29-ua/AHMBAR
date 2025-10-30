INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"


SECTION "Level 1 Tiles", ROMX

INCLUDE "system/ambar_macros.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the scene 1.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scene_1_enemy_spawner::
	ld  b, $78
	ld  c, $40
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $90
	ld  c, $60
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $38
	ld  c, $68
	ld hl, jumping_moving_frog
	call enemy_spawn

	ld  b, $58
	ld  c, $14
	ld hl, basic_fly

	call enemy_spawn
	ret

init_ambars_level1::
    ; Spawn ambars at specific locations for level 1
    ; Position in tiles (Y, X) -> in pixels (Y*8, X*8)
    
	SPAWN_AMBAR_AT_TILE 1, 1
    SPAWN_AMBAR_AT_TILE 10, 10
    SPAWN_AMBAR_AT_TILE 15, 15

    ret