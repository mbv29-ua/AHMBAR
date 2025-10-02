include "constants.inc"

SECTION "Level 1 Tiles", ROM0

Level1_Tiles::
Tile_Empty:
    DB $00,$00,$00,$00,$00,$00,$00,$00
    DB $00,$00,$00,$00,$00,$00,$00,$00

Tile_Ground:
    DB $FF,$FF,$C3,$C3,$BD,$BD,$FF,$FF
    DB $FF,$FF,$BD,$BD,$C3,$C3,$FF,$FF

Tile_Brick:
    DB $FF,$00,$81,$7E,$81,$7E,$FF,$00
    DB $7E,$81,$7E,$81,$00,$FF,$00,$FF

Tile_Sky:
    DB $00,$00,$18,$18,$3C,$24,$00,$00
    DB $00,$00,$00,$00,$00,$00,$00,$00

Tile_Digit_0:
    DB $3C,$3C,$66,$66,$66,$66,$66,$66
    DB $66,$66,$66,$66,$3C,$3C,$00,$00

Tile_Digit_1:
    DB $18,$18,$38,$38,$18,$18,$18,$18
    DB $18,$18,$18,$18,$7E,$7E,$00,$00

Tile_Digit_2:
    DB $3C,$3C,$66,$66,$06,$06,$0C,$0C
    DB $18,$18,$30,$30,$7E,$7E,$00,$00

Tile_Digit_3:
    DB $3C,$3C,$66,$66,$06,$06,$1C,$1C
    DB $06,$06,$66,$66,$3C,$3C,$00,$00

Tile_Digit_4:
    DB $0C,$0C,$1C,$1C,$3C,$3C,$6C,$6C
    DB $7E,$7E,$0C,$0C,$0C,$0C,$00,$00

Tile_Digit_5:
    DB $7E,$7E,$60,$60,$7C,$7C,$06,$06
    DB $06,$06,$66,$66,$3C,$3C,$00,$00

Tile_Bullet:
    DB $00,$00,$18,$18,$3C,$3C,$7E,$7E
    DB $7E,$7E,$3C,$3C,$18,$18,$00,$00

Level1_Tiles_End::

SECTION "Level 1 Map", ROM0

Level1_Map::
    DS 32 * 15, TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_BRICK,TILE_BRICK,TILE_BRICK,TILE_BRICK
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_BRICK,TILE_BRICK
    DB TILE_BRICK,TILE_BRICK,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DS 32, TILE_EMPTY
    DS 32, TILE_GROUND
Level1_Map_End::

Load_Level1_Tiles::
    ld hl, Level1_Tiles
    ld de, $8000
    ld bc, Level1_Tiles_End - Level1_Tiles
    call Copy_Memory
    
    ld hl, Tile_Digit_0
    ld de, $8000 + (TILE_DIGIT_0 * 16)
    ld bc, 16 * 6
    call Copy_Memory
    
    ld hl, Tile_Bullet
    ld de, $8000 + (TILE_BULLET * 16)
    ld bc, 16
    call Copy_Memory
    ret

Load_Level1_Map::
    ld hl, Level1_Map
    ld de, $9800
    ld bc, Level1_Map_End - Level1_Map
    call Copy_Memory
    ret

Copy_Memory:
.loop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret