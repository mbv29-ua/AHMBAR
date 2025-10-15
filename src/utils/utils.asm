SECTION "utils", ROM0


; Input
;  hl -> source
;  de -> destiny
; b -> counter
; Warning: Destoy b, hl and de
memcpy_256::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, memcpy_256
    ret

; Input
;  hl -> source
;  de -> destiny
; bc -> counter
; Warning: Destoy b, c, hl and de
memcpy_65536:
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz , memcpy_65536
    ret

;; INPUT
;;  HL: SOURCE
;;  BC: COUNTER
;;   A: VALUE TO SET
;; WARNING: DESTROYS HL AND BC

memset_65536::
    ld d, a
    .loop:
        ld a, d 
        ld [hl+], a
        dec bc
        ld a, b 
        or c 
        jr nz, .loop
    ret 

; INPUT
;  HL: DESTINY
;  BC: COUNTER
; WARNING: DESTROY HL AND BC

memreset_65536::
    xor a 
    call memset_65536
    ret

; Input
;  hl -> destiny
;  b -> counter
;  a -> value
; Warning: Destoy b and hl
memset_256::
    ld [hl+], a
    dec b
    jr nz, memset_256
    ret

; Input
;  hl -> destiny
;  b -> counter
; Warning: destroy a, b and hl
memreset_256::
    xor a
    call memset_256
    ret