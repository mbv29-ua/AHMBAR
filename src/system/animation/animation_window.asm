include "system/animation/animation.inc"

SECTION "Animation Window System", ROM0


;; INPUT
;; HL: ADDRESS OF TILES TO COPY
animation_window::
ld de, WINDOW_PICTURE 


ld c, 8   ;; FILAS
.loopCols:
    ld b, 14 
    call memcpy_256
    
    ld a, e 
    add 18
    ld e, a 

    ld a, d 
    adc 0
    ld d, a 

    dec c 
    jr nz, .loopCols
ret 
