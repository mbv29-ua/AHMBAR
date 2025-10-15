INCLUDE "constants.inc"


SECTION "Entry Point", ROM0[$150]

main::
    call init 

.main_loop:
    jp .main_loop

init::
    ;call screen_off

    call man_entity_init


    ;call clean_OAM
    ;call Load_Level1_Tiles
    ;call Load_Level1_Map
    ;call init_palettes_by_default
    ;call enable_vblank_interrupts
    ;call enable_screen

    ;call load_cowboy_sprites

    ;call screen_on
    
    call man_entity_alloc
    call man_entity_alloc
    ret