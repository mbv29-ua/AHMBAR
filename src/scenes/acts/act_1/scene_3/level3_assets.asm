INCLUDE "constants.inc"

SECTION "Level 3 Scene", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the scene 3.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_3_enemy_spawner::
	call load_darkfrog_tiles

	; Primera rana - izquierda
	ld  b, $78
	ld  c, $28
	ld hl, jumping_frog
	call enemy_spawn

	; Segunda rana - derecha
	ld  b, $78
	ld  c, $68
	ld hl, jumping_moving_frog
	call enemy_spawn

	ret

act_1_scene_3_dialog_write:: 
	di
    call set_black_palette
    ld hl, act_1_scene_3_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret