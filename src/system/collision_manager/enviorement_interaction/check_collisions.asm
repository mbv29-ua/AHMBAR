INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_collectible_collision
;;; Checks if player is touching a collectible tile
;;; (hearts, etc.) and collects it
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_collectible_collision::
    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_collectible
    ret nz  ; Not collectible, return

    ; Is collectible
    ; TODO: Add score/health/etc.
    ; Remove tile from map (replace with empty)
    ld a, $80  ; Empty tile
    ld [hl], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks if two integral intervals overlap in one dimension
;; It receives the addresses of 2 intervals in memory
;; in HL and DE:
;;
;; Address   |BC|       |DE|
;; Values  
;; SPR_BASE  [p1] ..... [p2]
;; AABB_BASE [w1] ..... [w2]
;;
;; Returns Carry Flag (C=0, NC) when NOT-Colliding,
;; and (C=1, C) when overlapping.
;;
;; INPUT:
;;      BC: Address of Interval 1 (p1, w1)
;;      DE: Address of Interval 2 (p2, w2)
;; OUTPUT:
;;      Carry: { NC: No overlap }, { C: Overlap }
;;
 
are_intervals_overlapping::
    ;call compare_contents_bc_and_de
    ;jr nc, .case2 ; [bc] > [de]

    ; Check situation ... bc ... de ...
    .case1:
        push bc
        ld a, [bc]
        ld h, CMP_AABB_H
        ld l, b
        add [hl]
        ld b, a ; b <- p1+w1

        ld a, [de] ; a <- p2

        cp b ; p2-(p1+w1)
        pop bc
        ret nc

    ; Check situation ... de ... bc ...
    .case2:
        ld a, [de]
        ld h, CMP_AABB_H
        ld l, e
        add [hl] 
        ld d, a ; d <- p2+w2
        
        ld a, [bc] ; a <- p1

        cp d ; p1-(p2+w2)
    ret

;; Carry flag 1 if [hl] < [de]
;compare_contents_hl_and_de:
;    push hl
;    ld a, [hl]
;    ld h, d
;    ld l, e
;    cp [hl]
;    pop hl
;    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks if two Axis Aligned Bounding Boxes (AABB) are
;; colliding.
;; 1. First, checks if they collide on the Y axis
;; 2. Then checks the X axis, only if Y intervals overlap
;;
;; Receives in DE and HL the addresses of two AABBs:
;;           -AABB 1-     -AABB 2-
;; Address   |BC| +1|     |DE| +1|
;; Values  
;; SPR_BASE  [y1][x1] ... [y2][x2]
;; AABB_BASE [h1][w1] ... [h2][w2]
;;
;; Returns Carry Flag (C=0, NC) when NOT colliding,
;; and (C=1, C) when colliding.
;;
;; INPUT:
;;      BC: Address of AABB 1
;;      DE: Address of AABB 2
;; OUTPUT:
;;      Carry: { NC: Not colliding } { C: colliding }
;;

are_boxes_colliding::
    push bc
    push de
    call are_intervals_overlapping
    pop de
    pop bc
    ret nc

    inc c
    inc e

    call are_intervals_overlapping
    ret


