INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

SECTION "Bullet System", ROM0

Update_Bullet_System::
    ld a, [coolDown]
    cp a, 0
    jr z, .no_cooldown
    dec a
    ld [coolDown], a
    jr .render
    .no_cooldown:
    call check_button_input
    jr nz, .skip
    .render:
    call Update_Bullet
    ; call Render_Bullets
    .skip:
    ret

load_bullet_sprites::
    ld hl, Tile_Bullet
    ld de, VRAM0_START + (TILE_BULLET * TILE_SIZE)
    ld bc, Tile_Bullet_End - Tile_Bullet
    call memcpy_65536
    ret

Init_Bullet_System::
    ; Inicializar array de balas como inactivas
    ld hl, wBulletActive
    ld b, MAX_BULLETS
    xor a  ; a = BULLET_INACTIVE (0)
.init_loop:
    ld [hl+], a
    dec b
    jr nz, .init_loop
    ret

Init_Counter::
    ld a, COUNTER_START
    ld [wCounterValue], a
    ; ld [wCounterReload], a
    ret


check_button_input::
    ld a, [PRESSED_BUTTONS]
    bit BUTTON_B, a
    ret z
    call check_counter
    ret

check_counter::
    ld a, [wCounterValue]
    cp a, 0
    ; ld b, a
    ret z
    call check_cooldown
    ret

check_cooldown::
    ; Verificar cooldown: si != 0, retornar (estamos en cooldown)
    ld a, [coolDown]
    cp a, 0
    ret nz
    call Fire_Bullet
    ret

Fire_Bullet::
    ; Buscar una bala libre en el array
    ld hl, wBulletActive
    ld b, MAX_BULLETS
    ld d, 0  ; d = índice de la bala
.find_free:
    ld a, [hl+]
    cp BULLET_INACTIVE
    jr z, .found_free
    inc d
    dec b
    jr nz, .find_free
    ret  ; No hay balas libres

.found_free:
    ; d contiene el índice de la bala libre
    ; Configurar posición X
    ; ld e, d
    ; add hl, de
    ld a, [Player.wPlayerX]
    add 8
    ld [Bullet.wBulletX], a

    ; Configurar posición Y
    ; ld e, d
    ; add hl, de
    ld a, [Player.wPlayerY]
    ld [Bullet.wBulletY], a

    ld a, TILE_BULLET
    ld [Bullet.tile], a

    xor a
    ld [Bullet.wDrawAttributes], a

    ; Configurar dirección de la bala (copiar del jugador)
    ; ld e, d
    ; add hl, de
    ld a, [wPlayerDirection]
    ld [Bullet.wBulletDirection], a

    ; Activar la bala
    ;  e, d
    ; d hl, de
    ld a, BULLET_ACTIVE ;; TODO : PASAR DE 1 BYTE A BIT
    ld [wBulletActive], a

    ; Decrementar contador
    ld hl, wCounterValue
    dec [hl]

    ; Activar cooldown de 60 frames (~1 segundo)
    ld a, 60
    ld [coolDown], a
    ret

Update_Bullet::
    ld b, MAX_BULLETS
    ld c, 0  ; c = índice de la bala
; pdate_loop:
    ; push bc

    ; Verificar si la bala está activa
    ld hl, wBulletActive
    bit 0, [hl]
    ; add hl, bc
    ; ld a, [hl]
    ; cp BULLET_INACTIVE
    jr z, .next_bullet

    ; Obtener dirección de la bala
    ld hl, Bullet.wBulletDirection
    bit 0, [hl]
    ; ld b, 0
    ; add hl, bc
    ; ld a, [hl]
    jr nz, .move_right

.move_left:
    ; Mover a la izquierda (decrementar X)
    ld hl, Bullet.wBulletX ; --> b c006
    ; ld b, 0
    ; add hl, bc
    ld a, [hl]
    sub BULLET_SPEED
    ld [hl], a
    ; Verificar si salió por la izquierda (X < 0 en unsigned = X >= 240)
    cp 240
    jr nc, .deactivate
    jr .next_bullet

.move_right:
    ; Mover a la derecha (incrementar X)
    ld hl, Bullet.wBulletX
    ; ld b, 0
    ; add hl, bc
    ld a, [hl]
    add BULLET_SPEED
    ld [hl], a
    ; Verificar si salió por la derecha
    cp SCREEN_RIGHT_EDGE
    jr c, .next_bullet

.deactivate:
    ; Desactivar la bala
    ld hl, wBulletActive
    ; ld b, 0
    ; add hl, bc
    xor a
    ld [hl], a

.next_bullet:
    ; pop bc
    ;  nz, .update_loop
    ret

;render_Bullets::
;   ld b, MAX_BULLETS
;   ld c, 0  ; c = índice de la bala
;render_loop:
;   push bc
;
;   ; Verificar si la bala está activa
;   ld hl, wBulletActive
;   ld b, 0
;   add hl, bc
;   ld a, [hl]
;   cp BULLET_INACTIVE
;   jr z, .hide_bullet
;
;   ; Calcular offset OAM: OAM_BULLET + (índice * 4)
;   ld a, c
;   sla a  ; a = índice * 2
;   sla a  ; a = índice * 4
;   ld hl, OAM_BULLET
;   ld d, 0
;   ld e, a
;   add hl, de
;
;   ; Renderizar Y
;   push hl
;   ld hl, Bullet.wBulletY
;   ld b, 0
;   add hl, bc
;   ld a, [hl]
;   pop hl
;   ld [hl+], a
;
;   ; Renderizar X
;   push hl
;   ld hl, Bullet.wBulletX
;   ld b, 0
;   add hl, bc
;   ld a, [hl]
;   pop hl
;   ld [hl+], a
;
;   ; Tile
;   ld a, TILE_BULLET
;   ld [hl+], a
;
;   ; Atributos
;   xor a
;   ld [hl], a
;   jr .next_render
;
;hide_bullet:
;   ; Calcular offset OAM y ocultar
;   ld a, c
;   sla a
;   sla a
;   ld hl, OAM_BULLET
;   ld d, 0
;   ld e, a
;   add hl, de
;   xor a
;   ld [hl], a
;
;next_render:
;   pop bc
;   inc c
;   dec b
;   jr nz, .render_loop
;   ret

Render_Counter::
    ld a, [wCounterValue]
    add TILE_DIGIT_0
    ld b, a
    
    ld hl, OAM_COUNTER
    ld a, COUNTER_Y_POS
    ld [hl+], a
    ld a, COUNTER_X_POS
    ld [hl+], a
    ld a, b
    ld [hl+], a
    ld a, %00010000
    ld [hl], a
    ret