INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_2/scene_4/act_2_scene_4_constants.inc"
INCLUDE "entities/entities.inc"

MACRO SPAWN_ENEMY_AT
    ld b, FMOD(\2 * 8 + 16 + (256 - A2_L4_INITIAL_SCROLL_Y), 256)
    ld c, FMOD(\1 * 8 +  8 + (256 - A2_L4_INITIAL_SCROLL_X), 256)
	ld hl, \3
	call enemy_spawn
ENDM

SECTION "Act 2 Scene 4", ROM0

act_2_scene_4_intro_dialog::
	;di
    ;call set_black_palette
    ld hl, act_2_scene_4_dialog
    call write_super_extended_dialog
    ;ei
    ;call wait_until_A_pressed
    ret

act_2_scene_4_enemy_spawner::

	SPAWN_ENEMY_AT $11, $07, basic_fly
	SPAWN_ENEMY_AT $02, $11, basic_fly
	SPAWN_ENEMY_AT $0A, $1A, basic_fly
	SPAWN_ENEMY_AT $0C, $19, basic_fly
	SPAWN_ENEMY_AT $16, $19, basic_fly

	SPAWN_ENEMY_AT $05, $11, jumping_frog
	SPAWN_ENEMY_AT $04, $05, jumping_frog
	SPAWN_ENEMY_AT $0A, $10, jumping_frog
	SPAWN_ENEMY_AT $1C, $1D, jumping_frog

	ret

;INCLUDE "system/ambar_macros.inc"

init_ambars_level4_act2::
	;SPAWN_AMBAR_AT_TILE 15, 8
    ;SPAWN_AMBAR_AT_TILE 7, 11
    ;SPAWN_AMBAR_AT_TILE 20, 12
	ret