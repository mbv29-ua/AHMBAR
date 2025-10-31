INCLUDE "constants.inc"
INCLUDE "system/hud/hud_constants.inc"

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

	; Initialize hUGE music driver with music_game
    ld a, $80
    ld [$FF26], a

    ld a, $77
    ld [$FF24], a

    ld a, $FF
    ld [$FF25], a


	ld hl, music_game
	call hUGE_init

	; ld hl, act_1_scene_1
    ; ld hl, act_1_scene_4
    ; ld hl, actact_2_scene_1
    ; ld hl, act_2_scene_2
    ; ld hl, act_2_scene_3
    ; ld hl, act_2_scene_4
    ; ld hl, act_2_final_scene
    ; ld hl, act_3_scene_2
    ; ld hl, act_3_scene_1
    ; ld hl, act_3_scene_3
	
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
    ; Load pseudo-random number generator seed:
    ld hl, wRandomNumber
    ld [hl], 1 ; seed - must be different from 0 

    ; Resetear vidas y balas
    ld a, MAX_LIVES
    ld [wPlayerLives], a

    ld a, MAX_BULLETS
    ld [wPlayerBullets], a

    call reset_score_to_zero ; Reset score to 0 at game start

    ; Resetear nivel a 1
    ld a, 1
    ld [wCurrentLevel], a

    ; Limpiar flags
    xor a
    ld [wHUDNeedsUpdate], a
    ld [wShootingCooldown], a ; Inicializar cooldown de disparo a 0
    ld [wSpikeCooldown], a  ; Inicializar cooldown de picas a 0
    
    ;; valores para hacer pruebas con los saltos
    
    ;ld [wPowerupDoubleJump], a
    
    ld [wPowerupInfiniteJump], a 

    ld a, 1 
    ld [wPowerupDoubleJump], a
    ;ld [wPowerupInfiniteJump], a

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
