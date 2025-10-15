include "utils/joypad.inc"
include "constants.inc"

SECTION "Joypad Handling", ROM0

read_pad::
   ld a, SELECT_PAD
   ldh [rP1], a
   ldh a, [rP1] ; Esperamos 3
   ldh a, [rP1] 
   ldh a, [rP1]

    cpl
    swap a
    and $F0

    ld b, a
    ld a, SELECT_BUTTONS
    ldh [rP1], a
    ldh a, [rP1] ; Esperamos 3
    ldh a, [rP1] 
    ldh a, [rP1]

    cpl
    and $0F
    add a, b

    ld [PRESSED_BUTTONS], a
ret
