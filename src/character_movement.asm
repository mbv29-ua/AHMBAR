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
    call Process_Horizontal_Movement
    call Process_Vertical_Movement
    call Clamp_Player_Position
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

Process_Vertical_Movement::
    ld a, [wJoypadCurrent]
    bit DPAD_UP, a
    jr z, .check_down

    ld a, [wPlayerY]
    sub PLAYER_SPEED
    ld [wPlayerY], a
    ret

.check_down:
    ld a, [wJoypadCurrent]
    bit DPAD_DOWN, a
    ret z

    ld a, [wPlayerY]
    add PLAYER_SPEED
    ld [wPlayerY], a
    ret

Clamp_Player_Position::
    ld a, [wPlayerX]
    cp 8
    jr nc, .check_right
    ld a, 8
    ld [wPlayerX], a

.check_right:
    ld a, [wPlayerX]
    cp 248
    jr c, .check_y_min
    ld a, 248
    ld [wPlayerX], a

.check_y_min:
    ld a, [wPlayerY]
    cp 16
    jr nc, .check_y_max
    ld a, 16
    ld [wPlayerY], a

.check_y_max:
    ld a, [wPlayerY]
    cp 136
    jr c, .ok
    ld a, 136
    ld [wPlayerY], a

.ok:
    ret