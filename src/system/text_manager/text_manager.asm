include "utils/joypad.inc"
include "constants.inc"
include "system/text_manager/text_manager_constants.inc"

SECTION "Dialogs manager", ROM0

; Input HL: linea
clean_line::
   ld  b, TEXTLINE_SIZE
   call memreset_256
   ret

; Esta funcion limpia el cuadro de dialogo
clean_dialog_box::
   ld hl, FIRST_DIALOG_LINE
   call clean_line

   ld hl, SECOND_DIALOG_LINE
   call clean_line

   ld hl, FIRST_DIALOG_LINE
   call clean_line

   ld hl, SECOND_DIALOG_LINE
   call clean_line
ret


; HL: text
; DE: line
; Output: A contains ENDLINE or ENDTEXT
write_line::
	.loop:
		; We wait 3 or 1 frames depending if A is pressed or not
		push hl
		call read_pad
		ld a, [PRESSED_BUTTONS] 
		bit BUTTON_A, a
		jr nz, .write_faster
			call wait_a_frame
			call wait_a_frame
			call wait_a_frame
		.write_faster:
		call wait_a_frame
		pop hl

		ld a, [hl+]
		; We check if we reached the end of the line
		cp ENDLINE
		ret z

		; We check if we reached the end of the text
		cp ENDTEXT
		ret z

		; We write the character
	    ld [de], a
   		inc de
		jr .loop


; HL: Dialog
write_short_dialog:
	.loop:
		ld de, FIFTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, SIXTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		call wait_until_A_pressed
		call clean_dialog_box
		jr .loop


; HL: Dialog
write_extended_dialog:
	.loop:
		ld de, THIRD_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, FOURTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, FIFTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, SIXTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		call wait_until_A_pressed
		call clean_dialog_box
		jr .loop

; HL: Dialog
write_super_extended_dialog:
	.loop:
		ld de, FIRST_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, SECOND_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, THIRD_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, FOURTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, FIFTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		ld de, SIXTH_DIALOG_LINE
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		cp ENDTEXT
		ret z

		call wait_until_A_pressed
		call clean_dialog_box
		jr .loop