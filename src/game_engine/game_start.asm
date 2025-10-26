INCLUDE "constants.inc"

SECTION "Game start", ROM0


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

    ; Limpiar flag de HUD
    xor a
    ld [wHUDNeedsUpdate], a

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


