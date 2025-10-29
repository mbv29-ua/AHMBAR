INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Enemy death animation data", ROM0

DEF ENEMY_DESINTEGRATION_TILE_1 EQU $34
DEF ENEMY_DESINTEGRATION_TILE_2 EQU $35
DEF ENEMY_DESINTEGRATION_TILE_3 EQU $36

desintegrate_animation_tiles::
.start:
	DB ENEMY_DESINTEGRATION_TILE_1, ENEMY_DESINTEGRATION_TILE_2, ENEMY_DESINTEGRATION_TILE_3
.end:

SECTION "Enemy death animation", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the desintegration tiles.
;;
;; INPUT:
;;		-
;; OUTPUT:
;;      -
;; WARNING: Destroys  A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_desintegration_tiles::
    ld hl, desintegration_tiles
    ld de, (VRAM0_START+ENEMY_DESINTEGRATION_TILE_1*TILE_SIZE)
    ld bc, desintegration_tiles.end - desintegration_tiles.start
    call memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine manages a an animation specified
;; in the register BC. Manages up to three tiles
;; in a 0.25 seconds animation.
;;
;; INPUT:
;;		BC: animation tiles address	
;;       E: entity index 
;; OUTPUT:
;;      Z=1 if animation finished, Z=0 otherwise
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_death_animation::
	ld h, CMP_CONT_H
	ld a, e
	add COUNT_DEATH_CLOCK
	ld l, a
	ld a, [hl]
	
	cp 10
	jr nc, .set_tile
	inc bc
	
	cp 5
	jr nc, .set_tile
	inc bc

	.set_tile:
		ld h, CMP_SPRIT_H
		ld a, e
		add SPR_TILE
		ld l, a
		ld a, [bc]
		ld [hl], a
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine manages a desintegration animations
;; of all dying enemies.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      - 
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

manage_death_animations::
	ld hl, desintegration_animation
	call man_entity_for_each_dying
	ret