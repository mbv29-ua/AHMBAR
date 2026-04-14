INCLUDE "constants.inc"
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

check_ahmbar_tile_collision::
    ; Is an ahmbar, collect it
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    add 4
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    call mult_hl_32
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de

    ld a, [hl] ; load tile
    call is_tile_ahmbar
    ret nz  ; Not a door, return

    ld [hl], EMPTY_TILE
    call increment_score_and_display
    ret


