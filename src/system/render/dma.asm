INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;     OAM DMA     ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION "OAM DMA", ROMX

;; Realiza una transferencia DMA y espera 160 ciclos a que se complete
DMA_routine:
   ld a, HIGH(SPR_BASE) ; Obtiene el byte alto de la direccion copiaOAM
   ldh [rDMA], a       ; Inicia la transferencia DMA

   ld a, OAM_TOTAL_SPRITES ; Espera un total de 40x4=160 ciclos
   .wait
      dec a 		; un ciclo
      jr nz, .wait  ; tres ciclos
	ret
.end


;; Copia la funcion rutinaDMA en HRAM <- Pensar si se puede reescribir con memcpy
copy_DMA_routine::
   ld hl, DMA_routine                   ; Direccion de la rutina a copiar
   ld  b, DMA_routine.end - DMA_routine ; Tamano de la rutina
   ld  c, LOW(OAMDMA)                   ; Direccion de inicio donde almacenar la rutina en HRAM
   .loop
      ld a, [hl+]
      ldh [c], a
      inc c
      dec b
      jr nz, .loop
	ret



SECTION "OAM DMA routine copy", HRAM

OAMDMA:: ds DMA_routine.end - DMA_routine ; Reservamos la cantidad de espacio para albergar nuestra rutina
