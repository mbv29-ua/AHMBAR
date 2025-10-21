INCLUDE "constants.inc"
INCLUDE "system/collision_manager/tile_properties.inc"

SECTION "Collisions", ROM0


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
;;; check_door_collision
;;; Checks if player is touching a door tile
;;; and triggers level transition if true
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_door_collision::
    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_door
    ret z  ; Not a door, return

    ; Is a door, change level
    call Next_Level
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_deadly_collision
;;; Checks if player is touching a deadly tile
;;; (spikes, etc.) and handles player death
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_deadly_collision::
    call get_tile_at_player_position  ; A = tile ID
    call is_tile_deadly
    ret z  ; Not deadly, return

    ; Is deadly, handle player death
    ; TODO: Implement player death/respawn logic
    ; call reset_player
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_collectible_collision
;;; Checks if player is touching a collectible tile
;;; (hearts, etc.) and collects it
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_collectible_collision::
    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_collectible
    ret z  ; Not collectible, return

    ; Is collectible
    ; TODO: Add score/health/etc.
    ; Remove tile from map (replace with empty)
    ld a, $A0  ; Empty tile
    ld [hl], a
    ret
