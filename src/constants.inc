;;; TEMPORARY CONSTANTS
DEF PLAYER_Y_SPEED EQU 1
DEF PLAYER_X_SPEED EQU 1
DEF PLAYER_JUMP_SPEED EQU 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; INTERRUPTS HANDLER CALLERS ADDRESSES
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF INTERRUPT_VBLANK         EQU $40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DIRECCIONES RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;
DEF VRAM0_START         EQU $8000
DEF VRAM_TILESET_SIZE   EQU 128
DEF BG_MAP_START        EQU $9800
DEF BG_MAP_SIZE         EQU 1024
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
DEF rDMA	EQU $FF46
DEF rBGP    EQU $FF47
DEF rOBP0   EQU $FF48
DEF rOBP1   EQU $FF49
DEF rWY     EQU $FF4A
DEF rWX     EQU $FF4B
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

DEF PRESSED_BUTTONS      EQU $DFFF    ;; ver que hacer con esto
DEF JUST_PRESSED_BUTTONS EQU $DFFE    ;; ver que hacer con esto
DEF RELEASED_BUTTONS     EQU $DFFD    ;; ver que hacer con esto

; Provisional, mover donde toque
DEF CHARMAP_START EQU 128
DEF CHARMAP_SIZE EQU (198-(128-1))

DEF FIRST_DIALOG_LINE  EQU $9961
DEF SECOND_DIALOG_LINE EQU $9981
DEF THIRD_DIALOG_LINE  EQU $99A1
DEF FOURTH_DIALOG_LINE EQU $99C1
DEF FIFTH_DIALOG_LINE  EQU $99E1
DEF SIXTH_DIALOG_LINE  EQU $9A01

DEF TEXTLINE_SIZE EQU 18

DEF ENDLINE EQU 10
DEF ENDTEXT EQU 11



DEF TILE_BULLET         EQU $09

; Números para HUD (según posiciones reales en VRAM)
DEF TILE_DIGIT_0        EQU $95  ; Tile 0
DEF TILE_DIGIT_1        EQU $96  ; Tile 1
DEF TILE_DIGIT_2        EQU $97  ; Tile 2
DEF TILE_DIGIT_3        EQU $98  ; Tile 3
DEF TILE_DIGIT_4        EQU $99  ; Tile 4
DEF TILE_DIGIT_5        EQU $9A  ; Tile 5
DEF TILE_COWBOY         EQU $10
DEF TILE_GOAL           EQU $11

DEF PLAYER_START_X      EQU 80
DEF PLAYER_START_Y      EQU 72
DEF PLAYER_SPEED        EQU 2
DEF PLAYER_JUMP_POWER   EQU 32

; Posiciones iniciales del jugador por nivel
; Nivel 1: Tile en $9BC1 (X=1, Y=30/0x1E) con scroll (0, 112)
DEF LEVEL1_PLAYER_X     EQU 16
DEF LEVEL1_PLAYER_Y     EQU 144
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

DEF MAX_BULLETS         EQU 5  ; Máximo de balas disponibles
DEF BULLET_SPEED        EQU 4
DEF BULLET_INACTIVE     EQU 0
DEF BULLET_ACTIVE       EQU 1

DEF COUNTER_START       EQU 5
DEF INITIAL_PLAYER_LIVES EQU 4 ; Vidas iniciales del jugador
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


