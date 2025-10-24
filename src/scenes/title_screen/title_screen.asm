SECTION "Title screen scene", ROM0


scene_title_screen::
	call title_screen_init
	ld hl, credits
	call write_super_extended_dialog
	call wait_until_A_pressed
	call fadeout
	ret


title_screen_init::
    call screen_off
    call clean_OAM
    call clean_bg_map
    call copy_DMA_routine
    call load_fonts
    call init_palettes_by_default
    call screen_on
    ret


