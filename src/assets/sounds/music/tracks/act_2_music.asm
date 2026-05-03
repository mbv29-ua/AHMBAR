INCLUDE "assets/sounds/music/hUGE.inc"

SECTION "act_2_music Song Data", ROM0

act_2_music::
db 7
dw _music_game_order_cnt
dw _music_game_order1, _music_game_order2, _music_game_order3, _music_game_order4
dw _duty_instruments, _wave_instruments, _noise_instruments
dw _music_game_routines
dw _music_game_waves

_music_game_order_cnt: db 8
_music_game_order1: dw P0,P0,P20,P20
_music_game_order2: dw P1,P1,P21,P21
_music_game_order3: dw empty_track, empty_track, empty_track, empty_track
_music_game_order4: dw P3,P3,P3,P3

;; 1. note 
;; 2. instrument
;; 3. Effect

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
 dn D_3,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_3,1,$C0B
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
 dn E_3,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_3,1,$C0B







P1:
 dn E_5,1,$C0F
 dn A_4,1,$C0B
 dn F_5,1,$C0F
 dn A_4,1,$C0B
 dn G_5,1,$C0F
 dn A_4,1,$C0B
 dn A_5,1,$C0F
 dn E_5,1,$C0F
 dn A_4,1,$C0B
 dn F_5,1,$C0F
 dn A_4,1,$C0B
 dn G_5,1,$C0F
 dn F_5,0,$000
 dn E_5,0,$000
 dn D_5,0,$000
 dn C_5,0,$000
 dn B_4,1,$C0F
 dn A_4,1,$C0B
 dn C_5,1,$C0F
 dn A_4,1,$C0B
 dn D_5,1,$C0F
 dn A_4,1,$C0B
 dn E_5,1,$C0F
 dn B_4,1,$C0F
 dn A_4,1,$C0B
 dn C_5,1,$C0F
 dn A_4,1,$C0B
 dn D_5,1,$C0F
 dn A_4,1,$C0B
 dn E_5,0,$000
 dn F_5,0,$000
 dn G_5,0,$000







P3:
 dn ___,0,$F14
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
 dn A_3,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_3,1,$C0B
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
 dn E_4,1,$C08
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_4,1,$C0B







P21:
 dn E_5,1,$C0F
 dn B_4,1,$C0B
 dn F_5,1,$C0F
 dn B_4,1,$C0B
 dn G_5,1,$C0F
 dn B_4,1,$C0B
 dn A_5,1,$C0F
 dn E_5,1,$C0F
 dn B_4,1,$C0B
 dn F_5,1,$C0F
 dn B_4,1,$C0B
 dn G_5,1,$C0F
 dn F_5,0,$000
 dn E_5,0,$000
 dn D_5,0,$000
 dn E_5,0,$000
 dn B_4,1,$C0F
 dn A_4,1,$C0B
 dn C_5,1,$C0F
 dn A_4,1,$C0B
 dn D_5,1,$C0F
 dn A_4,1,$C0B
 dn E_5,1,$C0F
 dn B_4,1,$C0F
 dn A_4,1,$C0B
 dn C_5,1,$C0F
 dn A_4,1,$C0B
 dn G_5,1,$C0F
 dn A_4,1,$C0B
 dn G_5,0,$000
 dn F_5,0,$000
 dn E_5,0,$000
