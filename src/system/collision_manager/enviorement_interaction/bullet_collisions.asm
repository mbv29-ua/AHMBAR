INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "Bullet collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_enemy_collision
;;; Checks collision between bullets and enemies
;;; If collision detected, enemy loses 3 health and bullet disappears
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check_bullet_enemy_collision::
;    ; Iterar por todas las balas (entidades con tile TILE_BULLET)
;    ld e, 1  ; E = índice de entidad actual (empezar en 1)
;
;.loop_bullets:
;    ; Verificar si la entidad está activa
;    ld h, CMP_ATTR_H
;    ld l, e
;    ld a, [hl]  ; Leer ATT_ENTITY_FLAGS
;    bit E_BIT_FREE, a
;    jr z, .next_bullet  ; Bit = 0 significa FREE
;
;    ; Verificar si es una bala (tile TILE_BULLET)
;    ld h, CMP_SPRIT_H
;    ld l, e
;    inc l
;    inc l  ; Apuntar a SPR_TILE
;    ld a, [hl]
;    cp TILE_BULLET
;    jr nz, .next_bullet  ; No es bala
;
;    ; Es una bala activa, obtener su posición
;    ld h, CMP_SPRIT_H
;    ld l, e
;    ld b, [hl]  ; B = Bullet Y
;    inc l
;    ld c, [hl]  ; C = Bullet X
;
;    ; Buscar enemigos que colisionen con esta bala
;    push bc
;    push de  ; Guardar índice de bala
;    call .check_bullet_against_enemies
;    pop de
;    pop bc
;
;    ; Si A != 0, hubo colisión, eliminar bala
;    or a
;    jr z, .next_bullet
;
;    ; Eliminar bala (marcar como FREE)
;    ld h, CMP_ATTR_H
;    ld l, e
;    res E_BIT_FREE, [hl]
;
;    ; Mover sprite MUY fuera de pantalla
;    ld h, CMP_SPRIT_H
;    ld l, e
;    ld a, 255
;    ld [hl+], a  ; Y = 255
;    ld [hl], a   ; X = 255
;
;.next_bullet:
;    inc e
;    ld a, e
;    cp 32
;    jr nz, .loop_bullets
;    ret
;
;
;; Subrutina: verificar si bala (BC=pos) golpea algún enemigo
;; Input: B=bullet Y, C=bullet X, E=bullet index
;; Output: A=1 si hubo colisión, A=0 si no
;.check_bullet_against_enemies:
;    ld d, 1  ; D = índice de enemigo
;
;.loop_enemies:
;    ; Verificar si es el mismo índice que la bala
;    ld a, d
;    cp e
;    jr z, .next_enemy
;
;    ; Verificar si está activa
;    ld h, CMP_ATTR_H
;    ld l, d
;    ld a, [hl]
;    bit E_BIT_FREE, a
;    jr z, .next_enemy
;
;    ; Verificar si es enemigo
;    bit E_BIT_ENEMY, a
;    jr z, .next_enemy
;
;    ; Verificar si es damageable
;    inc l  ; INTERACTION_FLAGS
;    ld a, [hl]
;    bit E_BIT_DAMAGEABLE, a
;    jr z, .next_enemy
;
;    ; Obtener posición del enemigo
;    ld h, CMP_SPRIT_H
;    ld l, d
;    ld a, [hl]  ; A = Enemy Y
;    push af
;    inc l
;    ld a, [hl]  ; A = Enemy X
;    ld h, a     ; H = Enemy X
;    pop af
;    ld l, a     ; L = Enemy Y
;
;    ; Verificar colisión Y: abs(Bullet Y - Enemy Y) < 12
;    ld a, b
;    sub l
;    jr nc, .pos_y_bullet
;    cpl
;    inc a
;.pos_y_bullet:
;    cp 12
;    jr nc, .next_enemy
;
;    ; Verificar colisión X: abs(Bullet X - Enemy X) < 12
;    ld a, c
;    sub h
;    jr nc, .pos_x_bullet
;    cpl
;    inc a
;.pos_x_bullet:
;    cp 12
;    jr nc, .next_enemy
;
;    ; HAY COLISIÓN! Hacer daño al enemigo
;    push bc
;    push de
;    ld a, d  ; A = enemy index
;    call damage_enemy
;    pop de
;    pop bc
;
;    ; Retornar 1 (hubo colisión)
;    ld a, 1
;    ret
;
;.next_enemy:
;    inc d
;    ld a, d
;    cp 32
;    jr nz, .loop_enemies
;
;    ; No hubo colisión
;    xor a
;    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;; INPUT:
;;      E: Bullet index
;;
;;; WARNING: Destroys A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_bullet_enemy_collision::
    ;push de
    ;call get_entity_sprite ; B = Y coordinate, C = X coordinate
    ;pop de

    ld h, CMP_ATTR_H
    ld l, -4

    .next_enemy:
        ld a, l
        add 4
        ld l, a

        push hl
        call is_damageable_enemy
        pop hl
        jr z, .next_enemy

        push de
        push hl
        call are_entities_colliding
        pop hl
        pop de
        jr c, .collision 

        bit E_BIT_SENTINEL, [hl]
        ret nz                      ; Exit if there are no more entities
        jr .next_enemy
    
    .collision:
        call damage_enemy
        ld l, e                 ; We need the bullet index in L
        call man_entity_free
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_all_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_all_bullets_enemy_collision::
    ld hl, check_bullet_enemy_collision
    call man_entity_for_each_bullet
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_bullet_wall_collision::
	ld l, e
	call get_entity_sprite ; B = Y coordinate, C = X coordinate
    push hl
	call get_tile_at_position_y_x  ; A = tile ID
    pop hl
	call is_tile_solid
	ret nz
	call man_entity_free
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_all_bullet_wall_collision
;;; Destroys bullets that collide with solid tiles
;;;
;;; Destroys: A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_all_bullets_wall_collision::
	ld hl, check_bullet_wall_collision
	call man_entity_for_each_bullet
	ret

