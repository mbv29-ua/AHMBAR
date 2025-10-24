INCLUDE "constants.inc"

SECTION "Scene 1", ROM0

scene_1::

.starting_y: 		DB 144 							; SCENE_PLAYER_STARTING_Y
.starting_x: 		DB 16							; SCENE_PLAYER_STARTING_X
.initial_scroll_y: 	DB 112 							; SCENE_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:	DB 0							; SCENE_STARTING_SCREEN_SCROLL_X
.tileset:			DW tiles 						; SCENE_TILESET ; Se almacen como LOW/HIGH
.tilset_size:		DW (tiles_end-tiles)			; SCENE_TILESET_SIZE ; Se almacen como LOW/HIGH
.tileset_offset:	DW 128 * TILE_SIZE				; SCENE_TILESET_OFFSET ; Se almacen como LOW/HIGH
.tilemap:			DW Level1_Map					; SCENE_TILEMAP ; Se almacen como LOW/HIGH
.goal_x:			DB 0							; SCENE_GOAL_POINT_Y
.goal_y: 			DB 0							; SCENE_GOAL_POINT_X
