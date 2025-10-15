SECTION "Game Variables", WRAM0

Player::
    .wPlayerX:          DS 1
    .wPlayerY:          DS 1

; Array de balas (MAX_BULLETS = 3)
wBulletX::         DS 3
wBulletY::         DS 3
wBulletActive::    DS 3

wCounterValue::     DS 1
wCounterReload::    DS 1

wJoypadCurrent::    DS 1
wJoypadPrevious::   DS 1
wJoypadPressed::    DS 1

wCurrentLevel::     DS 1

cooldDown:          DS 1