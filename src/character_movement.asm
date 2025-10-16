INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

DEF SCREEN_OFFSET_VERTICAL      EQU 16
DEF SCREEN_OFFSET_HORIZONTAL    EQU  8
DEF TILE_OFFSET                 EQU  8
DEF SCROLL_OFFSET               EQU 16 ;; Este se puede cambiar

SECTION "Character Movement", ROM0


update_character_velocities::

    ld a, [PRESSED_BUTTONS]
    ld h, CMP_PHYS_H
    ld l, 0

; Movimiento ABAJO y ABAJO
    ld [hl], 0 ; reiniciamos
    
    .move_down:
        bit DPAD_DOWN, a
        jr z, .move_up
        ld [hl], PLAYER_Y_SPEED ; 1

    .move_up:
        bit DPAD_UP, a
        jr z, .next
        ld [hl], -PLAYER_Y_SPEED ; -1

.next:
; Movimiento IZQUIERDA y DERECHA
    inc l
    ld [hl], 0 ; reiniciamos

    .move_left:
        bit DPAD_LEFT, a
        jr z, .move_right
        ld [hl], -PLAYER_X_SPEED ; -1
        ; Actualizar dirección del jugador a izquierda (0)
        ld a, 0
        ld [wPlayerDirection], a

    .move_right:
        ld a, [PRESSED_BUTTONS] ; Por si alguien pulsa izq+der
        bit DPAD_RIGHT, a
        jr z, .end 
        ld [hl], PLAYER_X_SPEED ; 1
        ; Actualizar dirección del jugador a derecha (1)
        ld a, 1
        ld [wPlayerDirection], a

.end
ret
    



;;; Mirar lo de los offsets de la pantalla
scroll_manager::
; Scroll up
.scroll_up
    ; Miramos si ya estamos arriba del todo
    ldh a, [rSCY]
    cp 0
    jr z, .end_scroll_up

    ; El personaje en posicion que activa el scroll up
    ld a, [Player.wPlayerY]
    cp SCROLL_OFFSET + SCREEN_OFFSET_VERTICAL + TILE_OFFSET; Límite superior de la pantalla para activar scroll 
    jr nc, .end_scroll_up

    ; Hacemos scroll up
    ldh a, [rSCY]
    dec a  ; Incrementar SCY muestra más del mapa superior
    ldh [rSCY], a

    ; Retrasamos al jugador para compensar
    ld hl, Player.wPlayerY
    inc [hl]
.end_scroll_up

; Scroll down
.scroll_down
    ; Miramos si ya estamos abajo del todo
    ldh a, [rSCY]
    cp 112
    jr z, .end_scroll_down

    ; El personaje en posicion que activa el scroll down
    ld a, [Player.wPlayerY]
    cp 144 + SCREEN_OFFSET_VERTICAL - SCROLL_OFFSET - TILE_OFFSET; Límite inferior de la pantalla para activar scroll 
    jr c, .end_scroll_down

    ; Hacemos scroll down
    ldh a, [rSCY]
    inc a  ; Incrementar SCY muestra más del mapa inferior
    ldh [rSCY], a

    ; Retrasamos al jugador para compensar
    ld hl, Player.wPlayerY
    dec [hl]
.end_scroll_down

; Scroll right
.scroll_right
    ; Miramos si ya estamos a la derecha del todo
    ldh a, [rSCX]
    cp 96
    jr z, .end_scroll_right

    ; El personaje en posicion que activa el scroll right
    ld a, [Player.wPlayerX]
    cp 160 - SCROLL_OFFSET - SCREEN_OFFSET_HORIZONTAL; Límite derecha de la pantalla para activar scroll 
    jr c, .end_scroll_right

    ; Hacemos scroll right
    ldh a, [rSCX]
    inc a  ; Incrementar SCX muestra más del mapa derecha
    ldh [rSCX], a

    ; Retrasamos al jugador para compensar
    ld hl, Player.wPlayerX
    dec [hl]
.end_scroll_right


; Scroll left
.scroll_left
    ; Miramos si ya estamos a la izquierda del todo
    ldh a, [rSCX]
    cp 0
    jr z, .end_scroll_left

    ; El personaje en posicion que activa el scroll left
    ld a, [Player.wPlayerX]
    cp SCROLL_OFFSET + SCREEN_OFFSET_HORIZONTAL + TILE_OFFSET; Límite izquierda de la pantalla para activar scroll 
    jr nc, .end_scroll_left

    ; Hacemos scroll left
    ldh a, [rSCX]
    dec a  ; Decrementar SCX muestra más del mapa izquierda
    ldh [rSCX], a

    ; Retrasamos al jugador para compensar
    ld hl, Player.wPlayerX
    inc [hl]
.end_scroll_left

ret



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
;.next3:
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
;
;.move_player_right_only:
;    ld a, [Player.wPlayerX]
;    cp 168  ; Límite absoluto derecho de la pantalla
;    jr nc, .end
;
;.try_scroll_right:
;    ldh a, [rSCX]
;    inc a  ; Incrementar SCX muestra más del mapa derecho
;    ldh [rSCX], a
;
;    .end:
;    ret








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





; Verifica si el jugador está tocando un tile de puerta
check_door_collision::
    ; Calcular posición del jugador en el tilemap
    ; Tile X = (Player.wPlayerX + SCX - 8) / 8
    ldh a, [rSCX]
    ld b, a
    ld a, [Player.wPlayerX]
    add b
    sub 8  ; Offset de sprite OAM
    srl a  ; Dividir por 8
    srl a
    srl a
    ld c, a  ; c = Tile X

    ; Tile Y = (Player.wPlayerY + SCY - 16) / 8
    ldh a, [rSCY]
    ld b, a
    ld a, [Player.wPlayerY]
    add b
    sub 16  ; Offset de sprite OAM
    srl a  ; Dividir por 8
    srl a
    srl a
    ld b, a  ; b = Tile Y

    ; Calcular offset en tilemap: Tile Y * 32 + Tile X
    ; Primero b * 32
    ld a, b
    sla a  ; * 2
    sla a  ; * 4
    sla a  ; * 8
    sla a  ; * 16
    sla a  ; * 32
    add c  ; + Tile X
    ld c, a  ; c = offset bajo

    ; Calcular dirección completa: $9800 + offset
    ld hl, $9800
    ld b, 0
    add hl, bc

    ; Leer el tile en esa posición
    ld a, [hl]

    ; Verificar si es uno de los tiles de puerta (0x88, 0x89, 0x8A, 0x8B)
    cp $88
    jr z, .is_door
    cp $89
    jr z, .is_door
    cp $8A
    jr z, .is_door
    cp $8B
    jr z, .is_door
    ret  ; No es puerta, retornar

.is_door:
    ; Es una puerta, cambiar de nivel
    call Next_Level
    ret
