INCLUDE "constants.inc"
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



