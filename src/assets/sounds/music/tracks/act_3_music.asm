INCLUDE "assets/sounds/music/hUGE.inc"

SECTION "act_3_music Song Data", ROM0

act_3_music::
db 7
dw act_3_order_cnt
dw act_3_order1, act_3_order2, act_3_order3, act_3_order4
dw _duty_instruments, _wave_instruments, _noise_instruments
dw _music_game_routines
dw _music_game_waves

act_3_order_cnt: db 8
act_3_order1: dw P0_act_3,P0_act_3,P0_act_3,P0_act_3
act_3_order2: dw P11_act_3,P11_act_3,P11_act_3,P12_act_3
act_3_order3: dw empty_track,empty_track,empty_track,empty_track
act_3_order4: dw empty_track,empty_track,empty_track,empty_track


P0_act_3:
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn F_3,1,$C0C
 dn C_3,1,$C09
 dn F_3,1,$C08
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn D_3,1,$C0C
 dn C_3,1,$C09
 dn D_3,1,$C08
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn F_3,1,$C0C
 dn C_3,1,$C09
 dn F_3,1,$C08
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn G_3,1,$C0C
 dn C_3,1,$C09
 dn G_3,1,$C08







P11_act_3:
 dn E_4,1,$C0F
 dn D_4,1,$C0C
 dn D#4,1,$C0C
 dn E_4,1,$C0C
 dn F_4,1,$C0F
 dn D#4,1,$C0C
 dn E_4,1,$C0C
 dn F_4,1,$C0C
 dn F#4,1,$C0F
 dn E_4,1,$C0C
 dn F_4,1,$C0C
 dn F#4,1,$C0C
 dn G_4,1,$C0F
 dn F_4,1,$C0C
 dn F#4,1,$C0C
 dn G_4,1,$C0C
 dn G#4,1,$C0F
 dn G_4,1,$C0C
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn G_4,1,$C0F
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn F#4,1,$C0F
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn D#4,1,$C0C
 dn F_4,1,$C0F
 dn E_4,1,$C0C
 dn D#4,1,$C0C
 dn D_4,1,$C0C

P12_act_3:
 dn A#4,1,$C0F
 dn B_4,1,$C0C
 dn A#4,1,$C0C
 dn A_4,1,$C0C
 dn B_4,1,$C0F
 dn A#4,1,$C0C
 dn A_4,1,$C0C
 dn G#4,1,$C0C
 dn A#4,1,$C0F
 dn A_4,1,$C0C
 dn G#4,1,$C0C
 dn G_4,1,$C0C
 dn A#4,1,$C0F
 dn A_4,1,$C0C
 dn G#4,1,$C0C
 dn G_4,1,$C0C
 dn A_4,1,$C0F
 dn G#4,1,$C0C
 dn G_4,1,$C0C
 dn F#4,1,$C0C
 dn G#4,1,$C0F
 dn G_4,1,$C0C
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn G_4,1,$C0F
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn F#4,1,$C0F
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn D#4,1,$C0C
