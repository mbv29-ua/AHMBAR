INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_2/final_scene.asm/act_2_final_scene_constants.inc"
SECTION "Act 2 Final Scene configuration", ROM0

act_2_final_scene::

.starting_y: 			DB 		$68 					; SCENE_PLAYER_STARTING_Y
.starting_x: 			DB 		$40						; SCENE_PLAYER_STARTING_X
.initial_scroll_y: 		DB	 	A2_L5_INITIAL_SCROLL_Y	; SCENE_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		A2_L5_INITIAL_SCROLL_X	; SCENE_STARTING_SCREEN_SCROLL_X
.tileset:				DW_BE 	city_street				; SCENE_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(city_street.end-city_street.start)		; SCENE_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; SCENE_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	act_2_final_scene_tilemap	; SCENE_TILEMAP ; Se almacen como HIGH/LOW
.music:                 DW_BE   act_2_music             ; SCENE_MUSIC
.next_scene:			DW_BE 	act_3_scene_1					; SCENE_NEXT_SCENE
.scene_enemy_spawner:	DW_BE 	act_2_final_scene_enemy_spawner	; SCENE_ENEMY_SPAWNER
.scene_collectible_spawner: DW_BE	init_ambars_ac2_final					; SCENE_COLLECTIBLE_SPAWNER
.act_number:			DB 		2						; SCENE_ACT_NUMBER
.level_number:			DB 		1						; SCENE_LEVEL_NUMBER
.background_animation:	DW_BE	electricity_animation	; SCENE_ANIMATION_ROUTINE
.next_level_trigger:	DW_BE	no_enemies_in_scene		; SCENE_NEXT_LEVEL_TRIGGER
.intro_scene:			DW_BE	act_2_final_scene_intro_dialog ; SCENE_INTRO_DIALOG