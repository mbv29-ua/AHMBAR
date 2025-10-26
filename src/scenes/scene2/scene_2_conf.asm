INCLUDE "constants.inc"

SECTION "Scene 2", ROM0

scene_2::

.starting_y: 			DB 		$28						; SCENE_PLAYER_STARTING_Y
.starting_x: 			DB 		$40						; SCENE_PLAYER_STARTING_X
.initial_scroll_y: 		DB 		0 						; SCENE_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		0						; SCENE_STARTING_SCREEN_SCROLL_X
.tileset:				DW_BE 	tiles					; SCENE_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(tiles_end-tiles)		; SCENE_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; SCENE_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	Level2_Map				; SCENE_TILEMAP ; Se almacen como HIGH/LOW
.goal_y: 				DB 		0						; SCENE_GOAL_POINT_X
.goal_x:				DB 		0						; SCENE_GOAL_POINT_Y
.next_scene:			DW_BE 	scene_1					; SCENE_NEXT_SCENE
.scene_enemy_spawner:	DW_BE 	scene_2_enemy_spawner	; SCENE_ENEMY_SPAWNER