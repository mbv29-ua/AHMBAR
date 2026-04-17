INCLUDE "constants.inc"
INCLUDE "tiles.inc"
INCLUDE "entities/entities.inc"

SECTION "Player Animation", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the player tile
;; entities when there is a change of the scroll.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_player_sprite::
	ld h, CMP_ATTR_H
	ld l, PHY_FLAGS
	
	bit PHY_FLAG_GROUNDED, [hl]
	jr nz, .not_jumping
		ld h, CMP_SPRIT_H
		ld l, SPR_TILE
		ld [hl], TILE_PLAYER_JUMPING
	ret

	.not_jumping:
		ld h, CMP_PHYS_H
		ld l, PHY_VX
		ld a, [hl]
		or a
		jr nz, .walking

		ld h, CMP_SPRIT_H
		ld l, SPR_TILE
		ld [hl], TILE_PLAYER_WALKING_2
		ret

	.walking:
		ld h, CMP_CONT_H
		ld l, COUNT_MOVING_COOLDOWN
		ld a, [hl]
		and %00001000 ; 16, approximately changes tile every 0.25 seconds if walking.

		ld h, CMP_SPRIT_H
		ld l, SPR_TILE
		jr nz, .left_step
		.right_step:
			ld [hl], TILE_PLAYER_WALKING_1
			ret
		.left_step:
			ld [hl], TILE_PLAYER_WALKING_2
			ret