; --- INCLUDES ---
include "hardware.inc"

; ==============================================================================
; SECTION "Characters and Enemies", ROM0
; ==============================================================================

; --- Tiles de Dígitos y Proyectil ---
; El tile del 'cowboy' se asume que ya está en la posición $0000 de VRAM,
; o se cargará más tarde. Lo reubicaremos.
; El 'cowboy' ocupa 8 tiles (16 bytes * 8 = 128 bytes)
; Lo colocaremos a partir del Tile ID 0x10.
; Los dígitos de 0 a 5 los colocaremos a partir del Tile ID 0x0A. (6 tiles, 96 bytes)
; El proyectil lo colocaremos en el Tile ID 0x09. (1 tile, 16 bytes)

; Tiles de 0 a 5: 6 tiles (96 bytes). Asume que tienes estos datos.
; Por simplicidad, aquí solo definimos el Tile ID.
; DEBES definir los bytes reales para cada tile (16 bytes por tile).

SECTION "Tile Data", ROM0
; --- El Tile Data REAL (ejemplo, DEBES CREAR LOS DATOS REALES) ---
Digito0_Tile: DB $3C,$42,$46,$4A,$52,$62,$42,$3C,$00,$00,$00,$00,$00,$00,$00,$00
Digito1_Tile: DB $08,$18,$28,$08,$08,$08,$08,$3E,$00,$00,$00,$00,$00,$00,$00,$00
Digito2_Tile: DB $3C,$42,$02,$04,$08,$10,$20,$7E,$00,$00,$00,$00,$00,$00,$00,$00
Digito3_Tile: DB $3C,$42,$02,$1C,$02,$02,$42,$3C,$00,$00,$00,$00,$00,$00,$00,$00
Digito4_Tile: DB $04,$0C,$14,$24,$44,$7E,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00
Digito5_Tile: DB $7E,$40,$40,$7C,$02,$02,$42,$3C,$00,$00,$00,$00,$00,$00,$00,$00

; El proyectil (Tile ID 0x09)
Proyectil_Tile:
DB $00,$00,$C3,$C3,$A5,$A5,$99,$99
DB $99,$99,$A5,$A5,$C3,$C3,$00,$00 ; Ejemplo de una 'bala'

; Cowboy_Tiles: ; 8 tiles, 16 bytes each (dummy example, replace with real graphics)
Cowboy_Tile0: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile1: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile2: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile3: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile4: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile5: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile6: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00
Cowboy_Tile7: DB $00,$3C,$42,$A5,$81,$A5,$99,$42,$3C,$00,$00,$00,$00,$00,$00,$00

; Nota: El tile del cowboy se movió para dejar espacio a los nuevos tiles.
; Cowboy ID: 0x10 (ya está definido en el código original, usa los 8 tiles a partir de 0x10)

; ==============================================================================
SECTION "Posiciones", WRAM0
; --- Variables del Jugador ---
posX:  ds 1  ; Coordenada X del Cowboy
posY:  ds 1  ; Coordenada Y del Cowboy

; --- Variables del Contador ---
ContadorValue:  ds 1  ; Valor del contador (5 a 0)
ContadorSprite:  ds 1  ; Índice del sprite usado para el contador (Ej: Sprite 1)

; --- Variables del Proyectil ---
BalaX:  ds 1  ; Coordenada X del proyectil
BalaY:  ds 1  ; Coordenada Y del proyectil
BalaActiva: ds 1  ; Estado: 0 = inactiva, 1 = activa
BalaSprite: ds 1  ; Índice del sprite usado para el proyectil (Ej: Sprite 2)

; ==============================================================================
SECTION "Entry point", ROM0[$150]
; ==============================================================================
main::
 ; --- Inicialización ---
 ld a, 16  ; Posición inicial Y
 ld [posY], a
 ld a, 8  ; Posición inicial X
 ld [posX], a

 ld a, 5  ; Contador empieza en 5
 ld [ContadorValue], a

 ld a, 0  ; Bala inactiva
 ld [BalaActiva], a

 ld a, 1  ; Sprite ID 1 para el contador
 ld [ContadorSprite], a
 ld a, 2  ; Sprite ID 2 para la bala
 ld [BalaSprite], a

 ; Inicialización de LCDC y Paletas (Simplificado, usando tu código original)
 call LCDC_init
 call CargarTiles ; **DEBES implementar esta función**

; Salta al bucle principal
   jp .loop

