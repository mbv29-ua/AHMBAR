
INCLUDE "hardware.inc"
INCLUDE "constants.inc"
SECTION "Entry Point", ROM0[$150]

main::
    di
    call Init_System
    call Init_LCD
    call Init_Palettes
    call Load_Level1_Tiles
    call Load_Level1_Map
    call Load_Character_Sprites
    call Init_Player
    call Init_Bullet_System
    call Init_Counter
    ei

.main_loop:
    call Wait_VBlank
    call Update_Input
    call Update_Player_Movement
    call Update_Bullet_System
    call Update_Counter
    call Render_Player
    call Render_Bullets
    call Render_Counter
    jp .main_loop

Init_System::
    xor a
    ldh [$FF40], a
    call Clear_VRAM
    call Clear_OAM
    ret

Init_LCD::
    ld a, $91
    ldh [$FF40], a
    xor a
    ldh [$FF42], a
    ldh [$FF43], a
    ret

Init_Palettes::
    ld a, %11100100
    ldh [$FF47], a
    ldh [$FF48], a
    ld a, %11010000
    ldh [$FF49], a
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

Wait_VBlank::
.wait:
    ldh a, [$FF44]
    cp 144
    jr c, .wait
    ret

INCLUDE "level1_assets.asm"
INCLUDE "characters_enemies.asm"
INCLUDE "character_movement.asm"
INCLUDE "bullet_fire.asm"