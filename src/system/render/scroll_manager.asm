include "constants.inc"

;;; Mirar lo de los offsets de la pantalla
DEF SCROLL_OFFSET               EQU 48 ;; This can be changed and it sets the others

DEF SCREEN_OFFSET_VERTICAL      EQU 16
DEF SCREEN_OFFSET_HORIZONTAL    EQU  8
DEF TILE_OFFSET                 EQU  8

DEF UP_SCROLL_OFFSET        EQU SCROLL_OFFSET + SCREEN_OFFSET_VERTICAL + TILE_OFFSET
DEF DOWN_SCROLL_OFFSET      EQU 144 + SCREEN_OFFSET_VERTICAL - SCROLL_OFFSET - TILE_OFFSET
DEF RIGHT_SCROLL_OFFSET     EQU 160 - SCROLL_OFFSET - SCREEN_OFFSET_HORIZONTAL
DEF LEFT_SCROLL_OFFSET      EQU SCROLL_OFFSET + SCREEN_OFFSET_HORIZONTAL + TILE_OFFSET



SECTION "Scroll Manager", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine scrolls according to the player
;; position
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scroll_manager::
; Scroll up
.scroll_up
    ; Miramos si ya estamos arriba del todo
    ldh a, [rSCY]
    cp 0
    jr z, .end_scroll_up

    ; El personaje en posicion que activa el scroll up
    ld a, [Player.wPlayerY]
    cp UP_SCROLL_OFFSET; Límite superior de la pantalla para activar scroll 
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
    cp DOWN_SCROLL_OFFSET; Límite inferior de la pantalla para activar scroll 
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
    cp RIGHT_SCROLL_OFFSET; Límite derecha de la pantalla para activar scroll 
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
    cp LEFT_SCROLL_OFFSET; Límite izquierda de la pantalla para activar scroll 
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
