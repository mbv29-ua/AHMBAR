INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "utils/joypad.inc"
INCLUDE "src/system/hud/hud_constants.inc"
INCLUDE "scenes/scene_constants.inc"

SECTION "HUD System", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; HUD Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tile indices
DEF TILE_HEART_FULL  EQU $D0    ; Corazón completo
DEF TILE_HEART_HALF  EQU $D1    ; Medio corazón
DEF TILE_EMPTY       EQU $00    ; Tile vacío
; TILE_BULLET ya definido en constants.inc como $09

; HUD positions in Window tilemap
DEF HUD_ROW          EQU 0      ; Primera fila de la Window
DEF HUD_LIVES_START_X    EQU 1  ; Posición X inicial de corazones
DEF HUD_BULLETS_START_X  EQU 13 ; Posición X inicial de balas
DEF HUD_ACT_LEVEL_X      EQU 8  ; Posición X del indicador A#L#

; MAX_LIVES y MAX_BULLETS definidos en constants.inc

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
;;; Renderiza el HUD completo (vidas, balas, nivel)
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_hud::
    ; call render_separator_line
    call render_lives
    call render_bullets
    call render_act_level
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
;; TODO : SPLIT BULLET GAME AND BULLET HUD
;; - init_bullet_hud
;; - update_bullet_hud

render_bullets::

    ;call wait_vblank
    ; DEBUG: Mostrar número de balas en decimal primero
    ld hl, $9C00 + HUD_BULLETS_START_X - 2
    ld a, [wPlayerBullets]
    add 188  ; 188 = tile '0'
    ld [hl+], a

    ; Espacio
    ld a, 198
    ld [hl+], a

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

    ; Marcar que HUD necesita actualizarse
    push hl
    ld a, 1
    ld [wHUDNeedsUpdate], a
    pop hl

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

    ; Marcar que HUD necesita actualizarse (no renderizar aquí por VRAM timing)
    ld a, 1
    ld [wHUDNeedsUpdate], a

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

    ; Marcar que HUD necesita actualizarse
    ld a, 1
    ld [wHUDNeedsUpdate], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; update_hud_if_needed
;;; Actualiza el HUD si la flag wHUDNeedsUpdate está activada
;;; DEBE llamarse durante VBlank
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_hud_if_needed::
    ld a, [wHUDNeedsUpdate]
    or a
    ret z  ; Si flag = 0, no hacer nada

    ; Limpiar flag
    xor a
    ld [wHUDNeedsUpdate], a

    ; Actualizar HUD completo
    call render_hud
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_separator_line
;;; Dibuja una línea horizontal de píxeles en la primera fila del HUD
;;; para separar visualmente el juego del HUD
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_separator_line::
    ; Dibujar línea en la primera fila de Window tilemap
    ; Usar tile $81 (o el que sea una línea horizontal en tus tiles)
    ld hl, $9C00        ; Window tilemap start
    ld b, 32            ; 32 tiles (ancho completo)
    ld a, $81           ; Tile de línea horizontal (ajustar según tus tiles)
.draw_line:
    ld [hl+], a
    dec b
    jr nz, .draw_line
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_level_number
;;; Renderiza "LV X" donde X es el número de nivel actual
;;; Centrado en el HUD
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_level_number::
    ; Posición centrada: columna 14-16 (centro de 32 tiles)
    ld hl, $9C00 + 14   ; Primera fila, columna 14

    ; Escribir "L" (tile 139 = L)
    ld a, 139
    ld [hl+], a

    ; Escribir "V" (tile 149 = V)
    ld a, 149
    ld [hl+], a

    ; Espacio
    ld a, 198
    ld [hl+], a

    ; Número del nivel actual (1, 2, 3...)
    ld a, [wCurrentLevel]
    add 188             ; 188 = tile '0', así 1+188=189='1'
    ld [hl], a

    ; DEBUG: Mostrar tile bajo el jugador (columnas 20-22)
    ld hl, $9C00 + 20
    ; Texto "T:"
    ld a, 147  ; T
    ld [hl+], a
    ld a, 186  ; :
    ld [hl+], a

    ; Obtener tile bajo jugador y mostrar en hex
    push hl
    call get_tile_at_player_position
    pop hl
    ; A contiene el tile ID
    ; Mostrar los dos dígitos hex
    push af
    srl a
    srl a
    srl a
    srl a
    ; A = nibble alto
    cp 10
    jr c, .digit_high
    add 128 - 10  ; A-F
    jr .write_high
.digit_high:
    add 188  ; 0-9
.write_high:
    ld [hl+], a

    pop af
    and $0F
    ; A = nibble bajo
    cp 10
    jr c, .digit_low
    add 128 - 10  ; A-F
    jr .write_low
.digit_low:
    add 188  ; 0-9
.write_low:
    ld [hl], a

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_act_level
;;; Renderiza "A#L#" en el centro del HUD
;;; Ejemplo: A1L3 para Acto 1, Nivel 3
;;; Tiles: números $70-$79, A=$7A, L=$7B
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_act_level::
    ; Obtener información de la escena actual
    call get_current_scene_info_address  ; HL = dirección de escena actual
    push hl

    ; Cargar número de acto
    ld de, SCENE_ACT_NUMBER
    add hl, de
    ld b, [hl]  ; B = número de acto

    ; Cargar número de nivel
    pop hl
    push hl
    ld de, SCENE_LEVEL_NUMBER
    add hl, de
    ld c, [hl]  ; C = número de nivel

    pop hl

    ; Posición centrada en el HUD usando HUD_ACT_LEVEL_X
    ; Formato: A # L #
    ld hl, $9C00
    ld de, HUD_ACT_LEVEL_X
    add hl, de

    ; Escribir "A" (tile $7A)
    ld a, $7A
    ld [hl+], a

    ; Escribir número de acto (B contiene el número)
    ld a, b
    add $70  ; Convertir número a tile ($70 = '0', $71 = '1', etc.)
    ld [hl+], a

    ; Escribir "L" (tile $7B)
    ld a, $7B
    ld [hl+], a

    ; Escribir número de nivel (C contiene el número)
    ld a, c
    add $70  ; Convertir número a tile
    ld [hl], a

    ret
