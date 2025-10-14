INCLUDE "constants.inc"

SECTION "Level 3 Scene", ROM0

Load_Level3_Map::
    ld hl, Level3_Map
    ld de, $9800
    ld bc, Level3_Map_End - Level3_Map
    call memcpy_65536
    ret
