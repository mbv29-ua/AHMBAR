INCLUDE "constants.inc"
INCLUDE "entities/enemies/enemies.inc"

SECTION "Jumping frog", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file contains the definition of a static 
;; frog enemy. It jumps in the same position.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

jumping_frog::

.initial_tile: 			DB FROG_TILE 	;; ENEMY_TILE
.initial_sprite_attrs: 	DB  0		 	;; ENEMY_INITAL_SPRITE_ATTRIBUTES
.initial_y_speed: 		DB -2 		 	;; ENEMY_INITIAL_VY_SPEED
.initial_x_speed: 		DB  0		 	;; ENEMY_INITIAL_VX_SPEED

.enemy_flags: DB %00001000 				;; ENEMY_FLAGS
;; 3 E_BIT_INTELLIGENT_ENEMY

.enemy_interaction: DB %11011100 		;; ENEMY_ENVIRONMENT_INTERACTION
; 7 E_BIT_MOVABLE
; 6 E_BIT_GRAVITY
; 5 E_BIT_DIES_OUT_OF_SCREEN
; 4 E_BIT_COLLIDABLE
; 3 E_BIT_DAMAGEABLE
; 2 E_BIT_STICK_TO_EDGES

.enemy_life: DB 	1 					;; ENEMY_LIFE
.enemy_height: DB   8                   ;; ENEMY_HEIGHT
.enemy_width:  DB   8                   ;; ENEMY_WIDTH 
.enemy_AI_1: DW_BE	AI_jumping_enemy 	;; ENEMY_AI_1
.enemy_AI_2: DW_BE 	No_AI				;; ENEMY_AI_2
.enemy_AI_3: DW_BE  No_AI				;; ENEMY_AI_2

.end_definition:


load_frog_tiles::
    ld hl, frog_tile
    ld de, (VRAM0_START+FROG_TILE*TILE_SIZE)
    ld bc, frog_tile.end - frog_tile.start
    call memcpy_65536
    ret