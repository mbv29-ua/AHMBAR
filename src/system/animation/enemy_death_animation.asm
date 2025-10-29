SECTION "Enemy death animation data", ROM0

desintegrate_animation_tiles::
.start:
	;DB ENEMY_DESINTEGRATION_TILE_1, ENEMY_DESINTEGRATION_TILE_2, ENEMY_DESINTEGRATION_TILE_3, EMPTY_TILE
.end:

SECTION "Enemy death animation", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine manages a an animation specified
;; in the register BC.
;;
;; INPUT:
;;      E: entity index 
;; OUTPUT:
;;      Z=1 if animation finished, Z=0 otherwise
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_death_animation::

	ret
	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine manages a desintegration animation
;; for the specified entity.
;;
;; INPUT:
;;      E: entity index 
;; OUTPUT:
;;      - 
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

desintegration_animation::
	ld bc, desintegrate_animation_tiles
	call manage_death_animation
	ret



process_enemy_animation_deaths::
	
	ret