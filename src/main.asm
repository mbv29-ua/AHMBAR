INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "utils/joypad.inc"

SECTION "Entry Point", ROM0[$150]

main::
    ;call scene_title_screen
    call scene_intro_screen
    call start_game

call wait_vblank
.main_loop:

    call update_fire_animation      ; Animate fire tiles during VBlank
    call update_hud_if_needed       ; Update HUD if flag is set (during VBlank)
    call update_spike_cooldown      ; Decrement spike damage cooldown
    call read_pad

    ; DEBUG: SELECT para perder vida (testing Game Over)
    ld a, [JUST_PRESSED_BUTTONS]
    bit BUTTON_SELECT, a
    call nz, lose_life

    ; call move_character
    call update_character_velocities
    call process_all_enemies_AIs
    call apply_gravity_to_affected_entities

    ; IMPORTANTE: Destruir balas ANTES de actualizar posiciones
    call destroy_bullets_out_of_bounds ; Destroy bullets that are off-screen FIRST
    call check_bullet_wall_collision  ; Destroy bullets hitting walls
    call check_bullet_enemy_collision ; Check bullet-enemy collisions

    call update_all_entities_positions
    call clamp_player_position
    call scroll_manager
    ; call render_player

    call check_door_collision       ; Check door tiles ($C0-$C3) to trigger next level
    call check_deadly_collision     ; Check deadly tiles (spikes) to damage player
    call check_enemy_collision      ; Check collision with enemies
    call update_bullet_system
    halt

    jp .main_loop


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
;    ;call Init_Level_System
;    call Load_Level1_Tiles
;    ;call Load_Current_Level
;    ;call init_scroll
;    ;call init_player_position
;
;    call init_tile_animation        ; Initialize fire animation system
;    call init_hud                   ; Initialize HUD (lives & bullets) - ABAJO de pantalla
;    call init_palettes_by_default
;
;    call clean_OAM
;    call enable_vblank_interrupts
;    call enable_screen
;    call init_palettes_by_default
;    call init_enemigos_prueba  ; --> Descomentar (Debug)
;
;    call screen_on
    ;
;
;    ; Window ya está activada en screen_on (LCDC bit 5)
;
;    ;call man_entity_alloc
;    ;call man_entity_alloc
;    ;call man_entity_alloc
;
;    ret

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


