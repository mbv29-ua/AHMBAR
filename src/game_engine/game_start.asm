INCLUDE "constants.inc"
INCLUDE "system/hud/hud_constants.inc"

SECTION "Game start", ROMX


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine starts the game in the given scene
;;
;; INPUT:
;;      HL: Address of scene.conf
;; OUTPUT:
;;      -   
;; WARNING: Destroys A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start_game::
	call set_initial_memory_values

	; Initialize hUGE music driver with music_game
	ld hl, music_game
	call hUGE_init

	; ld hl, scene_1
    ld hl, scene_1
	call load_scene
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the values of the RAM 
;; variables to its initial values.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_initial_memory_values::
    ; Resetear vidas y balas
    ld a, MAX_LIVES
    ld [wPlayerLives], a

    ld a, MAX_BULLETS
    ld [wPlayerBullets], a

    ; Resetear nivel a 1
    ld a, 1
    ld [wCurrentLevel], a

    ; Limpiar flags
    xor a
    ld [wHUDNeedsUpdate], a
    ld [wSpikeCooldown], a  ; Inicializar cooldown de picas a 0
    ;ld [wPowerup], a
    
    ld a, 1 
    ld [wPowerup], a

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine does a safe restart, setting the
;; STACK POINTER at the stack start. 
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

restart_game::
    di ; No interrupts
    ld sp, $FFFE ; We restart the stack
    jp main ; With jp and no call to avoid filling the stack with unnecesary values
