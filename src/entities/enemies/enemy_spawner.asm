INCLUDE "entities/entities.inc"
INCLUDE "entities/enemies/enemies.inc"


SECTION "Enemy spawer", ROM0

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
	call spawner_set_entity_dimensions
	call spawner_set_enemy_AI
	call spawner_set_enemy_ID

	ld hl, wNumberOfEnemies
	inc [hl]
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
;; This routine sets the enemy dimensions from
;; specified in the definition file.
;;
;; INPUT:
;;		 A: Entity index
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_entity_dimensions::
	push hl

	; Loads Vy
	ld d, 0
	ld e, ENEMY_HEIGHT
	add hl, de
	ld b, [hl]

	; Loads Vx
	ld e, (ENEMY_WIDTH-ENEMY_HEIGHT) ; This must be positive
	add hl, de
	ld c, [hl]

	ld d, 0
	ld e, 0

	ld l, a ; entity index
	call set_entity_dimensions

	; We retrive the original inputs
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the enemy ID, that is
;; that is necessary for some AIs.
;;
;; INPUT:
;;		 A: Entity index
;;      HL: Enemy attributes information address
;; OUTPUT:
;;      -
;; WARNING: Destroys BC and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spawner_set_enemy_ID::
	push hl
	
    ; Load AI 1
    ld b, 0
    ld c, 0
    ; Load enemy definition address
	ld d, h
	ld e, l
	ld l, a ; entity index
	call set_entity_ID

	; We retrive the original inputs
    pop hl
    ret