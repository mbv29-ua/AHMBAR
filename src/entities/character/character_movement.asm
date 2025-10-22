INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Character Movement", ROM0


update_character_velocities::

    ld a, [PRESSED_BUTTONS]
    ld h, CMP_PHYS_H
    ld l, 0

.handle_jump:
    bit BUTTON_A, a 
    jr z, .movement
    ;; ------ Comprobamos flags ------
    ld d, CMP_ATTR_H
    ld e, PHY_FLAGS
    ld a, [de]

    bit PHY_FLAG_GROUNDED, a ;; SI NO ESTA EN EL SUELO NO SALTA
    jr z, .movement
    bit PHY_FLAG_JUMPING, a ;; SI YA ESTA SALTANDO NO SALTAR
    jr nz, .movement

    ld [hl], -PLAYER_JUMP_SPEED

    ;; actualizamos flags si salto
    res PHY_FLAG_GROUNDED, a ; ya no está en el suelo
    set PHY_FLAG_JUMPING, a  ; ahora está saltando
    ld [de], a              ; GUARDAR flags modificados en memoria!

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
        pop af

    .move_right:
        bit DPAD_RIGHT, a
        jr z, .end
        ld [hl], PLAYER_X_SPEED ; 1
        ; Actualizar dirección del jugador a derecha (1)
        ld a, 1
        ld [wPlayerDirection], a

.end:
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clamp_player_position
;;; Limita la posición del jugador para que no salga de los bordes del mapa
;;; Debe llamarse DESPUÉS de aplicar físicas
;;;
;;; Input: None
;;; Output: None
;;; Destroys: A, HL
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
    cp 152              ; Límite absoluto derecho
    jr c, .check_y_top
    ld a, 152
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




;move_character::
;    call read_pad
;
;    ld hl, PRESSED_BUTTONS
;
;    ; Movimiento ABAJO (incrementa Y del jugador)
;    bit DPAD_DOWN, [hl]
;    jr z, .next1
;    ; Verificar si podemos hacer scroll
;    ldh a, [rSCY]
;    cp 112  ; ¿Estamos en el límite inferior del scroll?
;    jr z, .move_player_down_only
;    ; Primero intentar mover el personaje
;    ld a, [Player.wPlayerY]
;    cp 120  ; Límite inferior de la pantalla para activar scroll
;    jr nc, .try_scroll_down
;
;
;.move_player_down_only:
;    ld a, [Player.wPlayerY]
;    cp 152  ; Límite absoluto inferior de la pantalla
;    jr nc, .next1
;    inc a  ; Incrementar Y mueve hacia abajo
;    ld [Player.wPlayerY], a
;    jr .next1
;.try_scroll_down:
;    ldh a, [rSCY]
;    inc a  ; Incrementar SCY muestra más del mapa inferior
;    ldh [rSCY], a
;
;    .next1:
;    ; Movimiento ARRIBA (decrementa Y del jugador)
;    bit DPAD_UP, [hl]
;    jr z, .next2
;    ; Verificar si podemos hacer scroll
;    ldh a, [rSCY]
;    cp 0  ; ¿Estamos en el límite superior del scroll?
;    jr z, .move_player_up_only
;    ; Primero intentar mover el personaje
;    ld a, [Player.wPlayerY]
;    cp 40  ; Límite superior de la pantalla para activar scroll
;    jr c, .try_scroll_up
;
;
;
;.move_player_up_only:
;    ld a, [Player.wPlayerY]
;    cp 16  ; Límite absoluto superior de la pantalla
;    jr c, .next2
;    dec a  ; Decrementar Y mueve hacia arriba
;    ld [Player.wPlayerY], a
;    jr .next2
;.try_scroll_up:
;    ldh a, [rSCY]
;    dec a  ; Decrementar SCY muestra más del mapa superior
;    ldh [rSCY], a
;
;    .next2:
;    ; Movimiento IZQUIERDA (decrementa X del jugador, actualiza dirección)
;    bit DPAD_LEFT, [hl]
;    jr z, .next3
;    ; Actualizar dirección del jugador a izquierda (0)
;    xor a
;    ld [wPlayerDirection], a
;
;    ; Verificar si podemos hacer scroll
;    ldh a, [rSCX]
;    cp 0  ; ¿Estamos en el límite izquierdo del scroll?
;    jr z, .move_player_left_only
;    ; Primero intentar mover el personaje
;    ld a, [Player.wPlayerX]
;    cp 40  ; Límite izquierdo de la pantalla para activar scroll
;    jr c, .try_scroll_left
;.move_player_left_only:
;    ld a, [Player.wPlayerX]
;    cp 8  ; Límite absoluto izquierdo de la pantalla
;    jr c, .next3
;    dec a  ; Decrementar X mueve hacia la izquierda
;    ld [Player.wPlayerX], a
;    jr .next3
;.try_scroll_left:
;    ldh a, [rSCX]
;    dec a  ; Decrementar SCX muestra más del mapa izquierdo
;    ldh [rSCX], a
;
;    .next3:
;    ; Movimiento DERECHA (incrementa X del jugador, actualiza dirección)
;    bit DPAD_RIGHT, [hl]
;    jr z, .end
;    ; Actualizar dirección del jugador a derecha (1)
;    ld a, 1
;    ld [wPlayerDirection], a
;
;    ; Verificar si podemos hacer scroll
;    ldh a, [rSCX]
;    cp 96  ; ¿Estamos en el límite derecho del scroll?
;    jr z, .move_player_right_only
;    ; Primero intentar mover el personaje
;    ld a, [Player.wPlayerX]
;    cp 120  ; Límite derecho de la pantalla para activar scroll
;    jr nc, .try_scroll_right
;.move_player_right_only:
;    ld a, [Player.wPlayerX]
;    cp 168  ; Límite absoluto derecho de la pantalla
;    jr nc, .end
;    inc a  ; Incrementar X mueve hacia la derecha
;    ld [Player.wPlayerX], a
;    jr .end
;.try_scroll_right:
;    ldh a, [rSCX]
;    inc a  ; Incrementar SCX muestra más del mapa derecho
;    ldh [rSCX], a
;
;    .end:
;    ; Verificar colisión con puerta después de moverse
;    call check_door_collision
;    ret
