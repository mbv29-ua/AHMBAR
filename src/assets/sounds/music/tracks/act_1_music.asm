INCLUDE "assets/sounds/music/hUGE.inc"

SECTION "act_1_music Song Data", ROM0

act_1_music::
db 7
dw act_1_order_cnt
dw act_1_order1, act_1_order2, act_1_order3, act_1_order4
dw _duty_instruments, _wave_instruments, _noise_instruments
dw _music_game_routines
dw _music_game_waves

act_1_order_cnt: db 8
act_1_order1: dw P01,P02,P01,P02
act_1_order2: dw P11,P12,P11,P13
act_1_order3: dw P2,P2,P2,P2
act_1_order4: dw empty_track,empty_track,empty_track,empty_track


P01:
 dn C_3,1,$C0F
 dn E_3,1,$C0E
 dn G_3,1,$C0D
 dn E_3,1,$C0C
 dn C_3,1,$C0F
 dn E_3,1,$C0E
 dn G_3,1,$C0D
 dn E_3,1,$C0C
 dn C_3,1,$C0F
 dn F_3,1,$C0E
 dn A_3,1,$C0D
 dn F_3,1,$C0C
 dn C_3,1,$C0F
 dn E_3,1,$C0E
 dn A_3,1,$C0D
 dn E_3,1,$C0C
 dn D_3,1,$C0F
 dn F_3,1,$C0E
 dn A_3,1,$C0D
 dn F_3,1,$C0C
 dn D_3,1,$C0F
 dn F_3,1,$C0E
 dn A_3,1,$C0D
 dn F_3,1,$C0C
 dn G_3,1,$C0F
 dn B_3,1,$C0E
 dn G_3,1,$C0D
 dn D_3,1,$C0C
 dn G_3,1,$C0F
 dn B_3,1,$C0E
 dn G_3,1,$C0D
 dn D_3,1,$C0C


P02:
 dn C_4,1,$C0F
 dn G_3,1,$C0E
 dn E_3,1,$C0D
 dn C_3,1,$C0C
 dn C_4,1,$C0F
 dn G_3,1,$C0E
 dn E_3,1,$C0D
 dn C_3,1,$C0C
 dn C_4,1,$C0F
 dn A_3,1,$C0E
 dn F_3,1,$C0D
 dn C_3,1,$C0C
 dn C_4,1,$C0F
 dn A_3,1,$C0E
 dn E_3,1,$C0D
 dn C_3,1,$C0C
 dn C_4,1,$C0F
 dn A_3,1,$C0E
 dn F_3,1,$C0D
 dn C_3,1,$C0C
 dn C_4,1,$C0F
 dn A_3,1,$C0E
 dn F_3,1,$C0D
 dn C_3,1,$C0C
 dn D_4,1,$C0F
 dn B_3,1,$C0E
 dn G_3,1,$C0D
 dn D_3,1,$C0C
 dn D_4,1,$C0F
 dn B_3,1,$C0E
 dn G_3,1,$C0D
 dn D_3,1,$C0C


P11:
 dn E_5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,1,$C0F
 dn E_5,1,$C0F
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$C0F
 dn G#5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,1,$C0F
 dn E_5,1,$C0F
 dn ___,0,$000
 dn E_5,1,$C0F
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$C0F
 dn G#5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000







P12:
 dn C_6,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_6,1,$C0F
 dn ___,0,$000
 dn B_5,1,$C0F
 dn ___,0,$000
 dn C_6,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn C#6,1,$C0F
 dn C_6,1,$C0F
 dn ___,0,$000
 dn B_5,1,$C0F
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0F
 dn ___,0,$000
 dn C_5,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn C#5,1,$C0F
 dn C_5,1,$C0F
 dn ___,0,$000
 dn B_4,1,$C0F
 dn ___,0,$000


P13:
 dn C_6,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_6,1,$C0F
 dn ___,0,$000
 dn B_5,1,$C0F
 dn ___,0,$000
 dn C_6,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn C#6,1,$C0F
 dn C_6,1,$C0F
 dn ___,0,$000
 dn B_5,1,$C0F
 dn ___,0,$000
 dn C_6,1,$C0F
 dn ___,0,$000
 dn F_5,1,$C0F
 dn ___,0,$000
 dn C_5,1,$C0F
 dn C#5,1,$C0F
 dn D_5,1,$C0F
 dn C#5,1,$C0F
 dn C_5,1,$C0F
 dn B_4,1,$C0F
 dn A#4,1,$C0F
 dn A_4,1,$C0F
 dn G#4,1,$C0F
 dn G_4,1,$C0F
 dn F#4,1,$C0F
 dn F_4,1,$C0F



P2:
 dn C_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,1,$C0F
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000