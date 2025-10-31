INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Spikes collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_deadly_collision
;;; Checks if player is touching a deadly tile
;;; (spikes, etc.) and handles player death
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_deadly_collision::
    ; Verificar cooldown primero
    ld a, [wSpikeCooldown]
    or a
    ret nz  ; Si cooldown > 0, no procesar daño

    call get_tile_at_player_position  ; A = tile ID
    call is_tile_deadly
    ret nz  ; Not deadly, return

    ; Is deadly (spike), lose 4 lives (2 hearts) and respawn
    call spike_damage
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; spike_damage
;;; Handles spike collision: loses 2 lives (1 hearts)
;;; and respawns player at previous safe position
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spike_damage::
    ; Activar cooldown de 60 frames (1 segundo) para evitar daño múltiple
    ld a, 60
    ld [wSpikeCooldown], a

    ; Perder 4 vidas (2 corazones completos)
    ld hl, wPlayerLives
    ld a, [hl]

    ; Si tiene menos de 4 vidas, restar lo que tenga (quedará en 0)
    cp 4
    jr c, .less_than_4_lives

    ; Tiene 4 o más vidas: restar 4
    sub 2
    ld [hl], a
    jr .after_damage

.less_than_4_lives:
    ; Tiene menos de 4 vidas: poner a 0
    xor a
    ld [hl], a

.after_damage:
    ; Marcar que HUD necesita actualizarse
    call hud_needs_update

    ; Respawn en posición anterior (restaurar posición guardada)
    call fade_to_black
    call restore_player_position
    call fade_to_original
    
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; update_spike_cooldown
;;; Decrements spike cooldown timer each frame
;;; Should be called once per frame in main loop
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_spike_cooldown::
    ld hl, wSpikeCooldown
    ld a, [hl]
    or a
    ret z  ; Si ya es 0, no hacer nada

    dec [hl]  ; Decrementar cooldown
    ret
