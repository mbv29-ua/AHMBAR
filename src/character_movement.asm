INCLUDE "constants.inc"

SECTION "Character Movement", ROM0

Update_Input::
    ld a, [wJoypadCurrent]
    ld [wJoypadPrevious], a
    
    ld a, $20
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0F
    swap a
    ld b, a
    
    ld a, $10
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0F
    or b
    ld [wJoypadCurrent], a
    
    ld b, a
    ld a, [wJoypadPrevious]
    cpl
    and b
    ld [wJoypadPressed], a
    
    ld a, $30
    ldh [rP1], a
    ret

Update_Player_Movement::
    call Apply_Gravity
    call Process_Horizontal_Movement
    call Process_Jump
    call Clamp_Player_Position
    ret

Apply_Gravity::
    ld a, [wPlayerY]
    cp 100
    jr c, .not_grounded
    
    ld a, 100
    ld [wPlayerY], a
    xor a
    ld [wPlayerVelY], a
    ld a, 1
    ld [wPlayerGrounded], a
    ret
    
.not_grounded:
    xor a
    ld [wPlayerGrounded], a
    
    ld a, [wPlayerY]
    ld b, a
    ld a, [wPlayerVelY]
    add b
    ld [wPlayerY], a
    
    ld a, [wPlayerVelY]
    add 2
    cp 127
    jr c, .gravity_ok
    ld a, 127
.gravity_ok:
    ld [wPlayerVelY], a
    ret

Process_Horizontal_Movement::
    ld a, [wJoypadCurrent]
    bit DPAD_RIGHT, a
    jr z, .check_left
    
    ld a, [wPlayerX]
    add PLAYER_SPEED
    ld [wPlayerX], a
    ret
    
.check_left:
    ld a, [wJoypadCurrent]
    bit DPAD_LEFT, a
    ret z
    
    ld a, [wPlayerX]
    sub PLAYER_SPEED
    ld [wPlayerX], a
    ret

Process_Jump::
    ld a, [wJoypadPressed]
    bit BUTTON_A, a
    ret z
    
    ld a, [wPlayerGrounded]
    or a
    ret z
    
    ld a, -PLAYER_JUMP_POWER
    ld [wPlayerVelY], a
    xor a
    ld [wPlayerGrounded], a
    ret

Clamp_Player_Position::
    ld a, [wPlayerX]
    cp 8
    jr nc, .check_right
    ld a, 8
    ld [wPlayerX], a
    ret
    
.check_right:
    cp 152
    jr c, .x_ok
    ld a, 152
    ld [wPlayerX], a
    
.x_ok:
    ld a, [wPlayerY]
    cp 16
    jr nc, .y_ok
    ld a, 16
    ld [wPlayerY], a
    
.y_ok:
    ret