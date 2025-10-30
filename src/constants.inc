DEF PLAYER_HEIGHT EQU 8
DEF PLAYER_WIDTH  EQU 8

;;; TEMPORARY CONSTANTS
DEF OAM_PLAYER          EQU $FE00    ;; temp -> maybe dont delete
DEF OAM_COUNTER         EQU $FE04


DEF PLAYER_SPEED        EQU 2
DEF PLAYER_JUMP_POWER   EQU 32


DEF TILE_BULLET         EQU $09
; Números para HUD (según posiciones reales en VRAM)
DEF TILE_DIGIT_0        EQU $70
DEF TILE_DIGIT_1        EQU $71
DEF TILE_DIGIT_2        EQU $72
DEF TILE_DIGIT_3        EQU $73
DEF TILE_DIGIT_4        EQU $74
DEF TILE_DIGIT_5        EQU $75
DEF TILE_DIGIT_6        EQU $76
DEF TILE_DIGIT_7        EQU $77
DEF TILE_DIGIT_8        EQU $78
DEF TILE_DIGIT_9        EQU $79
DEF TILE_COWBOY         EQU $10
DEF TILE_GOAL           EQU $11


DEF PLAYER_Y_SPEED EQU 1
DEF PLAYER_X_SPEED EQU 1
DEF PLAYER_JUMP_SPEED EQU 3
; =============================================================
; GRAVEDAD ESTO MOVERLO
; =============================================================

DEF GRAVITY     EQU 32
DEF MAX_GRAVITY EQU  8 ; To avoid skip two tiles
; =============================================================



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
;;; BUTTONS
;;;;;;;;;;;;;;;;;;;;;;;;;;

DEF PRESSED_BUTTONS      EQU $DFFF   
DEF JUST_PRESSED_BUTTONS EQU $DFFE    ;; ver que hacer con esto
DEF RELEASED_BUTTONS     EQU $DFFD    ;; ver que hacer con esto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SPRITE ATTRIBUTES
;;;;;;;;;;;;;;;;;;;;;;;;;;

DEF E_BIT_PRIORITY  EQU 7
DEF E_BIT_FLIP_Y    EQU 6
DEF E_BIT_FLIP_X    EQU 5
DEF E_BIT_PALETTE   EQU 4


;;;;;;;;;;;;;;;
;;; MACROS
;;;;;;;;;;;;;;;

MACRO DW_BE
    DB HIGH(\1), LOW(\1)
ENDM