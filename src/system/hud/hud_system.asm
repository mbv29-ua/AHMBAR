INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "utils/joypad.inc"

SECTION "HUD System", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; HUD Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tile indices
DEF TILE_HEART_FULL  EQU $D0    ; Corazón completo
DEF TILE_HEART_HALF  EQU $D1    ; Medio corazón
DEF TILE_EMPTY       EQU $80    ; Tile vacío
; TILE_BULLET ya definido en constants.inc como $09

; HUD positions in Window tilemap
DEF HUD_ROW          EQU 0      ; Primera fila de la Window
DEF HUD_LIVES_START_X    EQU 1  ; Posición X inicial de corazones
DEF HUD_BULLETS_START_X  EQU 14 ; Posición X inicial de balas

; Player stats
DEF MAX_LIVES        EQU 8      ; 8 medios corazones = 4 corazones completos
; MAX_BULLETS ya definido en constants.inc como 5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init_hud
;;; Inicializa el sistema HUD
;;; - Configura vidas iniciales (8 = 4 corazones)
;;; - Configura balas iniciales (5)
;;; - Configura Window layer para HUD
;;; DEBE llamarse con la pantalla APAGADA
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init_hud::
    ; Inicializar vidas y balas
    ld a, MAX_LIVES
    ld [wPlayerLives], a

    ld a, MAX_BULLETS
    ld [wPlayerBullets], a

    ; Configurar Window para HUD (parte inferior de la pantalla)
    ; WY = 136 (144 - 8 = última fila visible)
    ld a, 136
    ldh [rWY], a

    ; WX = 7 (posición estándar de Window - offset de 7 pixels desde la izquierda)
    ld a, 7
    ldh [rWX], a

    ; NO usar LCD-Stat interrupt, HUD permanece abajo
    ; Limpiar solo la primera fila del tilemap de Window
    call clear_hud_row

    ; Renderizar HUD inicial
    call render_hud

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enable_hud_window
;;; Activa la Window layer en LCDC
;;; DEBE llamarse después de screen_on
;;; Destroys: A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enable_hud_window::
    ld hl, rLCDC
    set 5, [hl]        ; Bit 5: Window enable --> Change mgic number(Warning)
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clear_hud_area
;;; Limpia las primeras 2 filas del tilemap de la Window
;;; Destroys: A, B, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_hud_area::
    ld hl, $9C00        ; Window tilemap start
    ld b, 64            ; 64 tiles (2 filas de 32)
    ld a, TILE_EMPTY
    call memset_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clear_hud_row
;;; Limpia solo la primera fila del tilemap de la Window
;;; Destroys: A, B, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_hud_row::
    ld hl, $9C00        ; Window tilemap start
    ld b, 32            ; 32 tiles (una fila completa)
    ld a, TILE_EMPTY
    call memset_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clear_window_tilemap
;;; Limpia el tilemap de la Window ($9C00-$9FFF)
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_window_tilemap::
    ld hl, $9C00
    ld bc, $400         ; 1024 bytes (32x32 tiles)
    ld a, TILE_EMPTY
    call memset_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_hud
;;; Renderiza el HUD completo (vidas y balas)
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_hud::
    call render_lives
    call render_bullets
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_lives
;;; Renderiza los corazones según las vidas actuales
;;; 8 vidas = 4 corazones completos (D0 D0 D0 D0)
;;; 7 vidas = 3 completos + 1 medio (D0 D0 D0 D1)
;;; 6 vidas = 3 completos (D0 D0 D0)
;;; 5 vidas = 2 completos + 1 medio (D0 D0 D1)
;;; ... etc
;;; 1 vida  = 1 medio corazón (D1)
;;; 0 vidas = vacío
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_lives::
    ; Calcular dirección base en Window tilemap ($9C00 + HUD_LIVES_START_X)
    ld hl, $9C00
    ld bc, HUD_LIVES_START_X
    add hl, bc

    ; Cargar vidas actuales
    ld a, [wPlayerLives]
    ld b, a             ; B = vidas restantes

    ; Renderizar 4 corazones (8 medios corazones)
    ld c, 4             ; C = contador de corazones (4 total)

.loop_heart:
    ; Verificar si quedan >= 2 vidas para corazón completo
    ld a, b
    cp 2
    jr nc, .full_heart

    ; Verificar si queda 1 vida para medio corazón
    cp 1
    jr z, .half_heart

    ; No quedan vidas, corazón vacío
    ld a, TILE_EMPTY
    ld [hl+], a
    jr .next_heart

