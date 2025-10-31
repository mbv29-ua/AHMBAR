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
    ; Saltar a escena de Game Over (no retorna)
    jp scene_game_over


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; scene_game_over
;;; Pantalla de Game Over
;;; Muestra estadísticas y permite reiniciar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_game_over::
    ; ld hl, game_over_sound
    ;; Poner cuando seaposible despues de wait_until_start_pressed

    ; Turn off volume 
    ld a, $00
    ld [$FF26], a

	call hUGE_init

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
    call man_entity_init
    call clean_OAM
    call clean_bg_map

    ; Cargar tilemap de Game Over
    call Load_letras_intro_Tiles
    ld hl, GameOver_Map
    ld de, BG_MAP_START
    ld b, 20
    ld c, 18
    call animation_window
    ; call memcpy_65536

    call reset_scroll
    call disable_hud_screen
    call screen_on

    ret