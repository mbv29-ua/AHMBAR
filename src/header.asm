;SECTION "VBlank Interrupt", ROM0[$40]
;    reti

SECTION "LCD Interrupt", ROM0[$48]
    jp lcd_stat_handler
    ds 5, 0

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

   DB "AHMBAR"
   DS $013F - @, 0

   DB $EF, $AC, $AE, $AE   ; Manufacturer code
   DB $00                   ; CGB flag
   DB $00, $00              ; New licensee code
   DB $00                   ; SGB flag
   DB $00                   ; Cartridge type ($00 = ROM ONLY)
   DB $00                   ; ROM size ($00 = 32KB, no banking)
   DB $00                   ; RAM size ($00 = No RAM)
   DB $00                   ; Destination code (Japanese)
   DB $00                   ; Old licensee code
   DB $00                   ; Version number
   DB $00                   ; Header checksum (will be fixed by rgbfix)
   DB $00, $00              ; Global checksum (will be fixed by rgbfix)