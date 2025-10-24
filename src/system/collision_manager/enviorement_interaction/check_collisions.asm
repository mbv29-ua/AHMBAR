SECTION "Collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_door_collision
;;; Checks if player is touching a door tile
;;; and triggers level transition if true
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_door_collision::
    ; Verificar si estamos en nivel 2, si es así, no hacer nada
    ;ld a, [wCurrentLevel]
    ;cp 2
    ;ret z  ; Si es nivel 2, retornar sin hacer nada

    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_door
    ret nz  ; Not a door, return

    ; Is a door, change level
    call next_scene
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
    ret nz  ; Not deadly, return

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
    ret nz  ; Not collectible, return

    ; Is collectible
    ; TODO: Add score/health/etc.
    ; Remove tile from map (replace with empty)
    ld a, $80  ; Empty tile
    ld [hl], a
    ret