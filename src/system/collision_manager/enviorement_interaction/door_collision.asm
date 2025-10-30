SECTION "Door collision", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_door_collision
;;; Checks if player is touching a door tile (tiles $C0-$C3)
;;; and triggers level transition if true
;;; Door tiles have bits 4,5,6 = %010 (DOOR_TILE group)
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_door_collision::
    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_door
    ret nz  ; Not a door, return

    ; Is a door, change level
    ld b, 60
    call wait_x_frames  
    call next_scene
    ret

