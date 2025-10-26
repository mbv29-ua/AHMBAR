INCLUDE "entities/entities.inc"
INCLUDE "entities/enemies/enemies.inc"

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns an enemy of a certain type
;; given by HL in a certain possition (C,B).
;;
;; INPUT:
;;       B: Enemy Y coordinate
;;		 C: Enemy X coordinate
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: 	Destroys DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

enemy_spawn::

	; We need to save HL information
	push hl
	call man_entity_alloc ; Returns l=entity index
	ld a, l
	pop hl

	call spawner_set_enemy_sprite
	call spawner_set_enemy_speed
	call spawner_set_enemy_flags
	call spawner_set_enemy_health
	call spawner_set_enemy_AI

	ret
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the enemy sprite
;;
;; INPUT:
;;		 A: Entity index
;;       B: Enemy Y coordinate
;;		 C: Enemy X coordinate
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys DE 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_enemy_sprite::
	push hl
	push bc

	; Loads tile
	ld b, 0
	ld c, ENEMY_TILE
	add hl, bc
	ld d, [hl]

	; Loads sprite attributes
	ld c, (ENEMY_INITIAL_SPRITE_ATTRIBUTES-ENEMY_TILE) ; This must be positive
	add hl, bc
	ld e, [hl]

	pop bc
	ld l, a ; entity index
	call set_entity_sprite

	; We retrive the original inputs
    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the enemy speeds
;;
;; INPUT:
;;		 A: Entity index
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_enemy_speed::
	push hl

	; Loads Vy
	ld d, 0
	ld e, ENEMY_INITIAL_VY_SPEED
	add hl, de
	ld b, [hl]

	ld c, 0

	; Loads Vx
	ld e, (ENEMY_INITIAL_VX_SPEED-ENEMY_INITIAL_VY_SPEED) ; This must be positive
	add hl, de
	ld d, [hl]

	ld e, 0

	ld l, a ; entity index
	call set_entity_physics

	; We retrive the original inputs
    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the flags and AI.
;;
;; INPUT:
;;		 A: Entity index
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_enemy_flags::
	push hl 
	push af
	push hl

	; We load initial flags
	ld h, CMP_ATTR_H
	add ATT_ENTITY_FLAGS
	ld l, a
	ld b, [hl]

	; Set new specific flags
	pop hl  ; recover

	; Load flags
	ld d, 0
	ld e, ENEMY_FLAGS
	add hl, de 
	ld a, [hl]

    set E_BIT_ENEMY, a ; Safe setter

	or b ; We add the specific enemy flags to ones set
		 ; by the entity_manager
	ld b, a
	
	; Load interaction flags
	ld e, (ENEMY_ENVIRONMENT_INTERACTION-ENEMY_FLAGS)
    add hl, de
    ld c, [hl]
    
    ; Set physic flags
    xor a
    ld d, a
    set PHY_FLAG_GROUNDED, d 

    xor a
    ld e, a

	pop af
	ld l, a ; entity index
	call set_entity_attributes

	; We retrive the original inputs
	ld l, a
    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the enemy health from definition.
;;
;; INPUT:
;;		 A: Entity index
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_enemy_health::
	push hl
	push af

	; Load health from enemy definition
	ld d, 0
	ld e, ENEMY_LIFE
	add hl, de
	ld d, [hl]  ; D = enemy health

	; Set health in entity
	pop af  ; A = entity index
	ld h, CMP_ATTR_H
	ld l, a  ; L = entity index
	push af
	ld a, l
	add ENTITY_HEALTH  ; A = entity index + offset
	ld l, a  ; HL apunta a ENTITY_HEALTH
	ld [hl], d  ; Store health
	pop af

	pop hl
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the enemy AI.
;;
;; INPUT:
;;		 A: Entity index
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_enemy_AI::
	push hl
	
    ; Load AI 1
    ld d, 0
	ld e, ENEMY_AI_1
	add hl, de
	ld b, [hl]
	inc l
	ld c, [hl]

    ; Load ENEMY AI 2
	inc l
	ld d, [hl]
	inc l
	ld e, [hl]

	ld l, a ; entity index
	call set_entity_AI

	; We retrive the original inputs
    pop hl
    ret
