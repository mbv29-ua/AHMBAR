INCLUDE "constants.inc"

SECTION "Level 2 Scene", ROM0

;Load_Level2_Tiles::
;    ; Cargar tiles desde blocks_reordered.asm en $8800 (igual que Level1)
;    ld hl, tiles
;    ld de, VRAM0_START + (VRAM_TILESET_SIZE*TILE_SIZE)
;    ld bc, tiles_end - tiles
;    call memcpy_65536
;    ret
;
;Load_Level2_Map::
;    ld hl, Level2_Map
;    ld de, BG_MAP_START
;    ld bc, Level2_Map_End - Level2_Map
;    call memcpy_65536
;    ret
