include "constants.inc"

SECTION "Collions", ROM0


; Verifica si el jugador está tocando un tile de puerta

;; TODO : split code 2 parts 1. calculate player position     2. tile position
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
    ; Primero b * 32ñ
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
