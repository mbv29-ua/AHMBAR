;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DIRECCIONES RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF VRAM0_START         EQU $8000
DEF VRAM_TILESET_SIZE   EQU 128
DEF BG_MAP_START        EQU $9800
DEF OAM_START           EQU $FE00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; UTILS CONSTANTS RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF TILE_SET_BANK_SIZE  EQU 128
DEF TILE_SIZE           EQU $10
DEF OAM_SPRITE_SIZE     EQU 4
DEF OAM_TOTAL_SPRITES   EQU 40
DEF OAM_SIZE            EQU (OAM_TOTAL_SPRITES*OAM_SPRITE_SIZE)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ??? 
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF SCREEN_WIDTH        EQU 160
DEF SCREEN_HEIGHT       EQU 144
DEF SCREEN_RIGHT_EDGE   EQU 168
DEF BIT_PPU_ENABLES     EQU 7
DEF START_VBLANK        EQU 144

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  BULLET 
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF OAM_BULLET          EQU $FE08
DEF BULLET_COUNT_INT    EQU 5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; REGISTROS I/O   
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF rLCDC   EQU $FF40
DEF rSTAT   EQU $FF41
DEF rSCY    EQU $FF42
DEF rSCX    EQU $FF43
DEF rLY     EQU $FF44
DEF rBGP    EQU $FF47
DEF rOBP0   EQU $FF48
DEF rOBP1   EQU $FF49
DEF rP1     EQU $FF00
DEF rIE     EQU $FFFF

DEF LCDCF_ON    EQU $80
DEF LCDCF_BGON  EQU $01
DEF LCDCF_OBJON EQU $02
DEF IEF_VBLANK  EQU $01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PALETTE 
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF DEFAULT_PALETTE EQU %11100100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DELETE
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF OAM_PLAYER          EQU $FE00    ;; temp -> maybe dont delete
DEF OAM_COUNTER         EQU $FE04
DEF PRESSED_BUTTONS     EQU $DFFF    ;; ver que hacer con esto

DEF TILE_BULLET         EQU $09
DEF TILE_DIGIT_0        EQU $0A
DEF TILE_DIGIT_1        EQU $0B
DEF TILE_DIGIT_2        EQU $0C
DEF TILE_DIGIT_3        EQU $0D
DEF TILE_DIGIT_4        EQU $0E
DEF TILE_DIGIT_5        EQU $0F
DEF TILE_COWBOY         EQU $10
DEF TILE_GOAL           EQU $11

DEF PLAYER_START_X      EQU 80
DEF PLAYER_START_Y      EQU 72
DEF PLAYER_SPEED        EQU 2
DEF PLAYER_JUMP_POWER   EQU 32

; Posiciones iniciales del jugador por nivel
; Nivel 1: Tile en $9BA1 (X=1, Y=29) con scroll (0, 112)
DEF LEVEL1_PLAYER_X     EQU 16
DEF LEVEL1_PLAYER_Y     EQU 136
; Nivel 2: Tile en $98C4 (X=4, Y=6) con scroll (0, 0)
DEF LEVEL2_PLAYER_X     EQU 40
DEF LEVEL2_PLAYER_Y     EQU 64
; Nivel 3: Por defecto --> no esta hecho mirar de momento
DEF LEVEL3_PLAYER_X     EQU 80
DEF LEVEL3_PLAYER_Y     EQU 72

; Posición del objetivo en píxeles OAM (tile en columna 16, fila 9 - centro del mapa)
; Columna 16: 16*8 = 128 píxeles de pantalla + 8 offset OAM = 136
; Fila 9: 9*8 = 72 píxeles de pantalla + 16 offset OAM = 88
DEF GOAL_X_MIN          EQU 136
DEF GOAL_X_MAX          EQU 144
DEF GOAL_Y_MIN          EQU 88
DEF GOAL_Y_MAX          EQU 96

DEF MAX_BULLETS         EQU 3
DEF BULLET_SPEED        EQU 4
DEF BULLET_INACTIVE     EQU 0
DEF BULLET_ACTIVE       EQU 1

DEF COUNTER_START       EQU 5
DEF COUNTER_X_POS       EQU 152
DEF COUNTER_Y_POS       EQU 16

; Scroll inicial para cada nivel
; Nivel 1: abajo-izquierda (SCX=0, SCY=112)
DEF LEVEL1_SCX          EQU 0
DEF LEVEL1_SCY          EQU 112
; Nivel 2: arriba-izquierda (SCX=0, SCY=0)
DEF LEVEL2_SCX          EQU 0
DEF LEVEL2_SCY          EQU 0
; Nivel 3: abajo-izquierda (SCX=0, SCY=112)
DEF LEVEL3_SCX          EQU 0
DEF LEVEL3_SCY          EQU 112


