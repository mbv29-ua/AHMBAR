INCLUDE "constants.inc"

SECTION "Act 3 Scene 3", ROM0

act_3_scene_3_intro_dialog::
	di
    call set_black_palette
    ld hl, act_2_scene_2_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret

act_3_scene_3_enemy_spawner::
	ld  b, $78
	ld  c, $40
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $38
	ld  c, $68
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $58
	ld  c, $14
	ld hl, basic_fly
	call enemy_spawn
	ret

INCLUDE "system/ambar_macros.inc"

init_ambars_act_3_levels_3::
	SPAWN_AMBAR_AT_TILE 21, 19
    SPAWN_AMBAR_AT_TILE 14, 27
    SPAWN_AMBAR_AT_TILE 5, 20
	ret