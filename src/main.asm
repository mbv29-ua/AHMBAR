INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "utils/joypad.inc"

SECTION "Entry Point", ROM0[$150]

main::
    ; call scene_title_screen --> fet por Jaime (Borrarlo)
    ;call scene_intro_screen
    call start_game

    ; call wait_vblank
.main_loop:

    ;; Routines accessing the VRAM must be placed here (still VBlank)
    ; call render_hud
    ; call update_fire_animation      ; Animate fire tiles during VBlank
    call update_player_sprite
    call process_scene_background_animation
    call update_hud_if_needed       ; Update HUD if flag is set (during VBlank)
    call manage_death_animations

    ;; Routines not accessing the VRAM should be placed here
    call hUGE_dosound               ; Update hUGE music driver

    call generate_random_number
    call man_entity_count_number_of_enemies

    call update_spike_cooldown      ; Decrement spike damage cooldown
    call read_pad

    ; DEBUG: SELECT para perder vida (testing Game Over)
    ;; ld a, [JUST_PRESSED_BUTTONS]
    ;; bit BUTTON_SELECT, a
    ;; call nz, lose_life

    call update_character_velocities
    call apply_intelligent_behavior_to_enemies
    call process_all_enemies_AIs
    call apply_gravity_to_affected_entities

    ; IMPORTANTE: Destruir balas ANTES de actualizar posiciones
    ; call destroy_bullets_out_of_bounds ; Destroy bullets that are off-screen FIRST
    call destroy_entities_out_of_screen
    call check_ambar_collisions
    call check_all_bullets_wall_collision  ; Destroy bullets hitting walls
    call check_all_bullets_enemy_collision ; Check bullet-enemy collisions

    call update_all_entities_positions
    call clamp_player_position
    call scroll_manager

    ;call check_door_collision       ; Check door tiles ($C0-$C3) to trigger next level
    call check_next_scene_trigger
    call check_deadly_collision     ; Check deadly tiles (spikes) to damage player
    call check_enemy_collision      ; Check collision with enemies
    call update_bullet_system

    call destroy_dead_enemies
    ; call kill_enemies_if_life_is_0
    call check_lives
    halt

    jp .main_loop
