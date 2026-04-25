INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_2/scene_3/act_2_scene_3_constants.inc"
INCLUDE "entities/entities.inc"

MACRO SPAWN_ENEMY_AT
    ld b, FMOD(\2 * 8 + 16 + (256 - A2_L3_INITIAL_SCROLL_Y), 256)
    ld c, FMOD(\1 * 8 +  8 + (256 - A2_L3_INITIAL_SCROLL_X), 256)
	ld hl, \3
	call enemy_spawn
ENDM

SECTION "Act 2 Scene 3", ROM0

act_2_scene_3_intro_dialog::
	di
    call set_black_palette
    ld hl, act_2_scene_3_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret

act_2_scene_3_enemy_spawner::

	SPAWN_ENEMY_AT $02, $16, basic_fly
	SPAWN_ENEMY_AT $0B, $1C, basic_fly
	SPAWN_ENEMY_AT $0C, $10, basic_fly
	SPAWN_ENEMY_AT $19, $1B, basic_fly
	SPAWN_ENEMY_AT $12, $06, basic_fly

	SPAWN_ENEMY_AT $18, $09, jumping_frog
	SPAWN_ENEMY_AT $1B, $0D, jumping_frog
	SPAWN_ENEMY_AT $18, $11, jumping_frog
	SPAWN_ENEMY_AT $1B, $15, jumping_frog

	ret

INCLUDE "system/ambar_macros.inc"

init_ambars_level3::
    ;SPAWN_AMBAR_AT_TILE 7, 11
    ;SPAWN_AMBAR_AT_TILE 25, 12
	ret