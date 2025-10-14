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
DEF OAM_PLAYER          EQU $FE00
DEF OAM_COUNTER         EQU $FE04
DEF OAM_BULLET_1        EQU $FE08
DEF OAM_BULLET_2        EQU $FE0C
DEF OAM_BULLET_3        EQU $FE10

DEF TILE_EMPTY          EQU $00
DEF TILE_GROUND         EQU $01
DEF TILE_BRICK          EQU $02
DEF TILE_WINDOW         EQU $03
DEF TILE_PIPE           EQU $04
DEF TILE_CABLE          EQU $05
DEF TILE_PLATFORM_LIGHTS EQU $06
DEF TILE_WARNING        EQU $07
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


