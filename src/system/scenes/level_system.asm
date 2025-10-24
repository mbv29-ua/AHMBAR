INCLUDE "constants.inc"

SECTION "Level System", ROM0

; Inicializa el sistema de niveles
Init_Level_System::
    ld a, 1
    ld [wCurrentLevel], a
    ret

; Carga el mapa del nivel actual
Load_Current_Level::
    ld a, [wCurrentLevel]
    cp 1
    jr z, .load_level1
    cp 2
    jr z, .load_level2
    cp 3
    jr z, .load_level3
    ret

.load_level1:
    call Load_Level1_Map
    ret

.load_level2:
    call Load_Level2_Map
    ret

.load_level3:
    call Load_Level3_Map
    ret

; Avanza al siguiente nivel
Next_Level::
    ; Apagar pantalla para poder escribir en VRAM
    call screen_off

    ; Incrementar nivel
    ld a, [wCurrentLevel]
    inc a
    cp 4                    ; Si pasa de nivel 3
    jr nz, .set_level
    ld a, 1                 ; Volver al nivel 1

.set_level:
    ld [wCurrentLevel], a

    ; Recargar tiles (todos los niveles usan los mismos tiles)
    call Load_Level1_Tiles

    ; Cargar nuevo nivel
    call Load_Current_Level

    ; Reinicializar scroll según nivel
    call init_scroll

    ; Reposicionar jugador según nivel
    call init_player_position

    ; Reiniciar sistema de balas
    ;call init_bullet_system

    ; Encender pantalla
    call screen_on
    ret

; Inicializa la posición del jugador según el nivel actual
init_player_position::
    ld a, [wCurrentLevel]
    cp 1
    jr z, .level1_position
    cp 2
    jr z, .level2_position
    cp 3
    jr z, .level3_position
    ; Por defecto, nivel 1
.level1_position:
    ld a, LEVEL1_PLAYER_X
    ld [Player.wPlayerX], a
    ld a, LEVEL1_PLAYER_Y
    ld [Player.wPlayerY], a
    ret

.level2_position:
    ld a, LEVEL2_PLAYER_X
    ld [Player.wPlayerX], a
    ld a, LEVEL2_PLAYER_Y
    ld [Player.wPlayerY], a
    ret

.level3_position:
    ld a, LEVEL3_PLAYER_X
    ld [Player.wPlayerX], a
    ld a, LEVEL3_PLAYER_Y
    ld [Player.wPlayerY], a
    ret


; Verifica si el jugador tocó el cuadrado objetivo
Check_Level_Change::
    ; Verificar si X está en el rango del objetivo
    ld a, [Player.wPlayerX]
    cp GOAL_X_MIN
    ret c                   ; X < GOAL_X_MIN, no hay colisión
    cp GOAL_X_MAX
    ret nc                  ; X >= GOAL_X_MAX, no hay colisión

    ; Verificar si Y está en el rango del objetivo
    ld a, [Player.wPlayerY]
    cp GOAL_Y_MIN
    ret c                   ; Y < GOAL_Y_MIN, no hay colisión
    cp GOAL_Y_MAX
    ret nc                  ; Y >= GOAL_Y_MAX, no hay colisión

    ; ¡El jugador tocó el objetivo! Cambiar de nivel
    call Next_Level
    ret
