INCLUDE "constants.inc"

SECTION "Score Variables", WRAM0

score_digits:
    ds 2 ; Reserves 2 bytes for each digit of the score (e.g., 00)

score_value:
    ds 2 ; Reserves 2 bytes for the actual numerical score (0-99)

SECTION "Score Routines", ROM0

; Initializes the HUD score to 00 and displays it on screen
init_hud_score_display::
    ; Initialize score_value to 0
    xor a
    ld [score_value], a
    ld [score_value+1], a

    ; Initialize score_digits to 0s
    ld hl, score_digits
    ld a, 0
    ld [hli], a ; score_digits[0] = 0
    ld [hl], a  ; score_digits[1] = 0

    ; Display "00" at HUD location (tile 0,5 and 0,6 in Window tilemap)
    ld hl, $9C00 + 5 ; Start of HUD score display
    ld de, score_digits
    ld c, 2 ; Loop 2 times for 2 digits
.display_loop:
    ld a, [de]      ; Get digit value (0-9)
    add a, TILE_COWBOY ; Convert to tile ID (TILE_COWBOY for testing)
    ld [hli], a     ; Write tile ID to VRAM
    inc de          ; Next digit in score_digits
    dec c
    jr nz, .display_loop
    ret

; Renders the current score to the HUD
render_hud_score::
    ; Convert score_value (binary) to score_digits (decimal)
    call bin_to_bcd_2_digits

    ; Update display at HUD location
    ld hl, $9C00 + 5 ; Start of HUD score display
    ld de, score_digits
    ld c, 2 ; Loop 2 times for 2 digits
.update_display_loop:
    ld a, [de]      ; Get digit value (0-9)
    add a, TILE_DIGIT_0 ; Convert to tile ID (70-79)
    ld [hli], a     ; Write tile ID to VRAM
    inc de          ; Next digit in score_digits
    dec c
    jr nz, .update_display_loop
    ret

; Increments the score by 1 and updates the display
increment_score_and_display::
    ; Increment score_value
    ld hl, score_value
    inc [hl]
    jr nz, .no_carry_low
    inc hl       ; Move HL to score_value+1
    inc [hl]     ; Increment score_value+1
.no_carry_low:

    ; Cap score at 99
    ld hl, score_value
    ld a, [hl]
    cp 100
    jr c, .no_cap_low
    xor a
    ld [hl], a
    inc hl
    ld [hl], a ; Clear high byte if it was 100 or more
.no_cap_low:

    ; Render the updated score to the HUD
    call render_hud_score
    ret

; Binary to 2-digit BCD conversion routine (0-99)
; Input: score_value (16-bit binary, only low byte used for 0-99) in WRAM
; Output: score_digits (2 bytes, each a decimal digit) in WRAM
bin_to_bcd_2_digits::
    ; Clear score_digits
    ld hl, score_digits
    xor a
    ld [hli], a
    ld [hl], a

    ld hl, score_value
    ld a, [hl] ; Get low byte of score_value (0-99)

    ; Calculate tens digit
    ld b, 0 ; Counter for tens
.tens_loop:
    cp 10
    jr c, .tens_done
    sub 10
    inc b
    jr .tens_loop
.tens_done:
    ld hl, score_digits
    ld [hl], b ; Store tens digit

    ; A now contains the units digit
    inc hl
    ld [hl], a ; Store units digit

    ret