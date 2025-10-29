INCLUDE "assets/sounds/music/hUGE.inc"

SECTION "music_game Song Data", ROMX

music_game::
db 7
dw _music_game_order_cnt
dw _music_game_order1, _music_game_order2, _music_game_order3, _music_game_order4
dw _music_game_duty_instruments, _music_game_wave_instruments, _music_game_noise_instruments
dw _music_game_routines
dw _music_game_waves

_music_game_order_cnt: db 8
_music_game_order1: dw P0,P0,P20,P20
_music_game_order2: dw P1,P1,P21,P21
_music_game_order3: dw P2,P2,P2,P2
_music_game_order4: dw P3,P3,P3,P3

;; 1. note 
;; 2. instrument
;; 3. Effect


;;;;;; 00010000 <- isalate 4th bit 
;;;;;; << 3 <- move 3 bits left
;;;;;; | combine macros inputs

P0:
 dn C_3,1,$C0B
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_3,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_3,1,$C0B
 dn ___,0,$000
 dn C_3,1,$C0B
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_3,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_3,1,$C0B
 dn ___,0,$000

P1:
 dn E_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn G_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn A_5,1,$C0F
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn G_5,1,$C0F
 dn ___,0,$000
 dn F_5,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn D_5,0,$000
 dn ___,0,$000
 dn C_5,0,$000
 dn ___,0,$000
 dn B_4,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn D_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn D_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn F_5,0,$000
 dn ___,0,$000
 dn G_5,0,$000
 dn ___,0,$000

P2:
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P3:
 dn ___,0,$F0A
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P20:
 dn C_3,1,$C0B
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_3,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_3,1,$C0B
 dn ___,0,$000
 dn C_3,1,$C0B
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_4,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_4,1,$C0B
 dn ___,0,$000

P21:
 dn E_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0B
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0B
 dn ___,0,$000
 dn G_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0B
 dn ___,0,$000
 dn A_5,1,$C0F
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0B
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0B
 dn ___,0,$000
 dn G_5,1,$C0F
 dn ___,0,$000
 dn F_5,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn D_5,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn B_4,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn D_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn G_5,1,$C0F
 dn ___,0,$000
 dn A_4,1,$C0B
 dn ___,0,$000
 dn G_5,0,$000
 dn ___,0,$000
 dn F_5,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000

_music_game_duty_instruments:
itSquareinst1:
db 8
db 64
db 240
dw 0
db 128



_music_game_wave_instruments:


_music_game_noise_instruments:


_music_game_routines:
__hUGE_Routine_0:

__end_hUGE_Routine_0:
ret

__hUGE_Routine_1:

__end_hUGE_Routine_1:
ret

__hUGE_Routine_2:

__end_hUGE_Routine_2:
ret

__hUGE_Routine_3:

__end_hUGE_Routine_3:
ret

__hUGE_Routine_4:

__end_hUGE_Routine_4:
ret

__hUGE_Routine_5:

__end_hUGE_Routine_5:
ret

__hUGE_Routine_6:

__end_hUGE_Routine_6:
ret

__hUGE_Routine_7:

__end_hUGE_Routine_7:
ret

__hUGE_Routine_8:

__end_hUGE_Routine_8:
ret

__hUGE_Routine_9:

__end_hUGE_Routine_9:
ret

__hUGE_Routine_10:

__end_hUGE_Routine_10:
ret

__hUGE_Routine_11:

__end_hUGE_Routine_11:
ret

__hUGE_Routine_12:

__end_hUGE_Routine_12:
ret

__hUGE_Routine_13:

__end_hUGE_Routine_13:
ret

__hUGE_Routine_14:

__end_hUGE_Routine_14:
ret

__hUGE_Routine_15:

__end_hUGE_Routine_15:
ret

_music_game_waves:

