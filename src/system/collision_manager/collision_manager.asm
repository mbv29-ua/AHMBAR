INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Collision manager", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Each tile is 8x8 pixels. We have to take into account
;; the Game Boy visible screen area:
;; - Horizontal: pixels 8-167 visible (0-7 off-screen left)
;; - Vertical: pixels 16-159 visible (0-15 off-screen top)
;; - A sprite at (8,16) appears at screen top-left corner.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets at the position (x,y) of the
;; screen.
;;
;; INPUT:
;;      B: Y coordinate of the screen
;;      C: X coordinate of the screen
;; OUTPUT:
;;      A: Tile
;: WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_tile_at_position_y_x::
    push de
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a
    call calculate_address_from_tx_and_ty
    call get_tile_at_position_hl
    pop de
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets the tile at the memory addres HL.
;;
;; INPUT:
;;      HL: memory address of the tile
;; OUTPUT:
;;      A: Tile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_tile_at_position_hl::
    ld a, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gets the Address in VRAM of the tile the entity is touching.
;; An entity touches a tile if it is placed in the same
;; region in the screen (they both overlap).
;; As entity is placed in pixel coordinates, this routine
;; has to convert pixel coordinates to tiles coordinates.
;;
;; INPUT:
;;      -
;; OUTPUT;
;;      HL: VRAM Address of the tile the sprite is touching
;; WARNING: Destroys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_address_of_tile_to_be_touched:
    ;; 1. Convert Y to TY, and X to TX
    ld hl, temporal_new_y_position
    ld a, [hl]
    call convert_y_to_ty
    ld b, a

    ld hl, temporal_new_x_position
    ld a, [hl]
    call convert_x_to_tx

    ;; 2. Calculate the VRAM address using TX and TY
    ld l, b ; Move TY to L
    call calculate_address_from_tx_and_ty   
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Converts a value in pixel coordinates to VRAM tilemap
;; coordinates. The value is a sprite Y-coordinate
;; and takes into account the non-visible 16 pixels
;; on the upper side of the screen and the y scroll.
;;
;; Tile Y = (Y + SCY - 16) / 8
;;
;; INPUT:
;;      A: Sprite Y-coordinate value
;; OUTPUT:
;;      A: Associated VRAM Tilemap TY-coordinate value
;; WARNING: Destroys C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

convert_y_to_ty:
    ld hl, rSCY
    add [hl]
    sub 16 ; Subtract the non-visible 16 pixels
    call div_a_by_8
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Converts a value in pixel coordinates to VRAM tilemap
;; coordinates. The value is a sprite X-coordinate
;; and takes into account the non-visible 8 pixels
;; on the left of the screen.
;;
;; INPUT:
;;      A: Sprite X-coordinate value
;; OUTPUT:
;;      A: Associated VRAM Tilemap TX-coordinate value
;:WARNING: Destroys C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

convert_x_to_tx:
    ld hl, rSCX
    add [hl]
    sub 8 ; Subtract the non-visible 8 pixels
    call div_a_by_8
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates an VRAM Tilemap Address from itx tile
;; coordinates (TX, TY). The tilemap is 32x32, and
;; address $9800 is assumed as the address of tile (0,0)
;; in tile coordinates.
;;
;; INPUT:
;;      B: TY coordinate
;;      C: TX coordinate
;; OUTPUT:
;;      HL: Address where the (TX, TY) tile is stored
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

calculate_address_from_tx_and_ty:
    ld h, 0 ; HL = Tile Y
    ld l, b
    call mult_hl_32

    ; Calculate full address: $9800 + offset
    ld de, BG_MAP_START
    add hl, de

    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates the leftmost x coordinate after the tile.
