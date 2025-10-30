INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Character Movement", ROMX


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks the pressed buttons and
;; updates the player speed Vy and Vx according
;; to the inputs.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_character_velocities::
    

.continue:

    call decrement_Jump_cooldown

    call reset_counter_jumps_if_grounded

    ld a, [JUST_PRESSED_BUTTONS]
    ld h, CMP_PHYS_H
    ld l, 0

.handle_jump:
    bit BUTTON_A, a
    jr z, .movement

    ;; ------------------------------
    ;; Comprobamos flags de físicas
    ;; ------------------------------
    ld d, CMP_ATTR_H
    ld e, PHY_FLAGS
    ld a, [de]
    bit PHY_FLAG_GROUNDED, a
    jr nz, .doJump        ; Si está en el suelo => salto permitido


    ;; Primero comprobamos si tiene salto infinito
    ld a, [wPowerupInfiniteJump]
    or a
    jr nz, .cooldown


    ;; ------------------------------
    ;; No está en el suelo => solo si tiene powerup
    ;; ------------------------------
    ld a, [wPowerupDoubleJump]
    or a
    jr z, .movement       ; sin powerup => no hay salto doble

    ld a, [wCounterJump]
    cp 2
    jr nc, .movement      ; ya ha hecho 2 saltos => no más


    .cooldown
    ;; cooldown
    ld l, COUNT_JUMPING_COOLDOWN
    ld h, CMP_CONT_H
    ld a, [hl]
    or a
    jr nz, .movement

.doJump:
    ;; ------------------------------
    ;; Reiniciamos cooldown
    ;; ------------------------------
    ld l, COUNT_JUMPING_COOLDOWN
    ld h, CMP_CONT_H
    ld [hl], 10

    ;; ------------------------------
    ;; Aplicamos velocidad de salto
    ;; ------------------------------
    ld h, CMP_PHYS_H
    ld l, 0
    ld [hl], -PLAYER_JUMP_SPEED
    inc l
    ld [hl], 0

    ;; ------------------------------
    ;; Incrementamos contador de salto
    ;; ------------------------------
    ld a, [wCounterJump]
    inc a
    ld [wCounterJump], a

    ;; ------------------------------
    ;; Actualizamos flags 
    ;; ------------------------------
    ld d, CMP_ATTR_H
    ld e, PHY_FLAGS
    ld a, [de]
    res PHY_FLAG_GROUNDED, a
    ;set PHY_FLAG_JUMPING, a
    ld [de], a

    jr .next
.movement:
    ; No modificar velocidad Y - la gravedad ya la controla el physics_system
    ; Solo manejamos movimiento horizontal

.next:
; Movimiento IZQUIERDA y DERECHA
    ld h, CMP_PHYS_H    ; Asegurar que H apunta a componente física
    ld l, 1             ; Offset 2 = velocidad X
    inc l
    ld [hl], 0          ; reiniciar velocidad X

    ; Recargar botones presionados en A
    ld a, [PRESSED_BUTTONS]

    .move_left:
        bit DPAD_LEFT, a
        jr z, .move_right
        ld [hl], -PLAYER_X_SPEED ; -1
        ; Actualizar dirección del jugador a izquierda (0)
        push af
        ld a, 0
        ld [wPlayerDirection], a

        ;; Change tile direction 
        ld h, CMP_SPRIT_H
        ld l, SPR_ATTR
        set E_BIT_FLIP_X, [hl]

        ;; Update walking counter (needed for animation)
        ld h, CMP_CONT_H
        ld l, COUNT_MOVING_COOLDOWN
        dec [hl]
        pop af

    .move_right:
        bit DPAD_RIGHT, a
        jr z, .end
        ld [hl], PLAYER_X_SPEED ; 1
        ; Actualizar dirección del jugador a derecha (1)
        ld a, 1
        ld [wPlayerDirection], a

        ;; Change tile direction 
        ld h, CMP_SPRIT_H
        ld l, SPR_ATTR
        res E_BIT_FLIP_X, [hl]

        ;; Update walking counter (needed for animation)
        ld h, CMP_CONT_H
        ld l, COUNT_MOVING_COOLDOWN
        dec [hl]
.end:
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clamp_player_position
;; Limits the player position to keep it inside the 
;; limits of the map.
;; Must be called AFTER applying all the physics
;;
;; INPUT
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clamp_player_position::
    ; Límite X izquierdo (mínimo)
    ld a, [Player.wPlayerX]
    cp 8                ; Borde izquierdo de la pantalla
    jr nc, .check_x_right
    ld a, 8
    ld [Player.wPlayerX], a

.check_x_right:
    ; Límite X derecho (máximo)
    ; Si SCX está en su máximo (96), el jugador puede ir hasta 152
    ; Si SCX está en 0, el jugador puede ir hasta 152 también
    ldh a, [rSCX]
    cp 96               ; ¿Scroll en el límite derecho?
    jr nz, .check_y_top

    ; Estamos en el borde derecho del mapa
    ld a, [Player.wPlayerX]
    cp 152 + 8              ; Límite absoluto derecho + offset
    jr c, .check_y_top
    ld a, 152 + 8
    ld [Player.wPlayerX], a

.check_y_top:
    ; Límite Y superior (mínimo)
    ld a, [Player.wPlayerY]
    cp 16               ; Borde superior de la pantalla
    jr nc, .check_y_bottom
    ld a, 16
    ld [Player.wPlayerY], a

.check_y_bottom:
    ; Límite Y inferior (máximo)
    ldh a, [rSCY]
    cp 112              ; ¿Scroll en el límite inferior?
    jr nz, .end

    ; Estamos en el borde inferior del mapa
    ld a, [Player.wPlayerY]
    cp 152              ; Límite absoluto inferior
    jr c, .end
    ld a, 152
    ld [Player.wPlayerY], a

.end:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine decrements the counter that 
;; registers the cooldown between jumps. Set to
;; 30.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
decrement_Jump_cooldown::
    ld l, COUNT_JUMPING_COOLDOWN
    ld h, CMP_CONT_H
    ld a, [hl]
    or a
    ret z
    dec [hl]
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine resets the counter of jumps just 
;; in case that the player is grounded.
;;
;; INPUT
;;      -
;; OUTPUT: wCounterJump 0 or >0
;;      -
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
reset_counter_jumps_if_grounded::
    ld d, CMP_ATTR_H
    ld e, PHY_FLAGS
    ld a, [de]

    bit PHY_FLAG_GROUNDED, a
    ret z          ; si no está en el suelo, saltar
    ld hl, wCounterJump
    ld [hl], 0    ; <-- reseteamos el contador
    ret           

    
