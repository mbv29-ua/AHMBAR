INCLUDE "entities/entities.inc"

SECTION "Ambar Spawner", ROM0

ambar_spawn::
    ; We need to save HL information
    push hl
    call man_entity_alloc ; Returns l=entity index
    ld a, l
    pop hl

    call spawner_set_ambar_sprite
    call spawner_set_ambar_flags
    call spawner_set_ambar_dimensions
    call spawner_set_ambar_physics

    ret

spawner_set_ambar_sprite::
    push bc
    
    ld d, $62 ; Ambar tile index
    ld e, 0   ; Sprite attributes

    ld l, a ; entity index
    call set_entity_sprite

    pop bc
    ret

spawner_set_ambar_flags::
    push af

    ; Set entity flags
    ld h, CMP_ATTR_H
    add ATT_ENTITY_FLAGS
    ld l, a
    
    set E_BIT_COLLECTABLE, [hl]

    ; Set interaction flags
    inc l ; Move to INTERACTION_FLAGS
    ld b, 0
    ; Ambars are not movable, not affected by gravity, etc.
    ; They are collidable with the player.
    set E_BIT_COLLIDABLE, b
    ld [hl], b

    ; PHYS_FLAGS
    ; Set entity flags
    pop af
    push af
    ld h, CMP_ATTR_H
    add PHY_FLAGS
    ld l, a
    
    set AMBAR_COLLECT, [hl]
    
    pop af
    ret

spawner_set_ambar_dimensions::
    ; Set ambar dimensions (8x8)
    ld b, 8
    ld c, 8
    ld d, 0
    ld e, 0
    ld l, a ; entity index
    call set_entity_dimensions
    ret

spawner_set_ambar_physics::
    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    ld l, a ; entity index
    call set_entity_physics
    ret