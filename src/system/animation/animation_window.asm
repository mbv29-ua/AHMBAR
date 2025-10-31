include "system/animation/animation.inc"
include "src/constants.inc"

SECTION "Animation Window System", ROM0


;; INPUT
;; HL: ADDRESS OF TILES TO COPY
;; DE: DESTINATION
;;  B: cols
;;  C: rows
animation_window::
;ld de, WINDOW_PICTURE 


;ld c, 8   ;; FILAS
.loopCols:
    ;ld b, 14 
    push de
    push bc
    call memcpy_256
    
    pop bc
    pop de 

    push hl

    ld h, d
    ld l, e 

    ld de, 32
    add hl, de 

    ld d, h
    ld e, l 
    pop hl   
 
    
    dec c 
    jr nz, .loopCols
ret 

animation_window_start::
ld de, BG_MAP_START
 


ld c, 18   ;; FILAS
.loopCols:
    ld b, 20 
    call memcpy_256
    
    ld a, e 
    add 12
    ld e, a 

    ld a, d 
    adc 0
    ld d, a 

    dec c 
    jr nz, .loopCols
ret 