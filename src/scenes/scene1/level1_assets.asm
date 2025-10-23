INCLUDE "constants.inc"

SECTION "Level 1 Tiles", ROM0

Load_Level1_Tiles::
    ; Cargar tiles desde block.asm
    ld hl, tiles
    ld de, VRAM0_START + (VRAM_TILESET_SIZE*TILE_SIZE)
    ld bc, tiles_end - tiles
    call memcpy_65536
    ret

Load_Level1_Map::
    ld hl, Level1_Map
    ld de, BG_MAP_START
    ld bc, Level1_Map_End - Level1_Map
    call memcpy_65536
    ret