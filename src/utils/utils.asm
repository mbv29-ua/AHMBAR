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


