INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Entry Point", ROM0[$150]

main::
    call init 

.main_loop:
    call wait_vblank
    call read_pad
    ;call move_character
    call update_character_velocities
    call update_all_entities_positions
    call check_door_collision
    call scroll_manager
    ;call render_player
    call Update_Bullet_System

    jp .main_loop

init::
    call screen_off

    call copy_DMA_routine
    call man_entity_init

    call load_cowboy_sprites
    call init_player
    call load_bullet_sprites
    call Init_Bullet_System
    call Init_Counter

    ; Inicializar y cargar nivel inicial
    call Init_Level_System
    call Load_Level1_Tiles
    call Load_Current_Level
    call init_scroll
    call init_player_position
    call init_palettes_by_default
    call clean_OAM
    call enable_vblank_interrupts
    call enable_screen

    call screen_on

    ;call man_entity_alloc
    ;call man_entity_alloc
    ;call man_entity_alloc

    ret


;; DE aqui a abajo ignorar que lo tengo que mover
testeo::
    ld h, CMP_PHYS_H
    ld l, e 
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