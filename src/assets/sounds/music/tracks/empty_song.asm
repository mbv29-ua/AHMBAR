INCLUDE "assets/sounds/music/hUGE.inc"

SECTION "empty_song Song Data", ROM0

empty_song::
db 0
dw empty_order_cnt
dw empty_order1, empty_order2, empty_order3, empty_order4
dw _duty_instruments, _wave_instruments, _noise_instruments
dw _music_game_routines
dw _music_game_waves

empty_order_cnt: db 2
empty_order1: dw empty_track
empty_order2: dw empty_track
empty_order3: dw empty_track
empty_order4: dw empty_track
