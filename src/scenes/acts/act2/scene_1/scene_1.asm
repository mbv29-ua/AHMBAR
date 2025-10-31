INCLUDE "constants.inc"
INCLUDE "system/ambar_macros.inc"


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
	ld  b, $70
	ld  c, $48
	ld hl, jumping_frog
	call enemy_spawn

	ld  b, $38
	ld  c, $68
	ld hl, jumping_frog
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

	;ld  b, $E0
	;ld  c, $B0
	;ld hl, basic_fly
	;call enemy_spawn

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
    
	SPAWN_AMBAR_AT_TILE $07, $10 
    SPAWN_AMBAR_AT_TILE $16, $17 
    SPAWN_AMBAR_AT_TILE $19, $0A 

    ret