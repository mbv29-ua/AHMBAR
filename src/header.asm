SECTION "VBlank Interrupt", ROM0[$40]
    reti

SECTION "LCD Interrupt", ROM0[$48]
    reti

SECTION "Timer Interrupt", ROM0[$50]
    reti

SECTION "Serial Interrupt", ROM0[$58]
    reti

SECTION "Joypad Interrupt", ROM0[$60]
    reti

SECTION "Header", ROM0[$100]
   nop
   jp main

   DB $CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
   DB $00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
   DB $BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E

   DB "COWBOY GAME"
   DS $013F - @, 0

   DB $EF, $AC, $AE, $AE
   DB $00
   DB $00, $00
   DB $00
   DB $00
   DB $00
   DB $02
   DB $01
   DB $00
   DB $00
   DB $00
   DB $00, $00