INCLUDE "constants.inc"

SECTION "Level 1 Tiles", ROM0

Level1_Tiles::

Tile_Empty:
    DB $00,$00,$00,$00,$00,$00,$00,$00
    DB $00,$00,$00,$00,$00,$00,$00,$00

Tile_Ground:
    ; Tile completamente negro (color 3)
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

Tile_Brick:
    DB $FF,$FF,$81,$81,$99,$99,$81,$81
    DB $99,$99,$81,$81,$FF,$FF,$00,$00

Tile_Window:
    DB $7E,$7E,$FF,$FF,$DB,$DB,$DB,$DB
    DB $DB,$DB,$FF,$FF,$7E,$7E,$00,$00

Tile_Pipe:
    DB $3C,$3C,$7E,$7E,$FF,$FF,$FF,$FF
    DB $FF,$FF,$7E,$7E,$3C,$3C,$00,$00

Tile_Cable:
    DB $00,$00,$18,$18,$18,$18,$18,$18
    DB $18,$18,$18,$18,$00,$00,$00,$00

Tile_Platform_Lights:
    DB $FF,$FF,$AA,$AA,$55,$55,$FF,$FF
    DB $24,$24,$24,$24,$FF,$FF,$00,$00

Tile_Warning:
    DB $FF,$00,$7E,$81,$3C,$C3,$18,$E7
    DB $18,$E7,$3C,$C3,$7E,$81,$FF,$00

Tile_Digit_0:
    DB $3C,$3C,$66,$66,$6E,$6E,$76,$76
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
    DB $00,$00,$18,$18,$7E,$7E,$FF,$FF
    DB $FF,$FF,$7E,$7E,$18,$18,$00,$00

Tile_Goal:
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

Level1_Tiles_End::

SECTION "Level 1 Map", ROM0

Level1_Map::
    DS 32 * 2, TILE_EMPTY

    ; Fila con el cuadrado objetivo (meta) en la esquina superior derecha
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_GOAL,TILE_EMPTY

    DB TILE_EMPTY,TILE_EMPTY,TILE_WINDOW,TILE_BRICK,TILE_WINDOW,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_WINDOW,TILE_BRICK,TILE_WINDOW,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_WINDOW,TILE_BRICK,TILE_WINDOW,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_WINDOW,TILE_BRICK,TILE_WINDOW,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    
    DS 32 * 2, TILE_EMPTY
    
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_PIPE,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_CABLE
    DB TILE_EMPTY,TILE_EMPTY,TILE_PIPE,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_CABLE,TILE_EMPTY
    DB TILE_EMPTY,TILE_PIPE,TILE_EMPTY,TILE_EMPTY,TILE_CABLE,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_PIPE,TILE_EMPTY,TILE_EMPTY,TILE_CABLE,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    
    DS 32, TILE_EMPTY
    
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    
    DS 32 * 2, TILE_EMPTY
    
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS,TILE_PLATFORM_LIGHTS
    DB TILE_PLATFORM_LIGHTS,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    
    DS 32 * 2, TILE_EMPTY
    
    DB TILE_BRICK,TILE_BRICK,TILE_EMPTY,TILE_EMPTY,TILE_BRICK,TILE_BRICK,TILE_BRICK,TILE_BRICK
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_BRICK,TILE_BRICK
    DB TILE_BRICK,TILE_BRICK,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_BRICK,TILE_BRICK,TILE_BRICK,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    
    DS 32, TILE_EMPTY
    
    DB TILE_WARNING,TILE_WARNING,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_WARNING,TILE_WARNING
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY
    DB TILE_WARNING,TILE_WARNING,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_WARNING,TILE_WARNING
    DB TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_EMPTY,TILE_WARNING,TILE_WARNING,TILE_EMPTY
    
    DS 32, TILE_GROUND
    
Level1_Map_End::

Load_Level1_Tiles::
    ld hl, Tile_Empty
    ld de, $8000
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Ground
    ld de, $8010
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Brick
    ld de, $8020
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Window
    ld de, $8030
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Pipe
    ld de, $8040
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Cable
    ld de, $8050
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Platform_Lights
    ld de, $8060
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Warning
    ld de, $8070
    ld bc, 16
    call Copy_Memory

    ; Tile vacío en $8080 (tile $08 no usado)
    ld hl, Tile_Empty
    ld de, $8080
    ld bc, 16
    call Copy_Memory

    ld hl, Tile_Bullet
    ld de, $8090
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Digit_0
    ld de, $80A0
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Digit_1
    ld de, $80B0
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Digit_2
    ld de, $80C0
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Digit_3
    ld de, $80D0
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Digit_4
    ld de, $80E0
    ld bc, 16
    call Copy_Memory
    
    ld hl, Tile_Digit_5
    ld de, $80F0
    ld bc, 16
    call Copy_Memory

    ld hl, Tile_Goal
    ld de, $8110
    ld bc, 16
    call Copy_Memory
    ret

Load_Level1_Map::
    ; Llenar todo el mapa con tile GROUND ($01) para prueba
    ld hl, $9800
    ld bc, 32 * 18          ; 32x18 tiles
    ld a, TILE_GROUND
.fill_loop:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .fill_loop_reload
    ret

.fill_loop_reload:
    ld a, TILE_GROUND
    jr .fill_loop

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