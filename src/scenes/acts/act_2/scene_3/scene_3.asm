INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

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

	ld  b, $90
	ld  c, $60
	ld hl, basic_fly
	call enemy_spawn

	ld  b, $38
	ld  c, $68
	ld hl, basic_fly
	call enemy_spawn

	ld  b, $58
	ld  c, $14
	ld hl, basic_fly

	call enemy_spawn
	ret

INCLUDE "system/ambar_macros.inc"

init_ambars_level3::
    SPAWN_AMBAR_AT_TILE 7, 11
    SPAWN_AMBAR_AT_TILE 25, 12
	ret