INCLUDE "entities/entities.inc"

SECTION "Entity setters", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set the values of an entity component
;;
;; INPUT
;;  HL: memory address of the entity values to set
;;  B: value 1
;;  C: value 2
;;  D: value 3
;;  E: value 4
;; Does not destroy anything

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
;;   HL: memory address of the entity values to read
;; OUTPUT
;;   B: value 1
;;   C: value 2
;;   D: value 3
;;   E: value 4
;; Does not destroy HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_entity_components:
    push hl
    ld a, [hl]    ; value 1
    ld b, a
    inc l
    ld a, [hl]    ; value 2
    ld c, a
    inc l
    ld a, [hl]    ; value 3
    ld d, a
    inc l
    ld a, [hl]    ; value 4
    ld e, a
    pop hl
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to initialize an entity
;;
;; INPUT
;;  B: Y coordinate
;;  C: X coordinate
;;  D: tile
;;  E: tile properties
;;  L: Entity index
;; WARNING: Destroys H

set_entity_sprite::
    ld h, CMP_SPRIT_H
    call set_entity_components
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set entities physics components
;;
;; Input
;;  B: Vy 
;;  C: Vx 
;;  D: TBA
;;  E: TBA
;;  L: Entity index
;; WARNING: Destroys H

set_entity_physics::
    ld h, CMP_PHYS_H
    call set_entity_components
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic function to set entities attributes components
;;
;; Input
;;  B: ATT_ENTITY_FLAGS 
;;  C: TBA
;;  D: TBA
;;  E: TBA
;;  L: Entity index
;; WARNING: Destroys H

set_entity_attributes::
    ld h, CMP_ATTR_H
    call set_entity_components
    ret
