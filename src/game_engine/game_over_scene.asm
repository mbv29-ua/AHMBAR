INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

SECTION "Game Over Scene", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; game_over
;;; Llamada cuando el jugador se queda sin vidas
;;; Transiciona a la pantalla de Game Over
;;; NO RETORNA - salta a scene_game_over
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_over::
    ; Hacer fade out
    ; call fadeout


    ; Saltar a escena de Game Over (no retorna)
    jp scene_game_over


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; scene_game_over
;;; Pantalla de Game Over
;;; Muestra estadísticas y permite reiniciar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_game_over::
    call fade_to_black
    call game_over_init
    call fade_to_original

    ; Esperar a que presione START para reiniciar
    call wait_until_start_pressed

    ; Fade out antes de reiniciar
    

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
    call Load_letras_intro_Tiles

    ; Cargar tilemap de Game Over
    ld hl, GameOver_Map
    ld de, BG_MAP_START
    ld bc, GameOver_Map.end - GameOver_Map
    call animation_window_start
    call memcpy_65536

    ; RUTINA DE SYS_UTILS - Reiniciar el scroll
    ; Ajustar scroll: X=0 (derecha), Y=0
    xor a
    ldh [rSCY], a
    ld a, 0
    ldh [rSCX], a

    ; RUTINA DE SYS_UTILS
    ; Desactivar Window (HUD)
    ld a, [rLCDC]
    res 5, a
    ld [rLCDC], a

    call screen_on
    ret