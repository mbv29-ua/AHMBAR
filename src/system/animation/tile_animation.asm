INCLUDE "constants.inc"

SECTION "Tile Animation System", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Fire Animation Data
;;; 4 frames cycling animation for fire tiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION "Animation Variables", WRAM0[$CE20]
wFireAnimFrame: DS 1      ; Current animation frame (0-3)
wFireAnimCounter: DS 1    ; Counter for animation timing

SECTION "Tile Animation Code", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init_tile_animation
;;; Initializes the tile animation system
;;;
;;; Destroys: A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init_tile_animation::
    xor a
    ld [wFireAnimFrame], a
    ld [wFireAnimCounter], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; update_fire_animation
;;; Updates the fire tile animation in VRAM
;;; Animates ONLY the top tiles ($84 and $86)
;;; Bottom tiles ($85 and $87) stay STATIC
;;; Should be called during VBlank
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_fire_animation::
    ; Increment animation counter
    ld a, [wFireAnimCounter]
    inc a
    ld [wFireAnimCounter], a

    ; Check if we should change frame (every 8 frames = ~8/60 sec)
    cp 8
    ret c               ; Return if counter < 8

    ; Reset counter and advance animation frame
    xor a
    ld [wFireAnimCounter], a

    ; Advance to next fire frame (0->1->2->3->0)
    ld a, [wFireAnimFrame]
    inc a
    and %00000011       ; Wrap around at 4 (0-3)
    ld [wFireAnimFrame], a

    ; Update ONLY top fire tiles in VRAM
    ; $84 and $86 = FIRE TOP (animated)
    ; $85 and $87 = PLATFORM (static, never updated)

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
    ; Load fireFrame0 -> VRAM $8840 (tile $84 - top fire)
    ld de, $8A40
    ld hl, fireFrame0
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame0 -> VRAM $8860 (tile $86 - top fire)
    ld de, $8A60
    ld hl, fireFrame0
    ld bc, 16
    call copy_to_vram
    ret

.load_frame1:
    ; Load fireFrame1 -> VRAM $8840 (tile $84 - top fire)
    ld de, $8A40
    ld hl, fireFrame1
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame1 -> VRAM $8860 (tile $86 - top fire)
    ld de, $8A60
    ld hl, fireFrame1
    ld bc, 16
    call copy_to_vram
    ret

.load_frame2:
    ; Load fireFrame2 -> VRAM $8840 (tile $84 - top fire)
    ld de, $8A40
    ld hl, fireFrame2
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame2 -> VRAM $8860 (tile $86 - top fire)
    ld de, $8A60
    ld hl, fireFrame2
    ld bc, 16
    call copy_to_vram
    ret

.load_frame3:
    ; Load fireFrame3 -> VRAM $8840 (tile $84 - top fire)
    ld de, $8A40
    ld hl, fireFrame3
    ld bc, 16
    call copy_to_vram

    ; Load fireFrame3 -> VRAM $8860 (tile $86 - top fire)
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
.loop:
    ld a, [hl+]         ; Load byte from source
    ld [de], a          ; Write to VRAM
    inc de              ; Next VRAM address
    dec bc              ; Decrement counter
    ld a, b
    or c                ; Check if BC = 0
    jr nz, .loop        ; Continue if not zero
    ret
