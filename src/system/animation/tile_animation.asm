INCLUDE "constants.inc"

SECTION "Tile Animation System", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Fire Animation Data
;;;; 4 frames cycling animation for fire tiles
;;;; Animates tiles A4 and A6 using frames A8, A9, AA, AB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION "Animation Variables", WRAM0
wFireAnimFrame: DS 1      ; Current animation frame (0-3)
wFireAnimCounter: DS 1    ; Counter for animation timing

SECTION "Tile Animation Code", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; this routine does not process any animation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

no_animation::
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; init_tile_animation
;;;; Initializes the tile animation system
;;;;
;;;; Destroys: A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_tile_animation::
    xor a
    ld [wFireAnimFrame], a
    ld [wFireAnimCounter], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; update_fire_animation
;;;; Updates the fire tile animation in VRAM
;;;; Animates tiles A4 and A6 using frames A8, A9, AA, AB
;;;; Should be called during VBlank
;;;;
;;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_fire_animation::
    ; Increment animation counter
    ld a, [wFireAnimCounter]
    inc a
    ld [wFireAnimCounter], a

    ; Check if we should change frame (every 15 frames = ~0.25 sec at 60fps)
    cp 15
    ret c               ; Return if counter < 15

    ; Reset counter and advance animation frame
    xor a
    ld [wFireAnimCounter], a

    ; Advance to next fire frame (0->1->2->3->0)
    ld a, [wFireAnimFrame]
    inc a
    and %00000011       ; Wrap around at 4 (0-3)
    ld [wFireAnimFrame], a


    ; Update fire tiles A4 and A6 in VRAM
    ; Tiles A8, A9, AA, AB are the 4 animation frames
    ; Update ONLY top fire tiles in VRAM
    ; $84 and $86 = FIRE TOP (animated)
    ; Check which frame we're on
    or a                ; Frame 0?
    jp z, .load_frame0
    dec a               ; Frame 1?
    jp z, .load_frame1
    dec a               ; Frame 2?
    jp z, .load_frame2
    ; Must be frame 3
    jp .load_frame3

.load_frame0:
    ; Load fireFrame0 -> VRAM $8A40 (tile $A4 - top fire)
    ld de, $8A40
    ld hl, fireFrame0
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame0 -> VRAM $8A60 (tile $A6 - top fire)
    ld de, $8A60
    ld hl, fireFrame0
    ld bc, 16
    call copy_to_vram
    ret

.load_frame1:
    ; Load fireFrame1 -> VRAM $8A40 (tile $A4 - top fire)
    ld de, $8A40
    ld hl, fireFrame1
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame1 -> VRAM $8A60 (tile $A6 - top fire)
    ld de, $8A60
    ld hl, fireFrame1
    ld bc, 16
    call copy_to_vram
    ret

.load_frame2:
    ; Load fireFrame2 -> VRAM $8A40 (tile $A4 - top fire)
    ld de, $8A40
    ld hl, fireFrame2
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame2 -> VRAM $8A60 (tile $A6 - top fire)
    ld de, $8A60
    ld hl, fireFrame2
    ld bc, 16
    call copy_to_vram
    ret

.load_frame3:
    ; Load fireFrame3 -> VRAM $8A40 (tile $A4 - top fire)
    ld de, $8A40
    ld hl, fireFrame3
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame3 -> VRAM $8A60 (tile $A6 - top fire)
    ld de, $8A60
    ld hl, fireFrame3
    ld bc, 16
    call copy_to_vram
    ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copy_to_vram
;;; Copies data to VRAM (must be called during VBlank)
;;;
;;; Input:
;;;   HL = Source address (ROM)
;;;   DE = Destination address (VRAM)
;;;   BC = Number of bytes to copy
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copy_to_vram:
    call memcpy_65536
    ret
;    .loop:
;        ld a, [hl+]         ; Load byte from source
;        ld [de], a          ; Write to VRAM
;        inc de              ; Next VRAM address
;        dec bc              ; Decrement counter
;        ld a, b
;        or c                ; Check if BC = 0
;        jr nz, .loop        ; Continue if not zero
;        ret
