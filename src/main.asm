INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Entry Point", ROM0[$150]

main::
<<<<<<< HEAD

    
    ;call scene_title_screen
    call scene_intro_screen
=======
    ;call scene_title_screen
>>>>>>> miguel
    ld hl, scene_1
    call load_scene

    ; call init 

call wait_vblank
.main_loop:

    call update_fire_animation      ; Animate fire tiles during VBlank
    call read_pad
    ; call move_character
    call update_character_velocities
    ;call check_door_collision    ; COMENTADO - No queremos colisiones de puerta
    call apply_gravity_to_affected_entities
    ;call vertical_speed_to_zero_if_grounded
    ;call update_all_entities_positions
    call new_update_all_entities_positions
    ;call clamp_player_position       ; Limitar posición del jugador a los bordes del mapa
    call scroll_manager
    ; call render_player
    call update_bullet_system
    halt

    jp .main_loop

<<<<<<< HEAD
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
    ;call Init_Level_System
    call Load_Level1_Tiles
    ;call Load_Current_Level
    ;call init_scroll
    ;call init_player_position

    call init_tile_animation        ; Initialize fire animation system
    call init_hud                   ; Initialize HUD (lives & bullets) - ABAJO de pantalla
    call init_palettes_by_default

    call clean_OAM
    call enable_vblank_interrupts
    call enable_screen
    call init_palettes_by_default
    call init_enemigos_prueba  ; --> Descomentar (Debug)

    call screen_on
    

    ; Window ya está activada en screen_on (LCDC bit 5)

    ;call man_entity_alloc
    ;call man_entity_alloc
    ;call man_entity_alloc

    ret
=======
;init::
;    call screen_off
;
;    call copy_DMA_routine
;    call man_entity_init
;
;    call load_cowboy_sprites
;    call init_player
;    call load_bullet_sprites
;    ;call init_bullet_system
;    call init_counter
;
;    ; Inicializar y cargar nivel inicial
;    call Init_Level_System
;    call Load_Level1_Tiles
;    call Load_Current_Level
;    call init_scroll
;    call init_player_position
;    call init_tile_animation        ; Initialize fire animation system
;    call init_hud                   ; Initialize HUD (lives & bullets) - ABAJO de pantalla
;    call init_palettes_by_default
;    call clean_OAM
;    call enable_vblank_interrupts
;    call enable_screen
;
;    call init_enemigos_prueba  ; --> Descomentar (Debug)
;
;    call screen_on
;
;    ; Window ya está activada en screen_on (LCDC bit 5)
;
;    ;call man_entity_alloc
;    ;call man_entity_alloc
;    ;call man_entity_alloc
;
;    ret
>>>>>>> miguel

