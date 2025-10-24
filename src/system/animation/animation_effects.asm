INCLUDE "constants.inc"

SECTION "Animation transitions", ROM0

fadeout_transition_palette_values::
.start: DB %11100100, %10010000, %01000000, %00000000
fadeout_transition_palette_end::

;; I leave it here because it can be useful
;superfadeout_transition_palette_values::
;.start: DB %11100100, %10100100, %10010100, %10010000, %01010000, %01000000, %00000000
;superfadeout_transition_palette_end::


SECTION "Animation effects", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Changes the palettes to create a fadeout effect
;;
;; INPUT:
;;       B: Frames between palette changes
;;       D: Numer of palette changes
;;      HL: Address where the palette values are stored
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B, C, D and HL.

apply_screen_colors_animation_effect::
	ld c, b ; We save the number of frames	
	.loop
		ld b, c
		push hl
		call wait_x_frames
		pop hl
		ld a, [hl+]
	    ldh [rBGP], a
	    ldh [rOBP0], a
	    ldh [rOBP1], a
		dec d
		jr nz, .loop
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Changes the palettes to create a fadeout effect
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B, C, D and HL.

fadeout::
	ld hl, fadeout_transition_palette_values
	ld  d, (fadeout_transition_palette_end-fadeout_transition_palette_values.start-1)
	ld  b, 6 ; 1/10 sec per color transition
	call apply_screen_colors_animation_effect
	ret

;; I leave it here because it can be useful
;superfadeout::
;	ld hl, superfadeout_transition_palette_values
;	ld  d, (superfadeout_transition_palette_end-superfadeout_transition_palette_values.start)
;	ld  b, 5 ; 1/12 sec per color transition
;	call apply_screen_colors_animation_effect
;	ret
