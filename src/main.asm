INCLUDE "constants.inc"

SECTION "Entry Point", ROM0[$150]

main::
    di
    
    xor a
    ldh [rLCDC], a
    
    call Clear_VRAM
    call Clear_OAM
    call Load_Level1_Tiles
    call Load_Level1_Map
    call Load_Character_Sprites
    call Init_Palettes
    
    ld a, $91
    ldh [rLCDC], a
    
    call Init_Player
    call Init_Bullet_System
    call Init_Counter
    
    ei

.main_loop:
    halt
    nop
    call Update_Input
    call Update_Player_Movement
    call Update_Bullet_System
    call Update_Counter
    call Render_Player
    call Render_Bullets
    call Render_Counter
    jp .main_loop

Init_Palettes::
    ld a, %11100100
    ldh [rBGP], a
    ldh [rOBP0], a
    ld a, %11100100
    ldh [rOBP1], a
    ret

Clear_VRAM::
    ld hl, $8000
    ld bc, $2000
    xor a
.loop:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret

Clear_OAM::
    ld hl, $FE00
    ld b, 160
    xor a
.loop:
    ld [hl+], a
    dec b
    jr nz, .loop
    ret