INCLUDE "constants.inc"

SECTION "Act 3 Scene 3 configuration", ROM0

act_3_scene_3::

.starting_y: 			DB 		128 					; SCENE_PLAYER_STARTING_Y
.starting_x: 			DB 		16						; SCENE_PLAYER_STARTING_X
.initial_scroll_y: 		DB	 	112 					; SCENE_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		0						; SCENE_STARTING_SCREEN_SCROLL_X
.tileset:				DW_BE 	tiles			; SCENE_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(tiles_end-tiles)		; SCENE_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; SCENE_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	act_3_scene_3_tilemap	    ; SCENE_TILEMAP ; Se almacen como HIGH/LOW
.goal_y: 				DB 		0						; SCENE_GOAL_POINT_X
.goal_x:				DB 		0						; SCENE_GOAL_POINT_Y
.next_scene:			DW_BE 	act_1_scene_1			; SCENE_NEXT_SCENE
.scene_enemy_spawner:	DW_BE 	0	; SCENE_ENEMY_SPAWNER
.scene_collectible_spawner: DW_BE	0	; SCENE_COLLECTIBLE_SPAWNER
.act_number:			DB 		3						; SCENE_ACT_NUMBER
.level_number:			DB 		2						; SCENE_LEVEL_NUMBER
.background_animation:	DW_BE	no_animation			; SCENE_ANIMATION_ROUTINE
.next_level_trigger:	DW_BE	check_door_collision	; SCENE_NEXT_LEVEL_TRIGGER
.intro_scene:			DW_BE	no_dialog ; SCENE_INTRO_DIALOG