;;
;; INPUT:
;;      A: TX coordinate
;; OUTPUT:
;;      A: rightmost coordinate after the tile
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_leftmost_x_coordinate_after_tile::
    inc a ; We get the first coordinate Tx+1
    ; Multiply Tx by 8
    add a
    add a
    add a    
    ; Add scroll x
    ld hl, rSCX
    sub [hl]
    dec a
    add 8 ;; screen horizontal offset 
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates the rightmost x coordinate before the tile.
;;
;; INPUT:
;;      A: TX coordinate
;; OUTPUT:
;;      A: rightmost coordinate before the tile
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_rightmost_x_coordinate_before_tile::
    ; Multiply Tx by 8
    add a
    add a
    add a    
    ; Add scroll x
    ld hl, rSCX
    sub [hl]
    add 8 ;; screen horizontal offset 
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates the lowermost y coordinate above the tile.
;;
;; INPUT:
;;      A: TY coordinate
;; OUTPUT:
;;      A: lowermost coordinate above the tile
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_lowermost_y_coordinate_above_tile::
    ; Multiply Ty by 8
    add a
    add a
    add a    
    ; Add scroll y
    ld hl, rSCY
    sub [hl]
    add 16 ;; screen vertical offset
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates the uppermost y coordinate below the tile.
;;
;; INPUT:
;;      A: TY coordinate
;; OUTPUT:
;;      A: uppermost coordinate below the tile
;; WARNING: Destroys HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_uppermost_y_coordinate_below_tile::
    inc a ; We get the first coordinate Ty+1
    ; Multiply Ty by 8
    add a
    add a
    add a    
    ; Add scroll y
    ld hl, rSCY
    sub [hl]
    add 16 ;; screen vertical offset
    ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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
    call convert_y_to_ty
    ld d, a         ; D = Tile Y

    ; Tile X = (X + SCX - 8) / 8
    call convert_x_to_tx
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
;get_tile_at_position::
;    ; Tile X = (X + SCX - 8) / 8
;    ldh a, [rSCX]
;    add c
;    sub 8           ; OAM offset
;    srl a
;    srl a
;    srl a
;    ld e, a         ; E = Tile X
;
;    ; Tile Y = (Y + SCY - 17) / 8
;    ldh a, [rSCY]
;    add b
;    sub 16
;    srl a
;    srl a
;    srl a
;    ld d, a         ; D = Tile Y
;
;    ; Calculate tilemap offset: Tile Y * 32 + Tile X
;    ; Using 16-bit arithmetic to avoid overflow
;    ; HL = Tile Y * 32
;    ld h, 0
;    ld l, d         ; HL = Tile Y
;    add hl, hl      ; * 2
;    add hl, hl      ; * 4
;    add hl, hl      ; * 8
;    add hl, hl      ; * 16
;    add hl, hl      ; * 32
;
;    ; Add Tile X
;    ld d, 0         ; DE = Tile X
;    add hl, de      ; HL = (Tile Y * 32) + Tile X
;
;    ; Calculate full address: $9800 + offset
;    ld de, $9800
;    add hl, de
;
;    ; Read tile at position
;    ld a, [hl]
;    ret


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
;get_tile_at_entity_position::
;    ; Get entity Y position
;    ld d, CMP_SPRIT_H
;    ld a, [de]      ; A = entity Y
;    add b           ; Add Y offset
;    ld b, a         ; B = final Y position
;
;    ; Get entity X position
;    inc e
;    ld a, [de]      ; A = entity X
;    add c           ; Add X offset
;    ld c, a         ; C = final X position
;    dec e           ; Restore E to point to entity Y
;
;    ; Now call get_tile_at_position with B=Y, C=X
;    call get_tile_at_position
;    ret


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
;get_tile_at_entity_position_x::
;    ; Get entity X position
;    ld d, CMP_SPRIT_H
;    ld a, [de]      ; A = entity X
;    add c           ; Add X offset
;    ld c, a         ; C = final X position
;
;    ; Get entity Y position
;    dec e
;    ld a, [de]      ; A = entity Y
;    add b           ; Add Y offset
;    ld b, a         ; B = final Y position
;    inc e           ; Restore E to point to X
;
;    ; Now call get_tile_at_position with B=Y, C=X
;    call get_tile_at_position
;    ret