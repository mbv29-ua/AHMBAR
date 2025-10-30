INCLUDE "constants.inc"

SECTION "Act 2 Scene 1 Tiles", ROM0

act_2_scene_1_enemy_spawner::
	

	ld  b, $78
	ld  c, $40
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $38
	ld  c, $68
	ld hl, jumping_moving_frog
	call enemy_spawn

	ld  b, $80
	ld  c, $A0
	ld hl, jumping_moving_frog
	call enemy_spawn

	ld  b, $D8
	ld  c, $80
	ld hl, basic_fly
	call enemy_spawn

	ld  b, $D0
	ld  c, $90
	ld hl, basic_fly
	call enemy_spawn

	ld  b, $E8
	ld  c, $A0
	ld hl, basic_fly
	call enemy_spawn

	ld  b, $E0
	ld  c, $B0
	ld hl, basic_fly
	call enemy_spawn
	ret