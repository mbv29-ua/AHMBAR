MACRO SPAWN_AMBAR_AT_TILE

    ; Calcular y cargar la posición Y en píxeles (Y * 8) en B
    ; ld a, \1       ; Cargar el tile Y en A
    ; rlca \ \ rlca \ \ rlca  ; Multiplicar por 8 (tres shifts a la izquierda)
    ; ld b, a        ; Mover el resultado a B

    ; Una forma más directa de cargar (Y * 8) si el ensamblador lo soporta (gasm sí)
    ld b, (\1 * 8)

    ; Calcular y cargar la posición X en píxeles (X * 8) en C
    ; ld a, \2       ; Cargar el tile X en A
    ; rlca \ \ rlca \ \ rlca  ; Multiplicar por 8
    ; ld c, a        ; Mover el resultado a C

    ; Una forma más directa de cargar (X * 8) si el ensamblador lo soporta
    ld c, (\2 * 8)

    ; Llamar a la función que realiza la creación completa de la entidad
    call ambar_spawn

ENDM