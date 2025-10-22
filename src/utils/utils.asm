SECTION "utils", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine copies B consecutive bytes of
;; data stored in memory position starting in
;; HL into the memory position starting in DE.
;; The maximum amount of data is restricted to
;; 256 bytes.
;;
;; INPUT:
;;      HL: Data source
;;      DE: Data destiny
;;       B: Total bytes to be copied
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B, DE and HL.

memcpy_256::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, memcpy_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets B consecutive bytes in the
;; memory positions starting in HL to value A.
;; The maximum amount of set bytes is restricted 
;; to 256 bytes.
;;
;; INPUT:
;;      HL: Data destiny
;;       B: Total bytes to be set
;;       A: Value to be set
;; OUTPUT:
;;      -
;; WARNING: Destroys B and HL.

memset_256::
    ld [hl+], a
    dec b
    jr nz, memset_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets B consecutive bytes in the
;; memory positions starting in HL to value 0.
;; The maximum amount of set bytes is restricted 
;; to 256 bytes.
;;
;; INPUT:
;;      HL: Data destiny
;;       B: Total bytes to be set to 0
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B and HL.

memreset_256::
    xor a
    call memset_256
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine copies B consecutive bytes of
;; data stored in memory position starting in
;; HL into the memory position starting in DE.
;; The maximum amount of data is restricted to
;; 65536 bytes.
;;
;; INPUT:
;;      HL: Data source
;;      DE: Data destiny
;;       B: Total bytes to be copied
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B, DE and HL.

memcpy_65536:
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz , memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets BC consecutive bytes in
;; memory position starting in HL to value A.
;; The maximum amount of set bytes is restricted 
;; to 65536 bytes.
;;
;; INPUT:
;;      HL: Data destiny
;;      BC: Total bytes to be set
;;       A: Value to be set
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B, C, D and HL.

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets BC consecutive bytes in the
;; memory positions starting in HL to value 0.
;; The maximum amount of set bytes is restricted 
;; to 65536 bytes.
;;
;; INPUT:
;;      HL: Data destiny
;;      BC: Total bytes to be set to 0
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B, C, D and HL.

memreset_65536::
    xor a 
    call memset_65536
    ret
