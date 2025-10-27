INCLUDE "constants.inc"
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_enemy_collision
;;; Checks collision between bullets and enemies
;;; If collision detected, enemy loses 3 health and bullet disappears
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_bullet_enemy_collision::
    ; Iterar por todas las balas (entidades con tile TILE_BULLET)
    ld e, 1  ; E = índice de entidad actual (empezar en 1)

.loop_bullets:
    ; Verificar si la entidad está activa
    ld h, CMP_ATTR_H
    ld l, e
    ld a, [hl]  ; Leer ATT_ENTITY_FLAGS
    bit E_BIT_FREE, a
    jr z, .next_bullet  ; Bit = 0 significa FREE

    ; Verificar si es una bala (tile TILE_BULLET)
    ld h, CMP_SPRIT_H
    ld l, e
    inc l
    inc l  ; Apuntar a SPR_TILE
    ld a, [hl]
    cp TILE_BULLET
    jr nz, .next_bullet  ; No es bala

    ; Es una bala activa, obtener su posición
    ld h, CMP_SPRIT_H
    ld l, e
    ld b, [hl]  ; B = Bullet Y
    inc l
    ld c, [hl]  ; C = Bullet X

    ; Buscar enemigos que colisionen con esta bala
    push bc
    push de  ; Guardar índice de bala
    call .check_bullet_against_enemies
    pop de
    pop bc

    ; Si A != 0, hubo colisión, eliminar bala
    or a
    jr z, .next_bullet

    ; Eliminar bala (marcar como FREE)
    ld h, CMP_ATTR_H
    ld l, e
    res E_BIT_FREE, [hl]

    ; Mover sprite MUY fuera de pantalla
    ld h, CMP_SPRIT_H
    ld l, e
    ld a, 255
    ld [hl+], a  ; Y = 255
    ld [hl], a   ; X = 255

.next_bullet:
    inc e
    ld a, e
    cp 32
    jr nz, .loop_bullets
    ret


; Subrutina: verificar si bala (BC=pos) golpea algún enemigo
; Input: B=bullet Y, C=bullet X, E=bullet index
; Output: A=1 si hubo colisión, A=0 si no
.check_bullet_against_enemies:
    ld d, 1  ; D = índice de enemigo

.loop_enemies:
    ; Verificar si es el mismo índice que la bala
    ld a, d
    cp e
    jr z, .next_enemy

    ; Verificar si está activa
    ld h, CMP_ATTR_H
    ld l, d
    ld a, [hl]
    bit E_BIT_FREE, a
    jr z, .next_enemy

    ; Verificar si es enemigo
    bit E_BIT_ENEMY, a
    jr z, .next_enemy

    ; Verificar si es damageable
    inc l  ; INTERACTION_FLAGS
    ld a, [hl]
    bit E_BIT_DAMAGEABLE, a
    jr z, .next_enemy

    ; Obtener posición del enemigo
    ld h, CMP_SPRIT_H
    ld l, d
    ld a, [hl]  ; A = Enemy Y
    push af
    inc l
    ld a, [hl]  ; A = Enemy X
    ld h, a     ; H = Enemy X
    pop af
    ld l, a     ; L = Enemy Y

    ; Verificar colisión Y: abs(Bullet Y - Enemy Y) < 12
    ld a, b
    sub l
    jr nc, .pos_y_bullet
    cpl
    inc a
.pos_y_bullet:
    cp 12
    jr nc, .next_enemy

    ; Verificar colisión X: abs(Bullet X - Enemy X) < 12
    ld a, c
    sub h
    jr nc, .pos_x_bullet
    cpl
    inc a
.pos_x_bullet:
    cp 12
    jr nc, .next_enemy

    ; HAY COLISIÓN! Hacer daño al enemigo
    push bc
    push de
    ld a, d  ; A = enemy index
    call damage_enemy
    pop de
    pop bc

    ; Retornar 1 (hubo colisión)
    ld a, 1
    ret

.next_enemy:
    inc d
    ld a, d
    cp 32
    jr nz, .loop_enemies

    ; No hubo colisión
    xor a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; damage_enemy
