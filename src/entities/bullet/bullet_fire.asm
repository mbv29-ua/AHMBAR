INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

DEF COOLDOWN_STARTING_VALUE EQU 20

SECTION "Bullet System", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine manages the bullet system: 
;; creates bullets when possible and updates
;; cooldown if exists.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC??, DE?? and HL??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_bullet_system::
    call is_magazine_empty
    ret z
    call is_there_cooldown
    jp nz, .cooldown
    call check_button_input_and_shoot
    ret

    .cooldown
    ld hl, wShootingCooldown
    dec [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if there are available bullets
;; by looking at memory position [wPlayerBullets]
;;
;; INPUT
;;      -
;; OUTPUT:
;;      Z=1 if empty, Z=0 if there is at least one bullet
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_magazine_empty::
    ld a, [wPlayerBullets]
    or a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine starts the cooldown after shooting
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_cool_down::
    ; Activar cooldown de 20 frames (~0.33 segundo)
    ld a, COOLDOWN_STARTING_VALUE
    ld [wShootingCooldown], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if there is cooldown
;;
;; INPUT
;;      -
;; OUTPUT:
;;      Z=1 if cooldown, Z=0 otherwise.
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_there_cooldown::
    ld a, [wShootingCooldown]
    or a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if the shoot button is
;; pressed, and fires a bullet if this is the case.
;; Alse, sets cooldown to avoid multiple shots. 
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys ???
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_button_input_and_shoot::
    ld a, [PRESSED_BUTTONS]
    bit BUTTON_B, a
    ret z

    ; Verificar si hay balas disponibles
    call use_bullet      ; Decrementa balas, retorna zero si no hay
    ret z                ; Si no hay balas, retornar sin disparar

    call init_bullet
    call init_cool_down
    ret

