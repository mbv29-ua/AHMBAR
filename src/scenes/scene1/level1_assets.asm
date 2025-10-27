INCLUDE "constants.inc"

SECTION "Level 1 Tiles", ROM0

;Load_Level1_Tiles::
;    ; Cargar tiles desde block.asm
;    ld hl, tiles
;    ld de, VRAM0_START + (VRAM_TILESET_SIZE*TILE_SIZE)
;    ld bc, tiles_end - tiles
;    call memcpy_65536
;    ret

;Load_Level1_Map::
;    ld hl, Level1_Map
;    ld de, BG_MAP_START
;    ld bc, Level1_Map_End - Level1_Map
;    call memcpy_65536
;    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the scene 1.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_1_enemy_spawner::
	call load_darkfrog_tiles

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
	ld hl, jumping_moving_frog
	call enemy_spawn

	ld  b, $58
	ld  c, $14
	ld hl, basic_fly

	call enemy_spawn
	ret