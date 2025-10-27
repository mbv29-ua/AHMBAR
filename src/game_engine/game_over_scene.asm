INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

SECTION "Game Over Scene", ROMX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; scene_game_over
;;; Pantalla de Game Over
;;; Muestra estadísticas y permite reiniciar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_game_over::
    call game_over_init

    ; Esperar a que presione START para reiniciar
    call wait_until_start_pressed

    ; Fade out antes de reiniciar
    call fadeout

    ; Reiniciar el juego
    jp restart_game


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; game_over_init
;;; Inicializa la pantalla de Game Over
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_over_init::
    call screen_off

    ; Limpiar sprites OAM completamente
    call clean_OAM
    call clean_bg_map

    ; Cargar tiles del juego SIN offset (desde tile 0)
    ld hl, tiles
    ld de, VRAM0_START
    ld bc, tiles_end - tiles
    call memcpy_65536

    ; Cargar tilemap de Game Over
    ld hl, GameOver_Map
    ld de, BG_MAP_START
    ld bc, GameOver_Map_End - GameOver_Map
    call memcpy_65536

    call init_palettes_by_default

    ; RUTINA DE SYS_UTILS - Reiniciar el scroll
    ; Ajustar scroll: X=32 (derecha), Y=0
    xor a
    ldh [rSCY], a
    ld a, 32
    ldh [rSCX], a

    ; RUTINA DE SYS_UTILS
    ; Desactivar Window (HUD)
    ld a, [rLCDC]
    res 5, a
    ld [rLCDC], a

    call screen_on
    ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; draw_game_over_text
;;; Dibuja "GAME OVER" con tiles de bricks y antorchas
;;; Crea un diseño visual usando los tiles del juego
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: TILEMAP AND MEMCPY_65536
draw_game_over_text::
    ; Marco superior decorativo (fila 4-5)
    ; Fila 4: Línea de bricks
    ld hl, $9800 + (4 * 32) + 6
    ld b, 20
    ld a, $02  ; Brick tile
.top_frame:
    ld [hl+], a
    dec b
    jr nz, .top_frame

    ; Fila 5: Antorchas en las esquinas
    ld hl, $9800 + (5 * 32) + 6
    ld a, $A4  ; Fire tile
    ld [hl], a
    ld hl, $9800 + (5 * 32) + 25
    ld [hl], a

    ; GAME (fila 7) - Dibujado con bricks formando letras
    ; G
    ld hl, $9800 + (7 * 32) + 8
    ld a, $02
    ld [hl+], a
    ld [hl+], a
    inc hl
    ld hl, $9800 + (8 * 32) + 8
    ld [hl], a
    ld hl, $9800 + (9 * 32) + 8
    ld [hl+], a
    ld [hl+], a

    ; A
    ld hl, $9800 + (7 * 32) + 12
    ld a, $02
    ld [hl+], a
    ld [hl+], a
    ld hl, $9800 + (8 * 32) + 12
    ld [hl], a
    inc hl
    ld [hl], a
    ld hl, $9800 + (9 * 32) + 12
    ld [hl], a
    inc hl
    inc hl
    ld [hl], a

    ; M
    ld hl, $9800 + (7 * 32) + 16
    ld a, $02
    ld [hl], a
    inc hl
    inc hl
    inc hl
    ld [hl], a
    ld hl, $9800 + (8 * 32) + 16
    ld [hl], a
    inc hl
    ld [hl], a
    inc hl
    ld [hl], a
    ld hl, $9800 + (9 * 32) + 16
    ld [hl], a
    inc hl
    inc hl
    inc hl
    ld [hl], a

    ; E
    ld hl, $9800 + (7 * 32) + 20
    ld a, $02
    ld [hl+], a
    ld [hl+], a
    ld hl, $9800 + (8 * 32) + 20
    ld [hl+], a
    ld [hl+], a
    ld hl, $9800 + (9 * 32) + 20
    ld [hl+], a
    ld [hl+], a

    ; "PRESS START" con tiles de texto (fila 12)
    ld hl, $9800 + (12 * 32) + 11
    ; P=143, R=145, E=132, S=146, S=146, space=198
    ld a, 143
    ld [hl+], a
    ld a, 145
    ld [hl+], a
    ld a, 132
    ld [hl+], a
    ld a, 146
    ld [hl+], a
    ld a, 146
    ld [hl+], a
    ld a, 198
    ld [hl+], a
    ; S=146, T=147, A=128, R=145, T=147
    ld a, 146
    ld [hl+], a
    ld a, 147
    ld [hl+], a
    ld a, 128
    ld [hl+], a
    ld a, 145
    ld [hl+], a
    ld a, 147
    ld [hl], a

    ; Marco inferior (fila 14)
    ld hl, $9800 + (14 * 32) + 6
    ld b, 20
    ld a, $02
.bottom_frame:
    ld [hl+], a
    dec b
    jr nz, .bottom_frame

    ; Antorchas inferiores
    ld hl, $9800 + (14 * 32) + 6
    ld a, $A5  ; Fire bottom tile
    ld [hl], a
    ld hl, $9800 + (14 * 32) + 25
    ld [hl], a

    ret
