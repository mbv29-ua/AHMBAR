INCLUDE "constants.inc"

SECTION "Act 3 Scene 1", ROM0

act_3_scene_1_intro_dialog::
	di
    call set_black_palette
    ld hl, act_2_scene_1_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret

act_3_scene_1_enemy_spawner::
	ld  b, $1D * 8 - 112
	ld  c, $0D * 8 - 0
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $1D * 8 - 112
	ld  c, $15 * 8 - 0
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $58
	ld  c, $14
	ld hl, basic_fly
	call enemy_spawn
	ret