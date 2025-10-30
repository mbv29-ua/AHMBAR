INCLUDE "constants.inc"

SECTION "Final Boss", ROM0

final_boss::

.starting_y: 			DB 		136 					; SCENE_PLAYER_STARTING_Y
.starting_x: 			DB 		16					; SCENE_PLAYER_STARTING_X
.initial_scroll_y: 		DB	 	112 					; SCENE_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		0					; SCENE_STARTING_SCREEN_SCROLL_X
.tileset:				DW_BE 	tiles 		; SCENE_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(tiles_end-tiles-tiles)	; SCENE_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; SCENE_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	Level5_Map			; SCENE_TILEMAP ; Se almacen como HIGH/LOW
.goal_y: 			DB 		0					; SCENE_GOAL_POINT_X
.goal_x:				DB 		0					; SCENE_GOAL_POINT_Y
.next_scene:			DW_BE 	act_2_scene_1			; SCENE_NEXT_SCENE (Assuming act2_1 is the next scene)
.scene_enemy_spawner:	DW_BE 	final_boss_enemy_spawner	; SCENE_ENEMY_SPAWNER
.scene_collectible_spawner: DW_BE	init_ambars_final_boss	; SCENE_COLLECTIBLE_SPAWNER
.act_number:			DB 		1					; SCENE_ACT_NUMBER
.level_number:			DB 		5					; SCENE_LEVEL_NUMBER (Using 5 for final boss)
.background_animation:	DW_BE	update_fire_animation	; SCENE_ANIMATION_ROUTINE
.next_level_trigger:	DW_BE	check_door_collision	; SCENE_NEXT_LEVEL_TRIGGER
