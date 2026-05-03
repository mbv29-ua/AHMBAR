INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_1/scene_1/act_1_scene_1_constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "entities/enemies/enemies.inc"

MACRO SPAWN_ENEMY_AT
    ld b, FMOD(\2 * 8 + 16 + (256 - A1_L1_INITIAL_SCROLL_Y), 256)
    ld c, FMOD(\1 * 8 +  8 + (256 - A1_L1_INITIAL_SCROLL_X), 256)
	ld hl, \3
	call enemy_spawn
ENDM

SECTION "Level 1 Tiles", ROM0

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
	;ld  b, $78
	;ld  c, $40
	;ld hl, jumping_frog
	;call enemy_spawn
	
	;SPAWN_ENEMY_AT $0A, $0A, basic_fly
	SPAWN_ENEMY_AT $0C, $0B, basic_fly
	SPAWN_ENEMY_AT $09, $02, basic_fly
	SPAWN_ENEMY_AT $1C, $05, basic_fly
	;SPAWN_ENEMY_AT $01, $14, basic_fly
	;SPAWN_ENEMY_AT $03, $13, basic_fly

	SPAWN_ENEMY_AT $07, $1B, jumping_frog
	;SPAWN_ENEMY_AT $0F, $19, jumping_frog
	SPAWN_ENEMY_AT $0E, $12, jumping_frog
	SPAWN_ENEMY_AT $10, $04, jumping_frog

	;ld  b, $38
	;ld  c, $68
	;ld hl, jumping_moving_frog
	;call enemy_spawn
	SPAWN_ENEMY_AT $1A, $1B, jumping_moving_frog

	ret

init_ambars_level1::
    ; Spawn ambars at specific locations for level 1
    ; Position in tiles (Y, X) -> in pixels (Y*8, X*8)
    
	;SPAWN_AMBAR_AT_TILE 1, 1
    ;SPAWN_AMBAR_AT_TILE 10, 10
    ;SPAWN_AMBAR_AT_TILE 15, 15

    ret

act_1_scene_1_dialog_write:: 
	; Act dialog
	;di
    ;call set_black_palette
    ld hl, act_1_intro_dialog
    call write_super_extended_dialog
    ;ei
    ;call wait_until_A_pressed
    ;di
	;call clean_dialog_box
    
	; Scene dialog
	ld hl, act_1_scene_1_dialog
    call write_super_extended_dialog
    ;ei
    ;call wait_until_A_pressed
    ret