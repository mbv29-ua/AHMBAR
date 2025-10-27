SECTION "Player Variables", WRAM0

wPlayerDirection::  DS 1  ; 0 = izquierda, 1 = derecha
coolDown::          DS 1

; HUD Variables
wPlayerLives::      DS 1  ; Vidas del jugador (0-4)
wPlayerBullets::    DS 1  ; Balas disponibles (0-5)
wHUDNeedsUpdate::   DS 1  ; Flag: 1 = HUD necesita actualizarse en próximo VBlank

; Spike respawn variables
wSpawnPlayerY::     DS 1  ; Posición Y de spawn del nivel (inicio)
wSpawnPlayerX::     DS 1  ; Posición X de spawn del nivel (inicio)
wSpikeCooldown::    DS 1  ; Cooldown para evitar múltiples daños de picas (frames)


wCounterValue::     DS 1
wCounterReload::    DS 1

;wCurrentLevel::     DS 1

; Menu Variables
wMenuOption::       DS 1  ; Opción seleccionada del menú (0 = Start Game, 1 = Controls)