INCLUDE "constants.inc"


SECTION "Act 2 Final Scene", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the final
;; scene of the act 2.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

act_2_final_scene_enemy_spawner::
	call load_rock_tiles

	ld  b, $60
	ld  c, $78
	ld hl, act_2_final_boss

	call enemy_spawn
	ret