include "constants.inc"

SECTION "Intro screen scene", ROM0

scene_intro_screen::
    call intro_scene_init
    ld hl, intro_text
    call write_super_extended_dialog
    call wait_until_A_pressed
	call fadeout

    
    ret

intro_scene_init::
    call screen_off
    call clean_OAM
    ld hl, $9800        ; inicio del tilemap
    ld bc, 1024         ; número de bytes a limpiar
    .clear_loop:
    ld [hl], 0          ; escribe tile 0 (vacío)
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .clear_loop

    call copy_DMA_routine
    call load_fonts

    ld a, %00100111
    ldh [rBGP], a
    call screen_on
    ret