;;; Causes 3 damage to an enemy
;;; If health reaches 0, enemy is destroyed
;;;
;;; Input: A = enemy index
;;; Destroys: HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
damage_enemy::
    ; Guardar índice del enemigo
    ld b, a  ; B = enemy index

    ; Obtener vida actual del enemigo
    ld h, CMP_ATTR_H
    ld l, a  ; L = enemy index
    ld a, l
    add ENTITY_HEALTH  ; A = enemy index + offset ENTITY_HEALTH
    ld l, a  ; HL ahora apunta a ENTITY_HEALTH del enemigo
    ld a, [hl]  ; A = vida actual

    ; Si tiene menos de 3 de vida, poner a 0
    cp 3
    jr c, .kill_enemy

    ; Restar 3 de vida
    sub 3
    ld [hl], a
    ret

.kill_enemy:
    ; Poner vida a 0
    xor a
    ld [hl], a

    ; Marcar enemigo como FREE (destruirlo)
    ld h, CMP_ATTR_H
    ld l, b  ; L = enemy index (recuperado de B)
    res E_BIT_FREE, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_bullet_wall_collision::
    ld e, 1  ; E = índice de entidad

.loop_bullets:
    ; Verificar si está activa
    ld h, CMP_ATTR_H
    ld l, e
    ld a, [hl]
    bit E_BIT_FREE, a
    jr z, .next_bullet

    ; Verificar si es una bala
    ld h, CMP_SPRIT_H
    ld l, e
    ld a, l
    add SPR_TILE  ; A = índice + offset
    ld l, a
    ld a, [hl]
    cp TILE_BULLET
    jr nz, .next_bullet

    ; Es una bala, obtener su posición
    ld h, CMP_SPRIT_H
    ld l, e
    ld b, [hl]  ; B = Bullet Y (sprite)
    inc l
    ld c, [hl]  ; C = Bullet X (sprite)

    ; Guardar índice de bala
    push de

    ; Convertir posición de sprite a posición de tile
    ; Tile Y = (Sprite Y - 16) >> 3
    ld a, b
    cp 16
    jr c, .invalid_position  ; Si Y < 16, fuera de rango válido
    sub 16
    srl a
    srl a
    srl a
    ld b, a  ; B = tile Y

    ; Verificar que tile Y esté en rango (0-17 para pantalla de 144 píxeles)
    cp 20
    jr nc, .invalid_position

    ; Tile X = (Sprite X - 8) >> 3
    ld a, c
    cp 8
    jr c, .invalid_position  ; Si X < 8, fuera de rango válido
    sub 8
    srl a
    srl a
    srl a
    ld c, a  ; C = tile X

    ; Verificar que tile X esté en rango (0-19 para pantalla de 160 píxeles)
    cp 21
    jr nc, .invalid_position

    ; Obtener tile en esa posición
    call get_tile_at_position  ; A = tile ID

    ; Verificar si es sólido
    call is_tile_solid
    pop de
    jr nz, .next_bullet  ; No es sólido

    ; Es sólido, destruir bala
    ld h, CMP_ATTR_H
    ld l, e
    res E_BIT_FREE, [hl]

    ; Mover sprite MUY fuera de pantalla
    ld h, CMP_SPRIT_H
    ld l, e
    ld a, 255
    ld [hl+], a  ; Y = 255
    ld [hl], a   ; X = 255
    jr .next_bullet

.invalid_position:
    pop de
    ; No destruir aquí, la otra función se encarga de fuera de bounds

.next_bullet:
    inc e
    ld a, e
    cp 32
    jr nz, .loop_bullets
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get_tile_at_position
;;; Gets tile ID at given tile coordinates
;;;
;;; Input: B = tile Y (0-31), C = tile X (0-31)
;;; Output: A = tile ID
;;; Destroys: HL, DE
;;;
;;; Note: Tilemap is 32x32 tiles, stored row-major at $9800
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_tile_at_position:
    ; Limitar coordenadas a rango válido (0-31)
    ld a, b
    and $1F  ; Máscara para 0-31
    ld b, a

    ld a, c
    and $1F  ; Máscara para 0-31
    ld c, a

    ; Calcular offset en el tilemap: Y * 32 + X
    ld h, 0
    ld l, b  ; HL = Y
    add hl, hl  ; HL = Y * 2
    add hl, hl  ; HL = Y * 4
    add hl, hl  ; HL = Y * 8
    add hl, hl  ; HL = Y * 16
    add hl, hl  ; HL = Y * 32

    ld d, 0
    ld e, c
    add hl, de  ; HL = Y * 32 + X

    ; Añadir base del tilemap
    ld de, $9800  ; BG_MAP_START
    add hl, de

    ; Leer tile
    ld a, [hl]
    ret