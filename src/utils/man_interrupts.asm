INCLUDE "constants.inc"

SECTION "Interrupt flags", WRAM0

vblankFlag: ds 1 ; Falta anadir el halt respectivo


; Cuando se da una interrupcion de tipo VBlank, el programa salta a esta seccion
SECTION "VBlank Interrupt", ROM0[INTERRUPT_VBLANK] ; $40 VBLank <= Solo caben 8 bytes

jp vblankHandler ; Funcion que gestiona la interrupcion (3 bytes)
ds 5, 0          ; Deja 5 bytes vacios ; Eliminar



SECTION "Interrupt handlers", ROM0

; Esta funcion es la encargada de gestionar las interrupciones del tipo VBlank
vblankHandler:
   push hl
   call OAMDMA
   ld hl, vblankFlag
   ld [hl], 1
   pop hl
   reti