;    ld e, 1  ; E = índice de entidad
;
;.loop_bullets:
;    ; Verificar si está activa
;    ld h, CMP_ATTR_H
;    ld l, e
;    ld a, [hl]
;    bit E_BIT_FREE, a
;    jr z, .next_bullet
;
;    ; Verificar si es una bala
;    ld h, CMP_SPRIT_H
;    ld l, e
;    ld a, l
;    add SPR_TILE  ; A = índice + offset
;    ld l, a
;    ld a, [hl]
;    cp TILE_BULLET
;    jr nz, .next_bullet
;
;    ; Es una bala, obtener su posición
;    ld h, CMP_SPRIT_H
;    ld l, e
;    ld b, [hl]  ; B = Bullet Y (sprite)
;    inc l
;    ld c, [hl]  ; C = Bullet X (sprite)
;
;    ; Guardar índice de bala
;    push de
;
;    ; Convertir posición de sprite a posición de tile
;    ; Tile Y = (Sprite Y - 16) >> 3
;    ld a, b
;    cp 16
;    jr c, .invalid_position  ; Si Y < 16, fuera de rango válido
;    sub 16
;    srl a
;    srl a
;    srl a
;    ld b, a  ; B = tile Y
;
;    ; Verificar que tile Y esté en rango (0-17 para pantalla de 144 píxeles)
;    cp 20
;    jr nc, .invalid_position
;
;    ; Tile X = (Sprite X - 8) >> 3
;    ld a, c
;    cp 8
;    jr c, .invalid_position  ; Si X < 8, fuera de rango válido
;    sub 8
;    srl a
;    srl a
;    srl a
;    ld c, a  ; C = tile X
;
;    ; Verificar que tile X esté en rango (0-19 para pantalla de 160 píxeles)
;    cp 21
;    jr nc, .invalid_position
;
;    ; Obtener tile en esa posición
;    call get_tile_at_position  ; A = tile ID
;
;    ; Verificar si es sólido
;    call is_tile_solid
;    pop de
;    jr nz, .next_bullet  ; No es sólido
;
;    ; Es sólido, destruir bala
;    ld h, CMP_ATTR_H
;    ld l, e
;    res E_BIT_FREE, [hl]
;
;    ; Mover sprite MUY fuera de pantalla
;    ld h, CMP_SPRIT_H
;    ld l, e
;    ld a, 255
;    ld [hl+], a  ; Y = 255
;    ld [hl], a   ; X = 255
;    jr .next_bullet
;
;.invalid_position:
;    pop de
;    ; No destruir aquí, la otra función se encarga de fuera de bounds
;
;.next_bullet:
;    inc e
;    ld a, e
;    cp 32
;    jr nz, .loop_bullets
;    ret

