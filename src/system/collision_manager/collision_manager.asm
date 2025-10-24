INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Collision manager", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_position
;;; Gets the tile ID at a specific pixel position
;;;
;;; Input:
;;;   B = Y position (pixels in the BGMap)
;;;   C = X position (pixels in the BGMap)
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Version con llamadas a rutinas aritmeticas,
;; No se usa, pero hay que intentar juntar todas las que hay
;; en este fichero para no repetir tanto codigo

get_tile_at_position_new::
    ; Tile Y = (Y + SCY - 16) / 8
    ldh a, [rSCY]
    add b
    sub 16
    call div_a_8
    ld d, a         ; D = Tile Y

    ; Tile X = (X + SCX - 8) / 8
    ldh a, [rSCX]
    add c
    sub 8           ; OAM offset
    call div_a_8
    ld e, a         ; E = Tile X

    ; Calculate tilemap offset: Tile Y * 32 + Tile X
    ; Using 16-bit arithmetic to avoid overflow
    ; HL = Tile Y * 32
    ld h, 0
    ld l, d         ; HL = Tile Y
    call mult_hl_32

    ; Add Tile X
    ld d, 0         ; DE = Tile X
    add hl, de      ; HL = (Tile Y * 32) + Tile X

    ; Calculate full address: $9800 + offset
    ld de, BG_MAP_START
    add hl, de

    ; Read tile at position
    ld a, [hl]
    ret






;; Esta funcion la vamos a cambiar al colision manager

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_player_position
;;; Calculates which tile the player is standing on
;;;
;;; Output:
;;;   A = Tile ID at player position
;;;   HL = Address in tilemap ($9800 + offset)
;;; Destroys: BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_player_position::
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
    ret








    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_position
;;; Gets the tile ID at a specific pixel position
;;;
;;; Input:
;;;   B = Y position (pixels)
;;;   C = X position (pixels)
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_position::
    ; Tile X = (X + SCX - 8) / 8
    ldh a, [rSCX]
    add c
    sub 8           ; OAM offset
    srl a
    srl a
    srl a
    ld e, a         ; E = Tile X

    ; Tile Y = (Y + SCY - 17) / 8
    ldh a, [rSCY]
    add b
    sub 16
    srl a
    srl a
    srl a
    ld d, a         ; D = Tile Y

    ; Calculate tilemap offset: Tile Y * 32 + Tile X
    ; Using 16-bit arithmetic to avoid overflow
    ; HL = Tile Y * 32
    ld h, 0
    ld l, d         ; HL = Tile Y
    add hl, hl      ; * 2
    add hl, hl      ; * 4
    add hl, hl      ; * 8
    add hl, hl      ; * 16
    add hl, hl      ; * 32

    ; Add Tile X
    ld d, 0         ; DE = Tile X
    add hl, de      ; HL = (Tile Y * 32) + Tile X

    ; Calculate full address: $9800 + offset
    ld de, $9800
    add hl, de

    ; Read tile at position
    ld a, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_entity_position
;;; Gets the tile ID at an entity's specific pixel position
;;;
;;; Input:
;;;   E = Entity index (points to Y component)
;;;   B = Y offset to add to entity's Y position
;;;   C = X offset to add to entity's X position
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE, BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_entity_position::
    ; Get entity Y position
    ld d, CMP_SPRIT_H
    ld a, [de]      ; A = entity Y
    add b           ; Add Y offset
    ld b, a         ; B = final Y position

    ; Get entity X position
    inc e
    ld a, [de]      ; A = entity X
    add c           ; Add X offset
    ld c, a         ; C = final X position
    dec e           ; Restore E to point to entity Y

    ; Now call get_tile_at_position with B=Y, C=X
    call get_tile_at_position
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_entity_position_x
;;; Gets the tile ID at an entity's specific pixel position
;;; VARIANT: E points to X component instead of Y
;;;
;;; Input:
;;;   E = Entity index (points to X component)
;;;   B = Y offset to add to entity's Y position
;;;   C = X offset to add to entity's X position
;;; Output:
;;;   A = Tile ID at that position
;;;   HL = Address in tilemap
;;; Destroys: DE, BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_entity_position_x::
    ; Get entity X position
    ld d, CMP_SPRIT_H
    ld a, [de]      ; A = entity X
    add c           ; Add X offset
    ld c, a         ; C = final X position

    ; Get entity Y position
    dec e
    ld a, [de]      ; A = entity Y
    add b           ; Add Y offset
    ld b, a         ; B = final Y position
    inc e           ; Restore E to point to X

    ; Now call get_tile_at_position with B=Y, C=X
    call get_tile_at_position
    ret