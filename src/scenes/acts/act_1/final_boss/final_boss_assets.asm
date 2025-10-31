INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"


SECTION "Final Boss Tiles", ROM0

INCLUDE "system/ambar_macros.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the final boss scene.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
final_boss_enemy_spawner::
	; call load_boss_tiles

	; ld  b, $78
	; ld  c, $40
	; ld hl, final_boss_entity
	; call enemy_spawn

	ret

init_ambars_final_boss::
    ; Spawn ambars at specific locations for final boss scene
    ; Position in tiles (Y, X) -> in pixels (Y*8, X*8)
    
	SPAWN_AMBAR_AT_TILE 5, 5
    SPAWN_AMBAR_AT_TILE 10, 10
    SPAWN_AMBAR_AT_TILE 15, 15

    ret

act_1_scene_5_dialog_write:: 
	di
    call set_black_palette
    ld hl, act_1_scene_5_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret