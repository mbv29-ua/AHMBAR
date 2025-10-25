INCLUDE "entities/entities.inc"

SECTION "Enemies", ROM0

;; Example <- To delete in the final version

init_enemigos_prueba::
	;; Example of initializing an enemy (valid for an entity)
	call man_entity_alloc ; Returns l=entity index
	ld b, $48 ; Y coordinate
	ld c, $14  ; X coordinate
	ld d, $05 ; tile
	ld e, 0   ; tile properties
	call set_entity_sprite
	ld b, -1 ; vy 
	;ld c,  0 ; vx
	ld d,  0 ; vx
	call set_entity_physics

	call man_entity_alloc ; Returns l=entity index
	ld b, $55 ; Y coordinate
	ld c, $56  ; X coordinate
	ld d, $07 ; tile
	ld e, %11001010   ; tile properties
	call set_entity_sprite	
	ld b,  1 ; vy
	;ld c, -1 ; vx
	ld d, -1 ; vx
	call set_entity_physics

	call man_entity_alloc ; Returns l=entity index
	ld b, 60 ; Y coordinate
	ld c, 40  ; X coordinate
	ld d, $09 ; tile
	ld e, 0   ; tile properties
	call set_entity_sprite
	ld b,  0 ; vy
	;ld c,  1 ; vx
	ld d,  1 ; vx
	call set_entity_physics

	ld h, CMP_ATTR_H
	ld a, l
    add ATT_ENTITY_FLAGS
    ld l, a
    set E_BIT_GRAVITY, [hl]

	ret