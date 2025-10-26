INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "utils/joypad.inc"

SECTION "Entry Point", ROM0[$150]

main::
    call scene_title_screen
    ld hl, scene_1
    call load_scene

    ; call init 

call wait_vblank
.main_loop:

    call update_fire_animation      ; Animate fire tiles during VBlank
    call render_hud                 ; Actualizar HUD en VBlank
    call read_pad

    ; DEBUG: SELECT para perder 1 vida
    ld a, [JUST_PRESSED_BUTTONS]
    bit BUTTON_SELECT, a
    call nz, lose_life

    call update_character_velocities
    call check_door_collision
    call apply_gravity_to_affected_entities
    call update_all_entities_positions
    call clamp_player_position
    call scroll_manager
    call update_bullet_system
    halt

    jp .main_loop

init::
    call screen_off

    call copy_DMA_routine
    call man_entity_init

    call load_cowboy_sprites
    call init_player
    call load_bullet_sprites
    ;call init_bullet_system
    call init_counter

    ; Inicializar y cargar nivel inicial
    call Init_Level_System
    call Load_Level1_Tiles
    call Load_Current_Level
    call init_scroll
    call init_player_position
    call init_tile_animation        ; Initialize fire animation system
    call init_hud                   ; Initialize HUD (lives & bullets) - ABAJO de pantalla
    call init_palettes_by_default
    call clean_OAM
    call enable_vblank_interrupts
    call enable_screen

    call init_enemigos_prueba  ; --> Descomentar (Debug)

    call screen_on

    ; Window ya está activada en screen_on (LCDC bit 5)

    ;call man_entity_alloc
    ;call man_entity_alloc
    ;call man_entity_alloc

    ret


;; DE aqui a abajo ignorar que lo tengo que mover
;testeo::
;    ld h, CMP_PHYS_H
;    ld l, e 
;    set 7, [hl]
;    ret


;; DE = ENTIDAD
;sys_physics_update_one_entity::
;    ld h, CMP_PHYS_H
;    ld l, e 
;    ret


;sys_physics_update::
;    ld hl, testeo
;    call man_entity_for_each
;    ret