; --- Carga de Tiles (DEBES IMPLEMENTAR ESTO) ---
; Esta función debe copiar el tile data del ROM (Cowboy, Digitos, Bala) a VRAM ($8000-$97FF).
CargarTiles:
   ; Digitos 0-5 (Tile IDs 0x0A-0x0F)
   ld hl, Digito0_Tile
   ld de, $8000 + (10 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Digito1_Tile
   ld de, $8000 + (11 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Digito2_Tile
   ld de, $8000 + (12 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Digito3_Tile
   ld de, $8000 + (13 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Digito4_Tile
   ld de, $8000 + (14 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Digito5_Tile
   ld de, $8000 + (15 * 16)
   ld bc, 16
   call CopiarBloque

   ; Proyectil (Tile ID 0x09)
   ld hl, Proyectil_Tile
   ld de, $8000 + (9 * 16)
   ld bc, 16
   call CopiarBloque

   ; Cowboy (Tile IDs 0x10-0x17)
   ld hl, Cowboy_Tile0
   ld de, $8000 + (16 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile1
   ld de, $8000 + (17 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile2
   ld de, $8000 + (18 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile3
   ld de, $8000 + (19 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile4
   ld de, $8000 + (20 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile5
   ld de, $8000 + (21 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile6
   ld de, $8000 + (22 * 16)
   ld bc, 16
   call CopiarBloque
   ld hl, Cowboy_Tile7
   ld de, $8000 + (23 * 16)
   ld bc, 16
   call CopiarBloque

   ret

; ------------------------------------------------------------------------------
loop
 call WaitFrames_DE

 ; --- Lógica de la Bala ---
 call logica_bala

 ; --- Lógica de Entrada (JoyPad) ---
 ld a, $30    ; Lee botones de dirección y acción
 ldh [$FF00], a
 ld a, [$FF00]
 cpl       ; Invierte bits (0 si presionado)
 ld b, a     ; Guarda el estado

 ; --- Movimiento del Cowboy ---
 ld a, b
 bit 0, a     ; Bit 0: Derecha (P14)
 jr nz, .checkLeft
 ld a, [posX]
 inc a
 ld [posX], a
 jr .endMove

.checkLeft
 ld a, b
 bit 1, a     ; Bit 1: Izquierda (P15)
 jr nz, .checkUp
 ld a, [posX]
 dec a
 ld [posX], a
 jr .endMove

.checkUp
 ld a, b
 bit 2, a     ; Bit 2: Arriba (P12)
 jr nz, .checkDown
 ld a, [posY]
 dec a
 ld [posY], a
 jr .endMove

.checkDown
 ld a, b
 bit 3, a     ; Bit 3: Abajo (P13)
 jr nz, .checkB_Jump
 ld a, [posY]
 inc a
 ld [posY], a

.endMove
 ; Actualiza el sprite 0 (Cowboy)
 ld hl, $FE00   ; OAM Sprite 0
 ld a, [posY]
 ld [hl], a  ; Y
 ld a, [posX]
 ld [hl+], a  ; X
 inc hl
 inc hl 
 ld [hl], $10 ; Tile ID del Cowboy (asumiendo que se cargó en 0x10)
 inc hl
 inc hl
 inc hl
 ld [hl], %00000000 ; Propiedades

 ; --- Salto (Botón B - Bit 5) ---
.checkB_Jump
 ld a, b
 bit 5, a     ; Bit 5: Botón B (P11)
 jr nz, .checkA_Shoot ; Si B no está presionado, sigue

 ; Lógica de Salto (simplificada, solo cambia Y, no usa el código de salto original)
 ; Puedes reinsertar la lógica de salto compleja si lo deseas.

 ; --- Disparo (Botón A - Bit 4) ---
.checkA_Shoot
 ld a, b
 bit 4, a     ; Bit 4: Botón A (P10)
 jr nz, .updateCounter ; Si A no está presionado, sigue

 call Disparar

 ; --- Lógica del Contador ---
.updateCounter
 call logic_counter

 jp loop ; Repite el bucle

; ==============================================================================
; --- SUBRUTINAS ---
; ==============================================================================

; --- Carga de Tiles ---
; Esta función copia los datos de los tiles a VRAM ($8000-$97FF).
; ==============================================================================
; --- SUBRUTINAS ---
; ==============================================================================

; --- LCDC_init: Inicializa el LCD y paletas ---
LCDC_init:
    ld a, $91        ; LCDC: pantalla encendida, BG on, OBJ on, etc.
    ld [$FF40], a
    ld a, $FC        ; BGP: paleta BG
    ld [$FF47], a
    ld a, $FF        ; OBP0: paleta OBJ0
    ld [$FF48], a
    ld a, $F0        ; OBP1: paleta OBJ1
    ld [$FF49], a
    ret
 ld de, $8000 + (10 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Digito1_Tile
 ld de, $8000 + (11 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Digito2_Tile
 ld de, $8000 + (12 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Digito3_Tile
 ld de, $8000 + (13 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Digito4_Tile
 ld de, $8000 + (14 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Digito5_Tile
 ld de, $8000 + (15 * 16)
 ld bc, 16
 call CopiarBloque

 ; Proyectil (Tile ID 0x09)
 ld hl, Proyectil_Tile
 ld de, $8000 + (9 * 16)
 ld bc, 16
 call CopiarBloque

 ; Cowboy (Tile IDs 0x10-0x17)
 ld hl, Cowboy_Tile0
 ld de, $8000 + (16 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile1
 ld de, $8000 + (17 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile2
 ld de, $8000 + (18 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile3
 ld de, $8000 + (19 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile4
 ld de, $8000 + (20 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile5
 ld de, $8000 + (21 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile6
 ld de, $8000 + (22 * 16)
 ld bc, 16
 call CopiarBloque
 ld hl, Cowboy_Tile7
 ld de, $8000 + (23 * 16)
 ld bc, 16
 call CopiarBloque

 ret

; --- CopiarBloque: Copia BC bytes de HL a DE ---
CopiarBloque:
 ; HL = origen, DE = destino, BC = cantidad
 push hl
 push de
 push bc
.loopCopy
 ld a, [hl]
 ld [de], a
 inc hl
 inc de
 dec bc
 ld a, b
 or c
 jr nz, .loopCopy
 pop bc
 pop de
 pop hl
 ret
 ldh [$FF48], a
 ld a, $F0    ; OBP1 (Paleta de Sprites 1)
 ldh [$FF49], a
 ret

; --- Carga de Tiles (DEBES IMPLEMENTAR ESTO) ---
; Esta función debe copiar el tile data del ROM (Cowboy, Digitos, Bala) a VRAM ($8000-$97FF).


; --- Lógica del Contador (Usa Sprite 1) ---
logic_counter:
 ; Pone el contador en la esquina inferior derecha (o donde quieras)
 ld a, [ContadorValue]
 or a      ; Comprueba si es 0
 jr nz, .drawCounter
 ld a, 5     ; Si es 0, reinicia a 5
 ld [ContadorValue], a

.drawCounter
 ; El Tile ID del dígito es 0x0A (para el 5) + (5 - ContadorValue)
 ld h, a     ; h = ContadorValue
 ld a, $0F    ; Tile ID del '0' (0x0A + 5)
 sub h      ; Tile ID = 0x0F - ContadorValue (si ContadorValue es 5, Tile ID es 0x0A)
 ld c, a     ; c = Tile ID del dígito

 ; Dibuja el sprite del contador (asume Sprite ID 1 en $FE04)
 ld hl, $FE04   ; OAM Sprite 1
 ld a, $A0    ; Y: Posición vertical (casi al final)
 ld [hl], a
 ld a, $A0    ; X: Posición horizontal (casi al final)
 ld [hl+], a
 ld a, c     ; Tile ID (0x0A a 0x0F)
 inc hl
 inc hl
 ld [hl], a
 inc hl
 inc hl
 ld [hl], %00000000 ; Propiedades
 ret

; --- Lógica del Disparo (Usa Sprite 2) ---
Disparar:
 ld a, [BalaActiva]
 or a
 jr nz, .exit  ; Si ya está activa, no dispares de nuevo

 ; Activar la bala y posicionarla
 ld a, 1
 ld [BalaActiva], a

 ld a, [posY]
 ld [BalaY], a  ; Posición Y inicial de la bala (misma que el Cowboy)

 ld a, [posX]
 add 8      ; Posición X inicial de la bala (a la derecha del Cowboy)
 ld [BalaX], a

 ; Decrementa el contador al disparar
 ld a, [ContadorValue]
 or a      ; Comprueba si es 0
 jr z, .exit   ; No dispares si el contador es 0 (o la lógica de reinicio lo manejará)
 dec a
 ld [ContadorValue], a

.exit
 ret

logica_bala:
 ld a, [BalaActiva]
 or a
 jr z, .hideBala ; Si inactiva, asegúrate de que esté fuera de pantalla

 ; Mover la bala (Incrementar X para ir a la derecha)
 ld a, [BalaX]
 add 4      ; Velocidad de 4 pixeles/frame
 ld [BalaX], a

 ; Comprobar si la bala salió de la pantalla (X > 168)
 cp 168
 jr c, .drawBala ; Si X < 168, la dibuja
 ld a, 0     ; Si salió, desactiva
 ld [BalaActiva], a
 jr .hideBala

.drawBala
 ; Dibuja el sprite 2 (Bala en $FE08)
 ld hl, $FE08   ; OAM Sprite 2
 ld a, [BalaY]
   ld [hl], a  ; Y
   ld a, [BalaX]
   ld [hl+], a  ; X
   inc hl
   inc hl
   ld a, $09    ; Tile ID del proyectil
   ld [hl], a
   inc hl
   inc hl
   ld [hl], %00000000 ; Propiedades
   ret

.hideBala
 ; Mueve el sprite 2 fuera de la pantalla (Y=0, que lo oculta)
 ld hl, $FE08
 ld [hl], 0  ; Y=0
 ret

; ==============================================================================
; --- Funciones de Espera (mantenidas) ---
; ==============================================================================
waitOneFrame:
 .loopzero
   ld a, [$FF44]
   cp 0
   jr nz, .loopzero
 .loopvblank
   ld a, [$FF44]
   cp 144
   jr nz, .loopvblank
ret
waitVBLANK:
 .o:  
   ld a,[$FF44]
   cp 144
   jr nz,.o
   ret

WaitFrames_DE:
 ld de, 10 ; 60 -> 1s aprox
.loop1:
  call waitVBLANK
  dec de
  ld a,d
  or e
  jr nz,.loop1
  ret