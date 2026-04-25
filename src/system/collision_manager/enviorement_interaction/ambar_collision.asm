INCLUDE "constants.inc"
INCLUDE "utils/arithmetic_macros.inc"
INCLUDE "system/collision_manager/collisions.inc"
INCLUDE "entities/entities.inc"

SECTION "Ambar collisions", ROM0


check__player_ambar_collision::
    push de        ; Save E (Ambar entity index)
    ld l, 0        ; Player entity index
    pop de         ; Restore E (Ambar entity index)
    call are_entities_colliding
    call c, collect_ambar ; If collide, then collect ambar
    ret

check_ambar_collisions::
;check_player_enemies_collisions::
    ld hl, check__player_ambar_collision
    call man_entity_for_each_ambar

    ;ld hl, clean_collected_ambar
    ;call man_entity_for_each_ambar
    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_ahmbar_tile_collision
;;; Checks if player is touching an ahmbar tile
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; THIS MUST BE REWRITTEN TO ALLOW MOR FLEXIBILITY

check_ahmbar_tile_collision::
    .loop:
    .left:
        call get_current_tile_address_left_point
        ld a, [hl] ; load tile
        call is_tile_collectible
        jp z, .process_collectible

    .right:
        call get_current_tile_address_right_point
        ld a, [hl] ; load tile
        call is_tile_collectible
        ret nz  ; Not a door, return

    .process_collectible:
        ld a, [hl] ; load tile
        ld [hl], EMPTY_TILE
        call is_tile_ahmbar
        jp z, .is_ahmbar

        ; Is an ahmbar, collect it
        .is_ahmbar:
            call increment_score_and_display
            ret
        .another_collectible:
    jp .loop


get_current_tile_address_left_point::
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    add 1
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret

get_current_tile_address_right_point::
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    add 6
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret