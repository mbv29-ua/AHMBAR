SECTION "Title screen scene", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine shows the title screen.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_title_screen::
	call title_screen_init
	ld hl, credits
	call write_super_extended_dialog
	call wait_until_A_pressed
	call fadeout
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans the necessary parts of the 
;; memory and initialize the assets used in the
;; title screen.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys ??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

title_screen_init::
    call screen_off
    call clean_OAM
    call clean_bg_map
    call copy_DMA_routine
    call load_fonts
    call init_palettes_by_default
    call screen_on
    ret


