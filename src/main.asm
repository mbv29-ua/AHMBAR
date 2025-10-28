INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "utils/joypad.inc"

SECTION "Entry Point", ROM0[$150]

main::
    ; call scene_title_screen --> fet por Jaime (Borrarlo)
    call scene_intro_screen
    call start_game

    ; call wait_vblank
.main_loop:

    ;; Intentar poner aqui todo lo que vaya en VBank
    ;call render_hud
<<<<<<< HEAD
    call hUGE_dosound               ; Update hUGE music driver
=======
    ;call sound_music
>>>>>>> 4c371c2ffab6c7cb77f331b6cf81cbd2738a9670

    call update_fire_animation      ; Animate fire tiles during VBlank
    call update_hud_if_needed       ; Update HUD if flag is set (during VBlank)
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
    call check_all_bullets_wall_collision  ; Destroy bullets hitting walls
    call check_bullet_enemy_collision ; Check bullet-enemy collisions

    call update_all_entities_positions
    call clamp_player_position
    call scroll_manager

    call check_door_collision       ; Check door tiles ($C0-$C3) to trigger next level
    call check_deadly_collision     ; Check deadly tiles (spikes) to damage player
    call check_enemy_collision      ; Check collision with enemies
    call update_bullet_system

    call check_lives
    halt

<<<<<<< HEAD
    jp .main_loop
=======
    jp .main_loop
;
;Notes:
;dw $060b, $0642, $0672, $0689, $06b2, $06d6, $06f7, $0706
;dw $06f7, $06d6, $06b2, $0689, $0672, $0642, $060b, $0000
;
;sound_music::
;    xor a
;    ld [WRAM_NOTE_INDEX], a
;    copy [rNR10], $00
;    copy [rNR11], $80
;    copy [rNR12], $F0
;    ld hl, Notes
;    ld a, [hli]
;    ld [rNR13], a
;    ld a, [hl]
;    or a, $80
;    ld [rNR14], a
;    copy [WRAM_FRAME_COUNTER], TIME_BETWEEN_NOTES
>>>>>>> 4c371c2ffab6c7cb77f331b6cf81cbd2738a9670
