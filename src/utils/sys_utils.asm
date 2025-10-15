INCLUDE "constants.inc"

SECTION "sys", ROM0

clean_OAM::
    ld hl, OAM_START
    ld b, OAM_SIZE
    call memreset_256
    ret

wait_vblank::
    ld hl, rLY
    ld a, START_VBLANK
    .loop
        cp [hl]
        jr nz, .loop
    ret

screen_off::
    di
    call wait_vblank
    ld hl, rLCDC
    res BIT_PPU_ENABLES, [hl]
    ei
    ret

screen_on::
    ; Configurar LCDC completo:
    ; Bit 7 = 1: LCD ON
    ; Bit 4 = 0: Tiles en $8800 (signed)
    ; Bit 3 = 0: BG Map en $9800
    ; Bit 1 = 1: OBJ ON
    ; Bit 0 = 1: BG Display ON
    ld a, %10000011
    ldh [rLCDC], a
    ret

init_palettes_by_default::
    ld a, DEFAULT_PALETTE
    ldh [rBGP], a
    ldh [rOBP0], a
    ld a, DEFAULT_PALETTE
    ldh [rOBP1], a
    ret

enable_vblank_interrupts::
    ; Habilitar interrupciones VBlank
    ld a, IEF_VBLANK
    ldh [rIE], a
    ret

enable_screen::
    ; No hace nada, la configuración está en screen_on
    ret

init_scroll::
    ; Inicializar scroll para empezar arriba a la izquierda
    ; SCX = 0 (izquierda)
    xor a
    ldh [rSCX], a

    ; SCY = 0 (arriba)
    ldh [rSCY], a
    ret