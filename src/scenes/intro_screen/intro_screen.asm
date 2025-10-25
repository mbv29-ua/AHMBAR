include "constants.inc"

SECTION "Vars", WRAM0
wSkyPos:     db
wGroundPos:  db
wDunasScroll: db
wArenaScroll: db

SECTION "Intro screen scene", ROM0


scene_intro_screen::
    call intro_scene_init

    ;ld hl, rWX 
    ;ld [hl], 0
    ;ld hl, rWY
    ;ld [hl], 70

    call wait_vblank

    ld hl, $98E0
    ld a, $02
    ld b, 96

    call memset_256



    call screen_window_dialog
    ld hl, intro_text
    call write_super_extended_dialog

    ld hl, $9800
    ld a, $01
    ld b, 10

    call memset_256
    

.scroll:
    call wait_vblank
    

    ; --- PARTE SUPERIOR (dunas / cielo) ---
    ld a, [wDunasScroll]
    ldh [rSCX], a

    ; Espera hasta la línea de corte
.wait_line_cut:
    ldh a, [rLY]
    cp a, 111
    jr nz, .wait_line_cut

    ; --- Delay fijo PARA PROBAR ---
    nop                        
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
   

    ; --- Cambio de scroll justo al empezar modo 3 --- ES MENTIRAA MENTIRAAAAAA!!
    ld a, [wArenaScroll]       
    ldh [rSCX], a               
    

    ; --- ACTUALIZAR DESPLAZAMIENTOS ---
    ld a, [wDunasScroll]
    add a, 1
    ld [wDunasScroll], a

    ld a, [wArenaScroll]
    add a, 2
    ld [wArenaScroll], a

    call wait_a_frame
    jr .scroll

    call wait_until_A_pressed
	call fadeout

    
    ret

intro_scene_init::
    call screen_off
    call clean_OAM

    ;; esto es para borrar el logo de nintendo
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