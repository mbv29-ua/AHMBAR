INCLUDE "constants.inc"

SECTION "Act 2 Scene 3 configuration", ROM0

act_2_scene_3::

.starting_y: 			DB 		136						; SCENE_PLAYER_STARTING_Y
.starting_x: 			DB 		16						; SCENE_PLAYER_STARTING_X
.initial_scroll_y: 		DB	 	112 					; SCENE_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		0						; SCENE_STARTING_SCREEN_SCROLL_X
.tileset:				DW_BE 	city_street				; SCENE_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(city_street.end-city_street.start)		; SCENE_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; SCENE_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	act_2_scene_3_miguel	; SCENE_TILEMAP ; Se almacen como HIGH/LOW
.goal_y: 				DB 		0						; SCENE_GOAL_POINT_X
.goal_x:				DB 		0						; SCENE_GOAL_POINT_Y
.next_scene:			DW_BE 	act_2_final_scene		; SCENE_NEXT_SCENE
.scene_enemy_spawner:	DW_BE 	act_2_scene_3_enemy_spawner	; SCENE_ENEMY_SPAWNER
.act_number:			DB 		2						; SCENE_ACT_NUMBER
.level_number:			DB 		3						; SCENE_LEVEL_NUMBER
.background_animation:	DW_BE	electricity_animation	; SCENE_ANIMATION_ROUTINE
.next_level_trigger:	DW_BE	check_door_collision	; SCENE_NEXT_LEVEL_TRIGGER