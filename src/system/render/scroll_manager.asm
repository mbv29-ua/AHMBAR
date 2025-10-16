include "constants.inc"

SECTION "Scroll Manager", ROM0

DEF SCREEN_OFFSET_VERTICAL      EQU 16
DEF SCREEN_OFFSET_HORIZONTAL    EQU  8
DEF TILE_OFFSET                 EQU  8
DEF SCROLL_OFFSET               EQU 16 ;; Este se puede cambiar

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
    cp 96      ;; cambiar
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
