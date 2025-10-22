INCLUDE "constants.inc"

SECTION "Interrupt flags", WRAM0

vblank_flag: ds 1 ; Falta anadir el halt respectivo


; When a VBLANK interruption happens, the program jumps to this section
SECTION "VBlank Interrupt", ROM0[INTERRUPT_VBLANK] ; $40 VBLANK interruptions <= Space for only 8 bytes

jp vblank_handler ; Routine that manages the VBLANK interruption (3 bytes)
ds 5, 0          ; Leaves 5 empty bytes



SECTION "Interrupt handlers", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function manages VBLANK-type interruptions
;; INPUT:
;;      -
;; OUTPUT:
;;      -

vblank_handler:
   push hl
   call OAMDMA
   ld hl, vblank_flag
   ld [hl], 1
   pop hl
   reti