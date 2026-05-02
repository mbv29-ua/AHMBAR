INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_2/scene_2/act_2_scene_2_constants.inc"
INCLUDE "entities/entities.inc"

MACRO SPAWN_ENEMY_AT
    ld b, FMOD(\2 * 8 + 16 + (256 - A2_L2_INITIAL_SCROLL_Y), 256)
    ld c, FMOD(\1 * 8 +  8 + (256 - A2_L2_INITIAL_SCROLL_X), 256)
	ld hl, \3
	call enemy_spawn
ENDM


SECTION "Act 2 Scene 2", ROM0

act_2_scene_2_intro_dialog::
	;di
    ;call set_black_palette
    ld hl, act_2_scene_2_dialog
    call write_super_extended_dialog
    ;ei
    ;call wait_until_A_pressed
    ret

act_2_scene_2_enemy_spawner::

	SPAWN_ENEMY_AT $0A, $1A, jumping_frog
	SPAWN_ENEMY_AT $1C, $11, jumping_frog
	SPAWN_ENEMY_AT $15, $0C, jumping_frog
	SPAWN_ENEMY_AT $1B, $1A, jumping_frog
	SPAWN_ENEMY_AT $0A, $06, jumping_frog

	SPAWN_ENEMY_AT $12, $11, jumping_moving_frog
	SPAWN_ENEMY_AT $14, $1A, jumping_moving_frog


	SPAWN_ENEMY_AT $05, $0A, basic_fly
	SPAWN_ENEMY_AT $17, $05, basic_fly

	;ld b, (26*8)+16
	;ld c, (23*28)+56
	;call bullet_spawn


	;ld b, $38
	;ld c, (26*8)+8
	;call bullet_spawn

	ret

;INCLUDE "system/ambar_macros.inc"

init_ambars_level2::
	;SPAWN_AMBAR_AT_TILE 14, 15
    ;SPAWN_AMBAR_AT_TILE 7, 11
	ret