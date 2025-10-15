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
    ; Esperar VBlank antes de modificar VRAM
    ; Apagar pantalla durante VBlank
    xor a
    ldh [rLCDC], a

    ; Incrementar nivel
    ld a, [wCurrentLevel]
    inc a
    cp 4                    ; Si pasa de nivel 3
    jr nz, .set_level
    ld a, 1                 ; Volver al nivel 1

.set_level:
    ld [wCurrentLevel], a

    ; Limpiar VRAM del mapa anterior
    ; call Clear_Map_Area

    ; Cargar nuevo nivel
    ; call Load_Current_Level

    ; Reposicionar jugador al inicio
    ld a, PLAYER_START_X
    ld [Player.wPlayerX], a
    ld a, PLAYER_START_Y
    ld [Player.wPlayerY], a

    ; Reiniciar sistema de balas
    ; call Init_Bullet_System

    ; Encender pantalla con sprites habilitados
    ld a, %10010011
    ldh [rLCDC], a
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
