INCLUDE "constants.inc"

SECTION "Bullet System", ROM0

Init_Bullet_System::
    xor a
    ld [wBullet1Active], a
    ld [wBullet2Active], a
    ld [wBullet3Active], a
    ret

Init_Counter::
    ld a, COUNTER_START
    ld [wCounterValue], a
    xor a
    ld [wCounterReload], a
    ret

Update_Bullet_System::
    call Check_Fire_Input
    call Update_Bullet_1
    call Update_Bullet_2
    call Update_Bullet_3
    ret

Check_Fire_Input::
    ld a, [wJoypadPressed]
    bit BUTTON_B, a
    ret z
    
    ld a, [wCounterValue]
    or a
    ret z
    
    dec a
    ld [wCounterValue], a
    call Fire_Bullet
    ret

Fire_Bullet::
    ld a, [wBullet1Active]
    or a
    jr z, .fire_bullet_1
    ld a, [wBullet2Active]
    or a
    jr z, .fire_bullet_2
    ld a, [wBullet3Active]
    or a
    jr z, .fire_bullet_3
    ret
    
.fire_bullet_1:
    ld hl, wBullet1X
    jr .initialize
.fire_bullet_2:
    ld hl, wBullet2X
    jr .initialize
.fire_bullet_3:
    ld hl, wBullet3X
    
.initialize:
    ld a, [wPlayerX]
    add 8
    ld [hl+], a
    ld a, [wPlayerY]
    ld [hl+], a
    ld a, BULLET_ACTIVE
    ld [hl], a
    ret

Update_Bullet_1::
    ld a, [wBullet1Active]
    or a
    ret z
    ld a, [wBullet1X]
    add BULLET_SPEED
    ld [wBullet1X], a
    cp SCREEN_RIGHT_EDGE
    ret c
    xor a
    ld [wBullet1Active], a
    ret

Update_Bullet_2::
    ld a, [wBullet2Active]
    or a
    ret z
    ld a, [wBullet2X]
    add BULLET_SPEED
    ld [wBullet2X], a
    cp SCREEN_RIGHT_EDGE
    ret c
    xor a
    ld [wBullet2Active], a
    ret

Update_Bullet_3::
    ld a, [wBullet3Active]
    or a
    ret z
    ld a, [wBullet3X]
    add BULLET_SPEED
    ld [wBullet3X], a
    cp SCREEN_RIGHT_EDGE
    ret c
    xor a
    ld [wBullet3Active], a
    ret

Render_Bullets::
    call Render_Bullet_1
    call Render_Bullet_2
    call Render_Bullet_3
    ret

Render_Bullet_1::
    ld a, [wBullet1Active]
    or a
    jr z, .hide
    ld hl, OAM_BULLET_1
    ld a, [wBullet1Y]
    ld [hl+], a
    ld a, [wBullet1X]
    ld [hl+], a
    ld a, TILE_BULLET
    ld [hl+], a
    xor a
    ld [hl], a
    ret
.hide:
    ld hl, OAM_BULLET_1
    xor a
    ld [hl], a
    ret

Render_Bullet_2::
    ld a, [wBullet2Active]
    or a
    jr z, .hide
    ld hl, OAM_BULLET_2
    ld a, [wBullet2Y]
    ld [hl+], a
    ld a, [wBullet2X]
    ld [hl+], a
    ld a, TILE_BULLET
    ld [hl+], a
    xor a
    ld [hl], a
    ret
.hide:
    ld hl, OAM_BULLET_2
    xor a
    ld [hl], a
    ret

Render_Bullet_3::
    ld a, [wBullet3Active]
    or a
    jr z, .hide
    ld hl, OAM_BULLET_3
    ld a, [wBullet3Y]
    ld [hl+], a
    ld a, [wBullet3X]
    ld [hl+], a
    ld a, TILE_BULLET
    ld [hl+], a
    xor a
    ld [hl], a
    ret
.hide:
    ld hl, OAM_BULLET_3
    xor a
    ld [hl], a
    ret

Update_Counter::
    ; Ya no se resetea automáticamente el contador
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