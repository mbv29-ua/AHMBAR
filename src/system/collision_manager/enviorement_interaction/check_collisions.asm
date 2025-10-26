INCLUDE "entities/entities.inc"

SECTION "Collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_door_collision
;;; Checks if player is touching a door tile (tiles $C0-$C3)
;;; and triggers level transition if true
;;; Door tiles have bits 4,5,6 = %010 (DOOR_TILE group)
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_door_collision::
    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_door
    ret nz  ; Not a door, return

    ; Is a door, change level
    call next_scene
    ret


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
;;; Handles spike collision: loses 4 lives (2 hearts)
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
    sub 4
    ld [hl], a
    jr .after_damage

.less_than_4_lives:
    ; Tiene menos de 4 vidas: poner a 0
    xor a
    ld [hl], a

.after_damage:
    ; Marcar que HUD necesita actualizarse
    ld a, 1
    ld [wHUDNeedsUpdate], a

    ; Respawn en posición anterior (restaurar posición guardada)
    call restore_player_position

    ; Verificar si llegó a 0 vidas para game over
    ld a, [wPlayerLives]
    cp 0
    ret nz

    ; Si llegó a 0 vidas, game over
    call game_over
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_collectible_collision
;;; Checks if player is touching a collectible tile
;;; (hearts, etc.) and collects it
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_collectible_collision::
    call get_tile_at_player_position  ; A = tile ID, HL = tilemap address
    call is_tile_collectible
    ret nz  ; Not collectible, return

    ; Is collectible
    ; TODO: Add score/health/etc.
    ; Remove tile from map (replace with empty)
    ld a, $80  ; Empty tile
    ld [hl], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; restore_player_position
;;; Restores player to spawn position (scene starting position)
;;; Used for spike respawn
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
restore_player_position::
    call wait_vblank
    call set_player_initial_position
    call set_initial_scroll
    ret

;    ; Restaurar Y desde posición de spawn del scene
;    ld hl, SPR_BASE + (0 * SPR_SIZE) + SPR_Y
;    ld a, [wSpawnPlayerY]
;    ld [hl], a
;
;    ; Restaurar X desde posición de spawn del scene
;    inc hl  ; HL ahora apunta a SPR_X
;    ld a, [wSpawnPlayerX]
;    ld [hl], a
;
;    ; Resetear velocidades a 0 para evitar que siga cayendo
;    ld hl, PHYS_BASE + (0 * PHYS_SIZE) + PHY_VY
;    xor a
;    ld [hl+], a  ; VY = 0
;    ld [hl+], a  ; VY_COMA = 0
;    ld [hl+], a  ; VX = 0
;    ld [hl], a   ; VX_COMA = 0
;    ret


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_enemy_collision
;;; Checks collision between player (entity 0) and all enemies
;;; If collision detected, player loses 1 life
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_enemy_collision::
    ; Verificar cooldown primero (usar mismo cooldown que picas)
    ld a, [wSpikeCooldown]
    or a
    ret nz  ; Si cooldown > 0, no procesar daño

    ; Obtener posición del jugador (entidad 0)
    ld hl, SPR_BASE + (0 * SPR_SIZE) + SPR_Y
    ld b, [hl]  ; B = Player Y
    inc hl
    ld c, [hl]  ; C = Player X

    ; Iterar por todas las entidades (1 a 31, saltando la 0 que es el jugador)
    ld e, 1  ; E = índice de entidad actual

.loop_entities:
    ; Verificar si la entidad está activa (E_BIT_FREE = 1 significa USADO)
    ld h, CMP_ATTR_H
    ld l, e
    ld a, [hl]  ; Leer ATT_ENTITY_FLAGS
    bit E_BIT_FREE, a
    jr z, .next_entity  ; Bit = 0 significa FREE (no usada), siguiente

    ; Verificar si es un enemigo
    bit E_BIT_ENEMY, a
    jr z, .next_entity  ; No es enemigo, siguiente

    ; Es un enemigo activo, verificar colisión
    ; Obtener posición del enemigo
    ld h, CMP_SPRIT_H
    ld l, e
    ld a, [hl]  ; A = Enemy Y
    push af     ; Guardar Enemy Y
    inc l
    ld a, [hl]  ; A = Enemy X
    ld h, a     ; H = Enemy X
    pop af
    ld l, a     ; L = Enemy Y

    ; Verificar colisión Y: abs(Player Y - Enemy Y) < 16
    ld a, b  ; A = Player Y
    sub l    ; A = Player Y - Enemy Y
    jr nc, .positive_y
    ; Negativo, hacer valor absoluto (complemento a 2)
    cpl
    inc a
.positive_y:
    cp 16   ; Bounding box de 16 píxeles
    jr nc, .next_entity  ; Diferencia >= 16, no hay colisión

    ; Verificar colisión X: abs(Player X - Enemy X) < 16
    ld a, c  ; A = Player X
    sub h    ; A = Player X - Enemy X
    jr nc, .positive_x
    ; Negativo, hacer valor absoluto (complemento a 2)
    cpl
    inc a
.positive_x:
    cp 16   ; Bounding box de 16 píxeles
    jr nc, .next_entity  ; Diferencia >= 16, no hay colisión

    ; HAY COLISIÓN! Perder 1 vida
    call enemy_damage
    ret

.next_entity:
    inc e
    ld a, e
    cp 32  ; NUM_ENTITIES
    jr nz, .loop_entities

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enemy_damage
;;; Called when player collides with enemy
;;; Loses 1 life and activates cooldown
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enemy_damage::
    ; Activar cooldown de 60 frames (1 segundo)
    ld a, 60
    ld [wSpikeCooldown], a

    ; Perder 1 vida
    ld hl, wPlayerLives
    ld a, [hl]
    or a
    ret z  ; Si ya está en 0, no hacer nada

    dec [hl]

    ; Marcar que HUD necesita actualizarse
    ld a, 1
    ld [wHUDNeedsUpdate], a

    ; Verificar si llegó a 0 vidas para game over
    ld a, [wPlayerLives]
    or a
    ret nz

    ; Si llegó a 0 vidas, game over
    call game_over
    ret