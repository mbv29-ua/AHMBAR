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
    ; Copy tile A8 -> A4 (VRAM $8A40)
    ld de, $8A40
    ld hl, $8A80        ; Source: tile A8
    ld bc, 16
    call copy_vram_to_vram

    ; Copy tile A8 -> A6 (VRAM $8A60)
    ld de, $8A60
    ld hl, $8A80        ; Source: tile A8
    ld bc, 16
    call copy_vram_to_vram
    ret

.load_frame1:
    ; Copy tile A9 -> A4 (VRAM $8A40)
    ld de, $8A40
    ld hl, $8A90        ; Source: tile A9
    ld bc, 16
    call copy_vram_to_vram

    ; Copy tile A9 -> A6 (VRAM $8A60)
    ld de, $8A60
    ld hl, $8A90        ; Source: tile A9
    ld bc, 16
    call copy_vram_to_vram
    ret

.load_frame2:
    ; Copy tile AA -> A4 (VRAM $8A40)
    ld de, $8A40
    ld hl, $8AA0        ; Source: tile AA
    ld bc, 16
    call copy_vram_to_vram

    ; Copy tile AA -> A6 (VRAM $8A60)
    ld de, $8A60
    ld hl, $8AA0        ; Source: tile AA
    ld bc, 16
    call copy_vram_to_vram
    ret

.load_frame3:
    ; Copy tile AB -> A4 (VRAM $8A40)
    ld de, $8A40
    ld hl, $8AB0        ; Source: tile AB
    ld bc, 16
    call copy_vram_to_vram

    ; Copy tile AB -> A6 (VRAM $8A60)
    ld de, $8A60
    ld hl, $8AB0        ; Source: tile AB
    ld bc, 16
    call copy_vram_to_vram
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; copy_vram_to_vram
;;;; Copies data from VRAM to VRAM (must be called during VBlank)
;;;;
;;;; Input:
;;;;   HL = Source address (VRAM)
;;;;   DE = Destination address (VRAM)
;;;;   BC = Number of bytes to copy
;;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copy_vram_to_vram:
.loop:
    ld a, [hl+]         ; Load byte from source VRAM
    ld [de], a          ; Write to destination VRAM
    inc de              ; Next VRAM address
    dec bc              ; Decrement counter
    ld a, b
    or c                ; Check if BC = 0
    jr nz, .loop        ; Continue if not zero
    ret
