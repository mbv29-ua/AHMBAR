INCLUDE "constants.inc"

SECTION "sys", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans the OAM
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys B and HL

clean_OAM::
    ld hl, OAM_START
    ld b, OAM_SIZE
    call memreset_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine waits until the VBLANK starts
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and HL

wait_vblank::
    ld hl, rLY
    ld a, START_VBLANK
    .loop
        cp [hl]
        jr nz, .loop
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine turns off the GameBoy LCD.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL

screen_off::
    di
    call wait_vblank
    ld hl, rLCDC
    res BIT_PPU_ENABLES, [hl]
    ei
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine turns off the GameBoy LCD.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A

screen_on::
    ; Configurar LCDC completo:
    ; Bit 7 = 1: LCD ON
    ; Bit 6 = 1: Window Tilemap en $9C00
    ; Bit 5 = 1: Window Enable (para HUD en parte inferior)
    ; Bit 4 = 0: Tiles en $8800 (signed)
    ; Bit 3 = 0: BG Map en $9800
    ; Bit 1 = 1: OBJ ON
    ; Bit 0 = 1: BG Display ON
    ld a, %11100011
    ldh [rLCDC], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the default palette for both
;; background tiles and sprites
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A

init_palettes_by_default::
    ld a, DEFAULT_PALETTE
    ldh [rBGP], a
    ldh [rOBP0], a
    ld a, DEFAULT_PALETTE
    ldh [rOBP1], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine enables VBLANK interruptions.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A

enable_vblank_interrupts::
    ; Habilitar solo interrupciones VBlank (LCD-Stat desactivado)
    ; Bit 0: VBlank
    ld a, %00000001     ; Solo bit 0
    ldh [rIE], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine waits a complete frame (~1/60 sec.)
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and HL.

wait_a_frame::
    ld hl, rLY
    ld a, 0
    .loop1
        cp [hl]
        jr nz, .loop1
    Ld a, START_VBLANK
    .loop2
        cp [hl]
        jr nz, .loop2
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This loads the tileset with the fonts in the
;; VRAM.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys BC, DE and HL.

load_fonts::
    ld hl, fonts
    ld de, VRAM0_START + CHARMAP_START * TILE_SIZE
    ld bc, CHARMAP_SIZE * TILE_SIZE 
    call memcpy_65536
    ret








enable_screen::
    ; No hace nada, la configuración está en screen_on
    ret

init_scroll::
    ; Establecer scroll según el nivel actual
    ld a, [wCurrentLevel]
    cp 1
    jr z, .level1_scroll
    cp 2
    jr z, .level2_scroll
    cp 3
    jr z, .level3_scroll
    ; Por defecto, nivel 1
.level1_scroll:
    ld a, LEVEL1_SCX
    ldh [rSCX], a
    ld a, LEVEL1_SCY
    ldh [rSCY], a
    ret

.level2_scroll:
    ld a, LEVEL2_SCX
    ldh [rSCX], a
    ld a, LEVEL2_SCY
    ldh [rSCY], a
    ret

.level3_scroll:
    ld a, LEVEL3_SCX
    ldh [rSCX], a
    ld a, LEVEL3_SCY
    ldh [rSCY], a
    ret


;;;;; No hacer caso aparece asi en el libro! Ejemplo de rutina para actualizar scroll X
;;;;; (no se usa en este juego)
;UpdateSample:
;    halt
;    ld a, [rSCX]
;    inc a
;    ldh [rSCX], a
;
;    ret




