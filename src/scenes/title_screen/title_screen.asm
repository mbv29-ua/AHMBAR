INCLUDE "constants.inc"
INCLUDE "utils/joypad.inc"

SECTION "Title screen scene", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine shows the title screen with menu.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_title_screen::
    call title_screen_init
    
    ; CORRECCIÓN CRUCIAL 1: Habilitar interrupciones globales
    ; Esto permite que el 'halt' despierte tras la VBlank.
    ei 
    
    xor a
    ld [wMenuOption], a
    call draw_menu_selector ; Dibujar selector inicial

.menu_loop:
    call wait_vblank        ; <--- CORRECCIÓN 2: Asegurar VBlank ANTES de leer input
    halt                    ; La CPU duerme y espera la interrupción VBlank
    call read_pad           ; Despierta y actualiza el estado de los botones

    call handle_menu_input ; Mueve wMenuOption
    call draw_menu_selector ; Dibuja el selector (ya contiene wait_vblank, pero se deja por robustez)

    ; Verificación del botón A (asume que BUTTON_A es una máscara de bit, ej: $01)
    ld a, [JUST_PRESSED_BUTTONS]
    and BUTTON_A 
    jr z, .menu_loop 

    ; Verify which option was selected
    ld a, [wMenuOption]
    or a
    jr z, .start_game
    cp 1
    jr z, .show_controls
    cp 2
    jr z, .show_credits
    jr .menu_loop

.start_game:
    call fadeout
    ret

.show_controls:
    ; Mostrar controles
    call clean_bg_map
    ld hl, controls_text
    call write_super_extended_dialog
    call wait_until_A_pressed
    call clean_bg_map
    ld hl, menu_title
    call write_super_extended_dialog
    call draw_menu_selector ; Redibujar selector
    jr .menu_loop

.show_credits:
    ; Mostrar créditos
    call clean_bg_map
    ld hl, credits_screen
    call write_super_extended_dialog
    call wait_until_A_pressed
    call clean_bg_map
    ld hl, menu_title
    call write_super_extended_dialog
    call draw_menu_selector ; Redibujar selector
    jr .menu_loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; title_screen_init
;; Inicializa todo.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

title_screen_init::
    call screen_off
    
    ; CORRECCIÓN: Asegurar que la interrupción VBlank esté activa en el registro IE
    ; (Asumiendo que IEF_VBLANK = $01 y rIE = $FFFF)
    ld a, IEF_VBLANK
    ldh [rIE], a 
    
    call clean_OAM
    call clean_bg_map
    call copy_DMA_routine
    call load_fonts
    call init_palettes_by_default
    call screen_on

    ; Mostrar el menú principal
    ld hl, menu_title
    call write_super_extended_dialog
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; handle_menu_input (REQUIERE MÁSCARAS DE BITS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
handle_menu_input::
    ld a, [JUST_PRESSED_BUTTONS]

    ; Verificar botón ABAJO (asume DPAD_DOWN = $80)
    push af
    and DPAD_DOWN
    jr z, .check_up_reset_a 
    pop af

.move_down:
    ld a, [wMenuOption]
    inc a
    cp 3 
    jr nz, .store_down
    xor a
.store_down:
    ld [wMenuOption], a
    ret 

.check_up_reset_a:
    pop af              ; Recupera el valor original de [JUST_PRESSED_BUTTONS]
    
    ; Verificar botón ARRIBA (asume DPAD_UP = $40)
    and DPAD_UP
    jr z, .no_input

.move_up:
    ld a, [wMenuOption]
    or a
    jr nz, .dec_up
    ld a, 2 
    jr .store_up
.dec_up:
    dec a
.store_up:
    ld [wMenuOption], a
    ret

.no_input:
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; draw_menu_selector
;; Dibuja el selector (asume $B1 es el tile del selector)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_menu_selector::
    call wait_vblank        ; Espera a que termine el VBlank

    ; 1. Borrar selectores
    ld a, $00 

    ld hl, $9800 + (32 * $0E) + $06
    ld [hl], a

    ld hl, $9800 + (32 * $0F) + $06
    ld [hl], a

    ld hl, $9800 + (32 * $10) + $06
    ld [hl], a
    
    ; 2. Dibujar el nuevo selector
    ld a, [wMenuOption]
    ld hl, $9800 + (32 * $0E) + $06 ; Opción 0

    cp 1
    jr z, .draw_controls

    cp 2
    jr z, .draw_credits

    jr .draw_selector

.draw_controls:
    ld hl, $9800 + (32 * $0F) + $06
    jr .draw_selector

.draw_credits:
    ld hl, $9800 + (32 * $10) + $06

.draw_selector:
    ld a, $B1               ; Tile del selector 'x'
    ld [hl], a
    ret