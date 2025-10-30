INCLUDE "constants.inc"

SECTION "Act 2 Scene 3", ROM0

act_2_scene_3_enemy_spawner::
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

	ld  b, $58
	ld  c, $14
	ld hl, basic_fly

	call enemy_spawn
	ret