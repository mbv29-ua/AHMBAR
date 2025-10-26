include "utils/joypad.inc"
include "constants.inc"

SECTION "Joypad Handling", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine reads the joypad and stores three
;; values in memory:
;; [PRESSED_BUTTONS] - buttons currently pressed
;; [JUST_PRESSED_BUTTONS] - buttons that have 
;;                          been pressed in the
;;                          current frame.
;; [RELEASED_BUTTONS] - buttons that have been 
;;                          released in the
;;                          current read.
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A and B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

read_pad::
   ld a, SELECT_PAD
   ldh [rP1], a
   ldh a, [rP1] ; Esperamos 3
   ldh a, [rP1] 
   ldh a, [rP1]

   cpl
   and $0F ; Mask to keep the last 4 bits
   swap a

   ld b, a
   ld a, SELECT_BUTTONS
   ldh [rP1], a
   ldh a, [rP1] ; Esperamos 3
   ldh a, [rP1] 
   ldh a, [rP1]

   cpl
   and $0F ; Mask to keep the last 4 bits
   add a, b


   ld b, a ; b has current pressed_buttons

   ; pressed  = (previous xor current) & current;  // flanco de subida
   ld  a, [PRESSED_BUTTONS] ; a has previously pressed_buttons
   xor b   ; para saber que botones han cambiado de estado
   and b   ; nos quedamos con los botones pulsados que han cambiado de estado (flanco ascendente)
   ld [JUST_PRESSED_BUTTONS], a

   ; released = (previous xor current) & previous; // flanco de bajada
   ld  a, [PRESSED_BUTTONS] ; a has previously pressed_buttons
   xor b  ; Almacenamos los bits de todas las direcciones y botones pulsados A = [d,u,l,r,st,se,b,a]
   and a  ; para saber que botones han cambiado de estado
   ld [RELEASED_BUTTONS], a

   ld a, b
   ld [PRESSED_BUTTONS], a
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine reads the joypad until the
;; button A is pressed.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B and HL 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wait_until_A_pressed::
   ld hl, JUST_PRESSED_BUTTONS
   .loop:
      call read_pad
      bit BUTTON_A, [hl]
      jr z, .loop
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine reads the joypad until the
;; button START is pressed.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B and HL 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wait_until_start_pressed::
   ld hl, JUST_PRESSED_BUTTONS
   .loop:
      halt
      call read_pad
      bit BUTTON_START, [hl]
      jr z, .loop
   ret