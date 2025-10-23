SECTION "Game Variables", WRAM0[$C000] ; --> provisional, coment entities_components

Player::
    .wPlayerY:          DS 1
    .wPlayerX:          DS 1
    .tile:              DS 1
    .wDrawAttributes:   DS 1




SECTION "Player Variables", WRAM0[$CE00]
wPlayerDirection::  DS 1  ; 0 = izquierda, 1 = derecha
wBulletActive::     DS 1
coolDown::          DS 1

; HUD Variables
wPlayerLives::      DS 1  ; Vidas del jugador (0-4)
wPlayerBullets::    DS 1  ; Balas disponibles (0-5)


wCounterValue::     DS 1
wCounterReload::    DS 1

wCurrentLevel::     DS 1


Bullet::
    .wBulletY:         DS 1
    .wBulletX:         DS 1
    .tile:             DS 1
    .wDrawAttributes:  DS 1
    .wBulletDirection: DS 1  ; 0 = izquierda, 1 = derecha