INCLUDE "entities/entities.inc"

SECTION "Entity setters", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to reset the values of an entity component
;;
;; INPUT
;;      HL: memory address of the entity values to set to 0
;; OUTPUT:
;;      -
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reset_entity_components:
    push hl
    ld [hl], 0 ; value 1
    inc l
    ld [hl], 0 ; value 2
    inc l
    ld [hl], 0 ; value 3
    inc l
    ld [hl], 0 ; value 4
    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to reset an entity 
;; sprite
;;
;; INPUT
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reset_entity_sprite::
    ld h, CMP_SPRIT_H
    call reset_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set the values of an entity component
;;
;; INPUT
;;      HL: memory address of the entity values to set
;;      B: value 1
;;      C: value 2
;;      D: value 3
;;      E: value 4
;; OUTPUT:
;;      -
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_entity_components:
    push hl
    ld [hl], b ; value 1
    inc l
    ld [hl], c ; value 2
    inc l
    ld [hl], d ; value 3
    inc l
    ld [hl], e ; value 4
    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to get the values of an entity component
;;
;; INPUT
;;      HL: memory address of the entity values to read
;; OUTPUT
;;      B: value 1
;;      C: value 2
;;      D: value 3
;;      E: value 4
;; OUTPUT:
;;      -
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_entity_components:
    push hl
    ld b, [hl]    ; value 1
    inc l
    ld c, [hl]    ; value 2
    inc l
    ld d, [hl]    ; value 3
    inc l
    ld e, [hl]    ; value 4
    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to initialize an entity
;;
;; INPUT
;;      B: Y coordinate
;;      C: X coordinate
;;      D: tile
;;      E: tile properties
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_entity_sprite::
    ld h, CMP_SPRIT_H
    call set_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set entities physics components
;;
;; Input
;;      B: Vy 
;;      C: Vy floating points 
;;      D: Vx
;;      E: Vx floating points
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_entity_physics::
    ld h, CMP_PHYS_H
    call set_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set entities attributes components
;;DEF ATT_ENTITY_FLAGS      RB 1
;; Input
;;      B: ATT_ENTITY_FLAGS 
;;      C: INTERACTION_FLAGS
;;      D: PHY_FLAGS
;;      E: TBA
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_entity_attributes::
    ld h, CMP_ATTR_H
    call set_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set entities attributes components
;;
;; Input
;;      BC: Address of AI routine 1
;;      DE: Address of AI routine 2
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_entity_AI::
    ld h, CMP_AI_H
    call set_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set entities attributes components
;;
;; Input
;;      BC: Address of AI routine 2
;;      DE: Address of entity definition
;;      L: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_entity_ID::
    ld h, CMP_SONIA_H
    call set_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets the entity definition component.
;;
;; Input
;;      L: Entity index
;; OUTPUT
;;      B: value 1
;;      C: value 2
;;      D: value 3
;;      E: value 4
;; WARNING: Destroys H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


get_entity_definition_component::
    ld h, CMP_SONIA_H
    call get_entity_components
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the entity vertical speed to
;; zero.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_vertical_speed_to_zero::
    ld h, CMP_PHYS_H
    ld l, e

    xor a   
    ld [hl+], a      ; vy = 0
    ld [hl], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the entity horizontal speed to
;; zero.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_horizontal_speed_to_zero::
    ld h, CMP_PHYS_H
    ld l, e
    inc l
    inc l

    xor a   
    ld [hl], a      ; vx = 0
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the entity as grounded.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_grounded::
    ld h, CMP_ATTR_H
    ld a, e
    add PHY_FLAGS
    ld l, a
    set PHY_FLAG_GROUNDED, [hl]
    res PHY_FLAG_JUMPING, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the entity as not grounded.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -   
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

unset_grounded::
    ld h, CMP_ATTR_H
    ld a, e
    add PHY_FLAGS
    ld l, a
    res PHY_FLAG_GROUNDED, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if an entity is not grounded.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      Z=1 if floating, Z=0 if grounded
;; WARNING: Destroys A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_floating:
    ld h, CMP_ATTR_H
    ld a, e
    add PHY_FLAGS
    ld l, a
    bit PHY_FLAG_GROUNDED, [hl]
    ret
