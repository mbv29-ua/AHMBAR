INCLUDE "constants.inc"

DEF VERTICAL_ELECTRICITY_TILESET_POSITION   EQU $E1
DEF HORIZONTAL_ELECTRICITY_TILESET_POSITION EQU $E5

SECTION "Electricity tile animation variables", WRAM0 

wElectricityAnimation:: DS 1

SECTION "Electricity tile animation", ROM0


update_electricity_animation::
    ld hl, wElectricityAnimation
    inc [hl]
    bit 2, [hl]
    jr nz, .second_frame

    .first_frame:

    ld de, VRAM0_START+VERTICAL_ELECTRICITY_TILESET_POSITION*TILE_SIZE
    ld hl, electricity_animation_tiles.vertical_electricity_1
    ld  b, TILE_SIZE
    call memcpy_256
    
    ld de, VRAM0_START+HORIZONTAL_ELECTRICITY_TILESET_POSITION*TILE_SIZE
    ld hl, electricity_animation_tiles.horizontal_electricity_1
    ld  b, TILE_SIZE
    call memcpy_256
    ret
    
    .second_frame:

    ld de, VRAM0_START+VERTICAL_ELECTRICITY_TILESET_POSITION*TILE_SIZE
    ld hl, electricity_animation_tiles.vertical_electricity_2
    ld  b, TILE_SIZE
    call memcpy_256
    
    ld de, VRAM0_START+HORIZONTAL_ELECTRICITY_TILESET_POSITION*TILE_SIZE
    ld hl, electricity_animation_tiles.horizontal_electricity_2
    ld  b, TILE_SIZE
    call memcpy_256
    ret