INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

DEF COOLDOWN_STARTING_VALUE EQU 60

SECTION "Bullet System", ROM0


;init_bullet_system::
;    ; Inicializar array de balas como inactivas
;    ld hl, wBulletActive
;    ld [hl], MAX_BULLETS
;    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine manages the bullet system: 
;; creates bullets when possible and updates
;; cooldown if exists.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC??, DE?? and HL??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_bullet_system::
    call is_magazine_empty
    ret z
    call is_there_cooldown
    jp nz, .cooldown
    call check_button_input_and_shoot
    ret

    .cooldown
    ld hl, coolDown
    dec [hl]
    ret


; init_counter::
;    ; Ya no se usa, wPlayerBullets se inicializa en init_hud
;    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if there are available bullets
;; by looking at memory position [wPlayerBullets]
;;
;; INPUT
;;      -
;; OUTPUT:
;;      Z=1 if empty, Z=0 if there is at least one bullet
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_magazine_empty::
    ld a, [wPlayerBullets]
    or a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine starts the cooldown after shooting
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_cool_down::
    ; Activar cooldown de 60 frames (~1 segundo)
    ld a, COOLDOWN_STARTING_VALUE
    ld [coolDown], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if there is cooldown
;;
;; INPUT
;;      -
;; OUTPUT:
;;      Z=1 if cooldown, Z=0 otherwise.
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_there_cooldown::
    ld a, [coolDown]
    or a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if the shoot button is
;; pressed, and fires a bullet if this is the case.
;; Alse, sets cooldown to avoid multiple shots. 
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys ???
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_button_input_and_shoot::
    ld a, [PRESSED_BUTTONS]
    bit BUTTON_B, a
    ret z

    ; Verificar si hay balas disponibles
    call use_bullet      ; Decrementa balas, retorna zero si no hay
    ret z                ; Si no hay balas, retornar sin disparar

    call init_bullet
    call init_cool_down
    ret





;;;;;;;;;;;;;;;;;;;;;

;Init_Bullet_System::
;    ; Inicializar array de balas como inactivas
;    ld hl, wBulletActive
;    ld b, MAX_BULLETS
;    xor a  ; a = BULLET_INACTIVE (0)
;.init_loop:
;    ld [hl+], a
;    dec b
;    jr nz, .init_loop
;    ret




;check_counter::
;    ld a, [wCounterValue]
;    cp a, 0
;    ; ld b, a
;    ret z
;    call check_cooldown
;    ret
;
;check_cooldown::
;    ; Verificar cooldown: si != 0, retornar (estamos en cooldown)
;    ld a, [coolDown]
;    cp a, 0
;    ret nz
;    call Fire_Bullet
;    ret

;Fire_Bullet::
;    ; Buscar una bala libre en el array
;    ld hl, wBulletActive
;    ld b, MAX_BULLETS
;    ld d, 0  ; d = índice de la bala
;.find_free:
;    ld a, [hl+]
;    cp BULLET_INACTIVE
;    jr z, .found_free
;    inc d
;    dec b
;    jr nz, .find_free
;    ret  ; No hay balas libres
;
;.found_free:
;    ; d contiene el índice de la bala libre
;    ; Configurar posición X
;    ; ld e, d
;    ; add hl, de
;
;    ;; When wPlayerDirection is right (1) 
;    ;; in other case (0) left sub 8
;
;    ;; Prove bit wPlayerDirection bit (lef tor right)    
;    ;; TODO: logica de disparo que empiece en la posción correspondiente izda o der
;    call init_bullet
    ;
;    ; Activar la bala
;    ;  e, d
;    ; d hl, de
;    ld a, BULLET_ACTIVE ;; TODO : PASAR DE 1 BYTE A BIT
;    ld [wBulletActive], a
;
;    ; Decrementar contador
;    ld hl, wCounterValue
;    dec [hl]
;
;    ret



;Update_Bullet::
;    ;; call
;    ;; call
;    ;; call
;    ;ret
;
;
;    ld b, MAX_BULLETS
;    ld c, 0  ; c = índice de la bala
;; pdate_loop:
;    ; push bc
;
;    ; Verificar si la bala está activa
;    ld hl, wBulletActive
;    bit 0, [hl]
;    ; add hl, bc
;    ; ld a, [hl]
;    ; cp BULLET_INACTIVE
;    jr z, .next_bullet
;
    ;
;.deactivate:
;    ; Desactivar la bala
;    ld hl, wBulletActive
;    ; ld b, 0
;    ; add hl, bc
;    xor a
;    ld [hl], a
;
;.next_bullet:
;    ; pop bc
;    ;  nz, .update_loop
;    ret

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

; Render_Counter eliminado - ya no se usa
; El HUD de balas se renderiza con render_bullets() en hud_system.asm