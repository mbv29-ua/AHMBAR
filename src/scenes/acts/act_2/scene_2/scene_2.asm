INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Act 2 Scene 2", ROM0

act_2_scene_2_intro_dialog::
	di
    call set_black_palette
    ld hl, act_2_scene_2_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret

act_2_scene_2_enemy_spawner::
	ld  b, $78
	ld  c, $40
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $90
	ld  c, $60
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $38
	ld  c, $68
	ld hl, jumping_frog
	call enemy_spawn


	ld b, (26*8)
	ld c, (23*28)
	call bullet_spawn

	ret

INCLUDE "system/ambar_macros.inc"

init_ambars_level2::
	SPAWN_AMBAR_AT_TILE 14, 15
    SPAWN_AMBAR_AT_TILE 7, 11
	ret