INCLUDE "utils/arithmetic_macros.inc"

SECTION "Arithmetic operations", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine computes |A| taking into account
;; that we can interpret bytes as a representation
;; of complement-2 integers ranging in the
;; interval [-128,127].
;;		$00 	= 0
;; 		$01-$7F = [1,127]
;; 		$80-$FF = [-128,-1]
;;
;; INPUT:
;;		A: 8-bit integer
;; OUTPUT:
;;		A: -A	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; No he podido convertirla en MACRO sin que me de conflictos :()

abs_value_a::
	cp $7F
	ret c
	
	opposite_of_a
	ret