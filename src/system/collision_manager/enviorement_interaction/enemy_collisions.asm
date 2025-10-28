INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"


SECTION "Enemy collisions", ROM0

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