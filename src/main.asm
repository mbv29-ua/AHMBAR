INCLUDE "constants.inc"

SECTION "Entry Point", ROM0[$150]

main::
    di

    call screen_off
    call Clear_VRAM
    call Clear_OAM
    call Load_Level1_Tiles
    call Load_Level1_Map
    call Init_Palettes

    ; Habilitar interrupciones VBlank
    ld a, IEF_VBLANK
    ldh [rIE], a

    ; LCDC: LCD On, BG Tile Data $8000, 
    ld hl, rLCDC
    set 0, [hl] ; Bit 0: LCD Enable

    call screen_on

    ei

.main_loop:
    halt
    nop
    jp .main_loop

Init_Palettes::
    ld a, %11100100
    ldh [rBGP], a
    ldh [rOBP0], a
    ld a, %11100100
    ldh [rOBP1], a
    ret

Clear_VRAM::
    ld hl, $8000
    ld bc, $2000
    xor a
.loop:
    ld [hl+], a
    dec bc
    push af
    ld a, b
    or c
    pop af
    jr nz, .loop
    ret

Clear_OAM::
    ld hl, $FE00
    ld b, 160
    xor a
.loop:
    ld [hl+], a
    dec b
    jr nz, .loop
    ret