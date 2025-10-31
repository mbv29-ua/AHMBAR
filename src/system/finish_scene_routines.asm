SECTION "Finish scene routines variables", WRAM0

wFallingObjectCooldown:: DS 1


SECTION "Finish scene routines", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine check if the final boss is dead,
;; otherwise, spawns falling rocks in random 
;; places.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

no_enemies_in_scene::
	ld a, [wNumberOfEnemies]
	or a
	ret nz
	
	ld b, 60
	call wait_x_frames	
	call next_scene
	ret