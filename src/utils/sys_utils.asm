INCLUDE "constants.inc"
INCLUDE "system/text_manager/text_manager_constants.inc"


SECTION "System utils", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine waits until the VBLANK starts.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wait_vblank::
    ld hl, rLY
    ld a, START_VBLANK
    .loop
        cp [hl]
        jr nz, .loop
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans the OAM.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys B and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clean_OAM::
    ld hl, OAM_START
    ld  b, OAM_SIZE
    call memreset_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans the BG MAP memory.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clean_bg_map::
    ld hl, BG_MAP_START
    ld bc, BG_MAP_SIZE
    call memreset_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine turns off the GameBoy LCD.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_off::
    di
    call wait_vblank
    ld hl, rLCDC
    res BIT_PPU_ENABLES, [hl]
    ei
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configurar LCDC completo:
;; Bit 7 = 1: LCD ON
;; Bit 6 = 1: Window Tilemap en $9C00
;; Bit 5 = 1: Window Enable (para HUD en parte inferior)
;; Bit 4 = 0: Tiles en $8800 (signed)
;; Bit 3 = 0: BG Map en $9800
;; Bit 1 = 1: OBJ ON
;; Bit 0 = 1: BG Display ON
;; ld a, %11100011
;; ldh [rLCDC], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine turns off the GameBoy LCD.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_on::
    ld hl, rLCDC
    set 7, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine enables the tilemap in $9C00 used
;; for dialog windows.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_window_dialog::
    ld hl, rLCDC
    set 6, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine display the dialog window
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_hud_on:
    ld hl, rLCDC
    set 5, [hl]
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine display the dialog window
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_hud_off:
    ld hl, rLCDC
    res 5, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine activates the mode to show 
;; sprites in the screen
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_obj_on::
    ld hl, rLCDC
    set 1, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine activates the backgrounds
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_bg_on::
    ld hl, rLCDC
    set 0, [hl]
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_palettes_by_default::
    ld a, DEFAULT_PALETTE
    ldh [rBGP], a
    ldh [rOBP0], a
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; This routine waits a complete x frames (x/60 sec.)
;;
;; INPUT:
;;      B: Frames to wait
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B and HL.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wait_x_frames::
    di
    call wait_a_frame
    dec b    
    jr nz, wait_x_frames
    ei
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_fonts::
    ld hl, fonts
    ld de, VRAM0_START + CHARMAP_START * TILE_SIZE
    ld bc, CHARMAP_SIZE * TILE_SIZE 
    call memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This loads the number tileset in the VRAM.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys BC, DE and HL.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_numbers::
    ld hl, fonts.numbers
    ld de, VRAM0_START + NUMBERS_START * TILE_SIZE
    ld bc, (fonts.end - fonts.numbers) * TILE_SIZE / 2
    call memcpy_65536

    ld hl, fonts.a
    ld de, VRAM0_START + (NUMBERS_START+10) * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256

    ld hl, fonts.l
    ld de, VRAM0_START + (NUMBERS_START+11) * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the heart tiles for the HUD
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys BC, DE and HL.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_heart_tiles::
    ; Cargar corazón completo en tile $60
    ld hl, fonts.heart_full
    ld de, VRAM0_START + $60 * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256

    ; Cargar medio corazón en tile $61
    ld hl, fonts.heart_half
    ld de, VRAM0_START + $61 * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256

    ret

load_ambar_tile::
    ; Cargar corazón completo en tile $D0
    ld hl, ambar.start
    ld de, VRAM0_START + $62 * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine resets the scroll.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reset_scroll::
    xor a
    ldh [rSCY], a
    ldh [rSCX], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine disable the hud screen.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys HL. Must be called in VBlank
;;          or with the LCD of
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

disable_hud_screen::
    ld hl, rLCDC
    res 5, [hl]
    ret