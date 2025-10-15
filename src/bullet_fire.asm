INCLUDE "utils/joypad.inc"
INCLUDE "constants.inc"

SECTION "Bullet System Variables", WRAM0[$c010]
cooldDown:   DS 1

SECTION "Bullet System", ROM0

Update_Bullet_System::
    ld a, [cooldDown]
    cp a, 0
    jr z, .no_cooldown
    dec a
    ld [cooldDown], a
    jr .render
    .no_cooldown:
    call check_button_input
    ld a, b
    jr nz, .skip
    .render:
    call Update_Bullet
    call Render_Bullets
    .skip:
    ret

load_bullet_sprites::
    ld hl, Tile_Bullet
    ld de, VRAM0_START + (TILE_BULLET * TILE_SIZE)
    ld bc, Tile_Bullet_End - Tile_Bullet
    call memcpy_65536
    ret

Init_Bullet_System::
    ld [wBulletActive], a
    ret

Init_Counter::
    ld a, COUNTER_START
    ld [wCounterValue], a
    ld [wCounterReload], a
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
    ld b, a
    ret z
    call Fire_Bullet
    ret

check_active_bullet::
    ld a, [wBulletActive]
    or a
    ret z
    call Fire_Bullet
    ret
    
Fire_Bullet::
    ld a, [cooldDown]
    cp a, 0
    ret z

    ld hl, wBulletX
    ld a, [Player.wPlayerX]
    add 8
    ld [hl+], a
    ld a, [Player.wPlayerY]
    ld [hl+], a
    ld a, BULLET_ACTIVE
    ld [hl], a
    ld hl, wCounterValue
    dec [hl]

    ld hl, cooldDown
    ld [hl], 60
    ret

Update_Bullet::
    ld a, [wBulletActive]
    or a
    ret z
    ld a, [wBulletX]
    add BULLET_SPEED
    ld [wBulletX], a
    cp SCREEN_RIGHT_EDGE
    ret c
    xor a
    ld [wBulletActive], a
    ret

Render_Bullets::
    call render_bullet
    ret

render_bullet::
    call wait_vblank
    ld a, [wBulletActive]
    or a
    jr z, .hide
    ld hl, OAM_BULLET
    ld a, [wBulletY]
    ld [hl+], a
    ld a, [wBulletX]
    ld [hl+], a
    ld a, TILE_BULLET
    ld [hl+], a
    xor a
    ld [hl], a
    ret
.hide:
    ld hl, OAM_BULLET
    xor a
    ld [hl], a
    ret

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