.full_heart:
    ld a, TILE_HEART_FULL
    ld [hl+], a
    ld a, b
    sub 2               ; Restar 2 vidas
    ld b, a
    jr .next_heart

.half_heart:
    ld a, TILE_HEART_HALF
    ld [hl+], a
    dec b               ; Restar 1 vida
    jr .next_heart

.next_heart:
    dec c
    jr nz, .loop_heart
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_bullets
;;; Renderiza 5 balas en fila (tile $09)
;;; Las balas activas se muestran, las gastadas se muestran vacías
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_bullets::
    ; Calcular dirección base en Window tilemap ($9C00 + HUD_BULLETS_START_X)
    ld hl, $9C00
    ld bc, HUD_BULLETS_START_X
    add hl, bc

    ; Cargar balas actuales
    ld a, [wPlayerBullets]
    ld b, a             ; B = balas restantes

    ; Renderizar 5 balas
    ld c, 5             ; C = contador de balas (5 total)

.loop_bullet:
    ; Verificar si quedan balas
    ld a, b
    or a
    jr z, .empty_bullet

    ; Mostrar bala activa
    ld a, TILE_BULLET
    ld [hl+], a
    dec b               ; Restar 1 bala
    jr .next_bullet

.empty_bullet:
    ; Mostrar espacio vacío
    ld a, TILE_EMPTY
    ld [hl+], a

.next_bullet:
    dec c
    jr nz, .loop_bullet
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; lose_life
;;; Decrementa una vida del jugador
;;; Si llega a 0, game over
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lose_life::
    ld hl, wPlayerLives
    ld a, [hl]

    ; Si ya está en 0, no hacer nada
    cp 0
    ret z

    ; Decrementar vida
    dec [hl]

    ; Si vidas == 0, llamar game_over
    ld a, [hl]
    cp 0
    ret nz
    call game_over
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; use_bullet
;;; Decrementa el contador de balas
;;; Returns: Zero flag set si no hay balas
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
use_bullet::
    ld hl, wPlayerBullets
    ld a, [hl]

    ; Si ya está en 0, retornar con zero flag
    cp 0
    ret z

    ; Decrementar balas
    dec [hl]

    ; Retornar con zero flag cleared (hay balas)
    or a, 1
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; reload_bullets
;;; Recarga todas las balas al máximo
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
reload_bullets::
    ld a, MAX_BULLETS
    ld [wPlayerBullets], a
    call render_bullets
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; wait_for_start
;;; Espera hasta que se presione START
;;; Destroys: A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wait_for_start::
.loop:
    halt
    call read_pad
    ld a, [JUST_PRESSED_BUTTONS]
    bit BUTTON_START, a
    jr z, .loop
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; game_over
;;; Muestra pantalla de Game Over y reinicia el juego
;;; Destroys: ALL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_over::
    call fadeout
    call screen_off

    ; Limpiar pantalla
    call clean_OAM
    call clean_bg_map

    ; Cargar tiles del juego SIN offset (desde tile 0) para Game Over
    ld hl, tiles
    ld de, VRAM0_START  ; Cargar desde $8000 (tile 0)
    ld bc, tiles_end - tiles
    call memcpy_65536

    ; Cargar tilemap de Game Over
    ld hl, GameOver_Map
    ld de, BG_MAP_START
    ld bc, GameOver_Map_End - GameOver_Map
    call memcpy_65536

    ; Ajustar scroll - Y=0, X=32 (un poco a la derecha)
    xor a
    ldh [rSCY], a
    ld a, 32
    ldh [rSCX], a

    ; Desactivar Window (HUD)
    ld a, [rLCDC]
    res 5, a
    ld [rLCDC], a

    ; Encender pantalla solo con BG
    call screen_bg_on
    call screen_on

    ; Esperar que el jugador presione START para continuar
    call wait_for_start

    ; Resetear vidas y balas
    ld a, MAX_LIVES
    ld [wPlayerLives], a
    ld a, MAX_BULLETS
    ld [wPlayerBullets], a

    ; Resetear nivel a 1
    ld a, 1
    ld [wCurrentLevel], a

    call fadeout

    ; Recargar scene_1 completo
    ld hl, scene_1
    call load_scene

    ; Reinicializar enemigos
    call init_enemigos_prueba

    ; SALTAR directamente al main loop
    jp main.main_loop
