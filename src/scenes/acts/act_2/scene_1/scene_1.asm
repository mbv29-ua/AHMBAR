INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_2/scene_1/act_2_scene_1_constants.inc"
INCLUDE "system/ambar_macros.inc"

MACRO SPAWN_ENEMY_AT
    ld b, FMOD(\2 * 8 + 16 + (256 - A2_L1_INITIAL_SCROLL_Y), 256)
    ld c, FMOD(\1 * 8 +  8 + (256 - A2_L1_INITIAL_SCROLL_X), 256)
	ld hl, \3
	call enemy_spawn
ENDM


SECTION "Act 2 Scene 1 Spawners", ROM0

act_2_scene_1_intro_dialog::
	di
    call set_black_palette
    ld hl, act_2_scene_1_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret


act_2_scene_1_enemy_spawner::

	SPAWN_ENEMY_AT $08, $1A, jumping_frog
	SPAWN_ENEMY_AT $0D, $13, jumping_frog
	SPAWN_ENEMY_AT $0B, $0B, jumping_frog
	SPAWN_ENEMY_AT $1A, $0B, jumping_frog

	SPAWN_ENEMY_AT $12, $1C, jumping_moving_frog

	SPAWN_ENEMY_AT $0F, $07, basic_fly
	SPAWN_ENEMY_AT $11, $06, basic_fly
	SPAWN_ENEMY_AT $13, $08, basic_fly

	ld b, $A0
	ld c, $10
	call bullet_spawn

	ld b, $20
	ld c, $F0
	call bullet_spawn
	ret


init_ambars_act_2_scene_1::
    ; Spawn ambars at specific locations for level 1
    ; Position in tiles (Y, X) -> in pixels (Y*8, X*8)
    
	;SPAWN_AMBAR_AT_TILE $07, $10 
    ;SPAWN_AMBAR_AT_TILE $16, $17 
    ;SPAWN_AMBAR_AT_TILE $19, $0A 

    ret