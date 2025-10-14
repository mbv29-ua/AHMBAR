INCLUDE "constants.inc"

SECTION "Level 2 Scene", ROM0



Load_Level2_Map::
    ld hl, Level2_Map
    ld de, $9800
    ld bc, Level2_Map_End - Level2_Map
    call memcpy_65536
    ret
