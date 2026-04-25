SECTION "hud_tiles", ROM0


;hud_tiles::
;; Tiles de corazones para el HUD
;.heart_full:
;DB $00,$00,$66,$66,$FF,$FF,$FF,$FF
;DB $FF,$FF,$7E,$7E,$3C,$3C,$18,$18
;.heart_half:
;:DB $00,$00,$66,$66,$F0,$F0,$F0,$F0
;DB $F0,$F0,$60,$60,$30,$30,$18,$18
;.hearts_end:


; Tiles de corazones para el HUD
hud_tiles::
.heart_full:
DB $00,$00,$66,$66,$99,$F9,$9D,$E1
DB $8F,$F1,$46,$7A,$24,$3C,$18,$18
.heart_three:
DB $00,$00,$64,$64,$98,$F8,$9C,$E0
DB $8C,$F0,$44,$78,$24,$3C,$18,$18
.heart_half:
DB $00,$00,$60,$60,$90,$F0,$98,$E0
DB $88,$F0,$40,$70,$20,$30,$10,$10
.heart_one_quarter:
DB $00,$00,$40,$40,$80,$80,$80,$80
DB $80,$80,$40,$40,$00,$00,$00,$00
.hearts_end: