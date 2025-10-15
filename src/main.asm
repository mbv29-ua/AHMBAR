INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Entry Point", ROM0[$150]

main::
    call init 

.main_loop:
    call sys_physics_update
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
    call man_entity_alloc


    
    ret

testeo::
    ld hl, PHYS_BASE
    set 7, [hl]
    ret


;; DE = ENTIDAD
sys_physics_update_one_entity::
    ld h, CMP_PHYS_H
    ld l, e 
    ret


sys_physics_update::
    ld hl, testeo
    call man_entity_for_each
    ret