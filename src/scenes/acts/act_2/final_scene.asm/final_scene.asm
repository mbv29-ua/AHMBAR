INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "system/hud/hud_constants.inc"


SECTION "Act 2 Final Scene", ROM0

act_2_final_scene_intro_dialog::
    di
    call set_black_palette
    ld hl, act_2_final_scene_dialog
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the final
;; scene of the act 2.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

act_2_final_scene_enemy_spawner::
	call load_rock_tiles

	ld  b, $60
	ld  c, $78
	ld hl, act_2_final_boss

	call enemy_spawn

	ld b, $20
	ld c, $28
	call bullet_spawn
	ret

bullet_spawn::
    ; We need to save HL information
    push hl
    call man_entity_alloc ; Returns l=entity index
    ld a, l
    pop hl

    call spawner_set_bullet_sprite
    call spawner_set_bullet_flags
    call spawner_set_bullet_dimensions
    call spawner_set_bullet_physics

    ret

spawner_set_bullet_sprite::
    push bc
    
    ld d, TILE_BULLET_BOX ; bullet tile index
    ld e, 0   ; Sprite attributes

    ld l, a ; entity index
    call set_entity_sprite

    pop bc
    ret

spawner_set_bullet_flags::
    push af

    ; Set entity flags
    ld h, CMP_ATTR_H
    add ATT_ENTITY_FLAGS
    ld l, a
    
    set E_BIT_COLLECTABLE, [hl]

    ; Set interaction flags
    inc l ; Move to INTERACTION_FLAGS
    ld b, 0
    ; bullets are not movable, not affected by gravity, etc.
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
    
    set BULLET_COLLECT, [hl]
    
    pop af
    ret

spawner_set_bullet_dimensions::
    ; Set bullet dimensions (8x8)
    ld b, 8
    ld c, 8
    ld d, 0
    ld e, 0
    ld l, a ; entity index
    call set_entity_dimensions
    ret

spawner_set_bullet_physics::
    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    ld l, a ; entity index
    call set_entity_physics
    ret 

man_entity_for_each_bullet_player::
	ld b, (1<<BULLET_COLLECT)
	ld c, PHY_FLAGS
	call man_entity_for_each_type
	ret


check_player_bullet_collision::
    push de        ; Save E (bullet entity index)
    ld l, 0        ; Player entity index
    pop de         ; Restore E (bullet entity index)
    call are_entities_colliding
    call c, collect_bullet ; If collide, then collect bullet
    ret

check_bullet_player_collisions::
;check_player_enemies_collisions::
    ld hl, check_player_bullet_collision
    call man_entity_for_each_bullet_player

    ;ld hl, clean_collected_bullet
    ;call man_entity_for_each_bullet_player
    ret

collect_bullet::
    
    call man_entity_free
    ;call clean_collected_bullet

	ld hl, wPlayerBullets
	ld [hl], MAX_BULLETS
    call hud_needs_update

    ret

;clean_collected_bullet::
;   ld h, CMP_ATTR_H
;	ld l, e
;	bit E_BIT_DYING, [hl]	
;	ret z
;
;	ld h, CMP_CONT_H
;	ld a, e
;	add COUNT_DEATH_CLOCK
;	ld l, a
;	ld a, [hl]
;
;    ld l, e
;	call man_entity_free
;	
;   call desintegration_animation
;
;	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set death clock to an enemy counter and mark it
;; as a dying enemy.
;;
;; Input: E = enemy index
;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;set_bullet_clock::
;	ld h, CMP_ATTR_H
;	ld l, e
;	set E_BIT_DYING, [hl]
;
;	ld h, CMP_CONT_H
;	ld a, e
;	add COUNT_DEATH_CLOCK
;	ld l, a
;	ld [hl], DEATH_CLOCK_START_VALUE
;	ret

INCLUDE "system/ambar_macros.inc"

init_ambars_ac2_final::
	SPAWN_AMBAR_AT_TILE 10, 9
    SPAWN_AMBAR_AT_TILE 10, 11
    SPAWN_AMBAR_AT_TILE 10, 12
	ret