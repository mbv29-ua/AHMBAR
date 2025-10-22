INCLUDE "constants.inc"

SECTION "HUD System", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; HUD Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tile indices (not VRAM addresses)
DEF TILE_HEART_FULL  EQU $8F    ; Corazón completo (tile index)
DEF TILE_HEART_HALF  EQU $90    ; Medio corazón (tile index)
DEF TILE_EMPTY       EQU $80    ; Tile vacío (primer tile del banco de tiles)

DEF HUD_LIVES_START_X    EQU 1  ; Posición X inicial de corazones
DEF HUD_BULLETS_START_X  EQU 17 ; Posición X del contador de balas

; MAX_BULLETS e INITIAL_PLAYER_LIVES están definidos en constants.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init_hud
;;; Inicializa el sistema HUD
;;; - Configura vidas iniciales (4)
;;; - Configura balas iniciales (5)
;;; - Activa la Window layer
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init_hud::
    ; Inicializar vidas y balas
    ld a, INITIAL_PLAYER_LIVES
    ld [wPlayerLives], a

    ld a, MAX_BULLETS
    ld [wPlayerBullets], a

    ; Renderizar HUD inicial usando OAM (sprites)
    call render_hud
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_hud
;;; Renderiza el HUD completo (vidas y balas)
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_hud::
    ; call render_lives  ; TODO: Implementar cuando tengamos tiles de corazones
    call render_bullets
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_lives
;;; Renderiza los corazones según las vidas actuales
;;; 4 vidas = 2 corazones completos
;;; 3 vidas = 1 corazón completo + 1 medio
;;; 2 vidas = 1 corazón completo
;;; 1 vida  = 1 medio corazón
;;; 0 vidas = vacío
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_lives::
    ; Calcular dirección base en Window tilemap ($9C00)
    ld hl, $9C00  ; Window tilemap start
    ld bc, HUD_LIVES_START_X
    add hl, bc

    ld a, [wPlayerLives]

    ; Corazón 1
    cp 2
    jr c, .heart1_half_or_empty  ; Si vidas < 2, check medio o vacío
    ; Corazón completo
    ld [hl], TILE_HEART_FULL
    jr .heart2

.heart1_half_or_empty:
    cp 1
    jr nz, .heart1_empty
    ; Medio corazón
    ld [hl], TILE_HEART_HALF
    jr .heart2

.heart1_empty:
    ld [hl], TILE_EMPTY

.heart2:
    inc hl  ; Siguiente posición
    ld a, [wPlayerLives]

    cp 4
    jr z, .heart2_full
    cp 3
    jr c, .heart2_empty  ; Si vidas < 3, vacío
    ; Si vidas == 3, medio corazón
    ld [hl], TILE_HEART_HALF
    ret

.heart2_full:
    ld [hl], TILE_HEART_FULL
    ret

.heart2_empty:
    ld [hl], TILE_EMPTY
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; render_bullets
;;; Renderiza el contador de balas (0-5) usando OAM sprite
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_bullets::
    ; Usar OAM_COUNTER (definido en constants.inc como $FE04)
    ld hl, OAM_COUNTER

    ; Y position (arriba de la pantalla)
    ld a, COUNTER_Y_POS  ; Definido en constants.inc
    ld [hl+], a

    ; X position (derecha de la pantalla)
    ld a, COUNTER_X_POS  ; Definido en constants.inc
    ld [hl+], a

    ; Tile - convertir número de balas (0-5) a tile ($95-$9A)
    ld a, [wPlayerBullets]
    add TILE_DIGIT_0  ; $95 + balas = tile correcto
    ld [hl+], a

    ; Attributes (palette 0, no flip)
    ld a, %00010000  ; Usar paleta 1
    ld [hl], a

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

    ; Actualizar HUD
    call render_lives

    ; TODO: Si vidas == 0, llamar game_over
    ld a, [hl]
    cp 0
    ret nz
    ; call game_over  ; Implementar después
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

    ; Actualizar HUD
    call render_bullets

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
