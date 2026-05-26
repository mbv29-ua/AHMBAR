INCLUDE "constants.inc"
INCLUDE "tiles.inc"
INCLUDE "system/collision_manager/collisions.inc"
INCLUDE "entities/entities.inc"

SECTION "The End Scene", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; trigger_game_end
;;; Used as next_level_trigger for the last scene.
;;; Checks door collision and jumps to THE END screen.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

trigger_game_end::
    call get_tile_at_player_position
    call is_tile_door
    ret nz              ; Not a door, return normally

    ld b, 30
    call wait_x_frames
    jp scene_the_end    ; No return - jumps to THE END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; count_tile_ahmbar_in_bg
;;; Scans the BG map for AHMBAR_TILE tiles and adds
;;; the count to wTotalAhmbarSpawned.
;;; Call this after load_level_map, while screen is off.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

count_tile_ahmbar_in_bg::
    ld hl, BG_MAP_START
    ld bc, 32 * 32          ; Scan full 32x32 BG map
.scan_loop:
    ld a, [hl+]
    cp AHMBAR_TILE
    jr nz, .not_found
    push hl
    push bc
    ld hl, wTotalAhmbarSpawned
    inc [hl]
    pop bc
    pop hl
.not_found:
    dec bc
    ld a, b
    or c
    jr nz, .scan_loop
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; scene_the_end
;;; THE END screen. Displays stats and achievement.
;;; Waits for A, then restarts.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_the_end::
    ld a, $00
    ld [$FF26], a       ; Turn off audio

    call hUGE_init

    call fade_to_black
    call the_end_init
    call fade_to_original

    ;; FIXME: does not work -> i dunno why
    call wait_until_A_pressed

    jp restart_game


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; the_end_init
;;; Initialises the THE END screen background and text.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

the_end_init::
    call screen_off
    call man_entity_init
    call clean_OAM
    call clean_bg_map

    call Load_letras_intro_Tiles

    ; Fill visible BG with blank tile ($80)
    call fill_bg_blank

    ; Write static layout and dynamic stats
    call write_the_end_content

    call reset_scroll
    call disable_hud_screen
    call screen_on
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fill_bg_blank
;;; Fills rows 0-17 (18*32 = 576 bytes) of the BG map
;;; with tile $80 (blank).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fill_bg_blank::
    ld hl, BG_MAP_START
    ld bc, 18 * 32
.loop:
    ld a, $80
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; write_bg_string
;;; Copies tile values from DE to BG map at HL
;;; until the $FF terminator is found.
;;; HL: destination in BG map
;;; DE: source string in ROM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

write_bg_string::
.loop:
    ld a, [de]
    inc de
    cp $FF
    ret z
    ld [hl+], a
    jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; write_stat_number
;;; Writes a 2-digit decimal number as tile IDs.
;;; A:  value (0-99)
;;; HL: BG map destination (2 tiles written)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

write_stat_number::
    ld b, 0
.tens:
    cp 10
    jr c, .done_tens
    sub 10
    inc b
    jr .tens
.done_tens:
    push af             ; save units digit
    ld a, b
    add TILE_DIGIT_0
    ld [hl+], a         ; write tens tile
    pop af
    add TILE_DIGIT_0
    ld [hl], a          ; write units tile
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; write_the_end_content
;;; Writes all text and numbers to the BG map.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; THE END screen layout (20 tiles wide):
;   row 1:  col 6  "THE END"
;   row 4:  col 5  "Ahmbar."   col 13  XX
;   row 6:  col 5  "Kills."    col 13  XX
;   row 8:  col 5  "Deaths."   col 13  XX
;   row 11: col 5  achievement message
;   row 14: col 6  "Press A"

write_the_end_content::
    ; Row 1: "THE END" centred
    ld hl, BG_MAP_START + 1 * 32 + 6
    ld de, end_text_the_end
    call write_bg_string

    ; Row 4: "Ahmbar." + score
    ld hl, BG_MAP_START + 4 * 32 + 5
    ld de, end_text_ahmbar
    call write_bg_string
    ld hl, BG_MAP_START + 4 * 32 + 13
    ld a, [score_value]
    call write_stat_number

    ; Row 6: "Kills." + kills
    ld hl, BG_MAP_START + 6 * 32 + 5
    ld de, end_text_kills
    call write_bg_string
    ld hl, BG_MAP_START + 6 * 32 + 13
    ld a, [wEnemiesKilled]
    call write_stat_number

    ; Row 8: "Deaths." + hits
    ld hl, BG_MAP_START + 8 * 32 + 5
    ld de, end_text_deaths
    call write_bg_string
    ld hl, BG_MAP_START + 8 * 32 + 13
    ld a, [wEnemyHits]
    call write_stat_number

    ; Row 11: achievement message
    call write_achievement

    ; Row 14: "Press A" centred
    ld hl, BG_MAP_START + 14 * 32 + 6
    ld de, end_text_press_a
    call write_bg_string

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; write_achievement
;;; Checks conditions and writes the best matching
;;; achievement title at row 7, col 2.
;;; Priority: UNTOUCHABLE > DESTROYER > COLLECTOR > PACIFIST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

write_achievement::
    ; UNTOUCHABLE: no enemy hits
    ld a, [wEnemyHits]
    or a
    jr nz, .check_destroyer

    ld hl, BG_MAP_START + 11 * 32 + 4
    ld de, end_text_untouchable
    call write_bg_string
    ret

.check_destroyer:
    ; DESTROYER: killed all regular enemies (and at least one existed)
    ld a, [wTotalRegularSpawned]
    or a
    jr z, .check_collector  ; no regular enemies in game
    ld b, a
    ld a, [wRegularEnemiesKilled]
    cp b
    jr nz, .check_collector

    ld hl, BG_MAP_START + 11 * 32 + 5
    ld de, end_text_destroyer
    call write_bg_string
    ret

.check_collector:
    ; COLLECTOR: all ahmbar collected
    ld a, [wTotalAhmbarSpawned]
    or a
    jr z, .check_pacifist   ; no ahmbar in game
    ld b, a
    ld a, [score_value]
    cp b
    jr nz, .check_pacifist

    ld hl, BG_MAP_START + 11 * 32 + 5
    ld de, end_text_collector
    call write_bg_string
    ret

.check_pacifist:
    ; PACIFIST: zero regular enemies killed
    ld a, [wRegularEnemiesKilled]
    or a
    ret nz                  ; Killed some regular enemies: no achievement

    ld hl, BG_MAP_START + 11 * 32 + 6
    ld de, end_text_pacifist
    call write_bg_string
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; write_game_over_stats
;;; Writes stats on the Game Over screen (rows 0-2).
;;; Called from game_over_init while screen is off.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Stats screen layout (20 tiles wide):
;   col:  0    5           13
;         $80  Ahmbar.  $80  XX
;         $80  Kills.   $80  XX
;         $80  Deaths.  $80  XX
;                 Press A
;
; Labels start at col 5, numbers at col 13 (right-aligned block)

write_game_over_stats::
    ; Row 4: "Ahmbar." label + score value
    ld hl, BG_MAP_START + 4 * 32 + 5
    ld de, end_text_ahmbar
    call write_bg_string
    ld hl, BG_MAP_START + 4 * 32 + 13
    ld a, [score_value]
    call write_stat_number

    ; Row 6: "Kills." label + enemies killed
    ld hl, BG_MAP_START + 6 * 32 + 5
    ld de, end_text_kills
    call write_bg_string
    ld hl, BG_MAP_START + 6 * 32 + 13
    ld a, [wEnemiesKilled]
    call write_stat_number

    ; FIXME: death starts with 16, it shoud be 0
    ; Row 8: "Deaths." label + enemy hits
    ld hl, BG_MAP_START + 8 * 32 + 5
    ld de, end_text_deaths
    call write_bg_string
    ld hl, BG_MAP_START + 8 * 32 + 13
    ld a, [wEnemyHits]
    call write_stat_number

    ; Row 13: "Press A" centred at col 6
    ld hl, BG_MAP_START + 13 * 32 + 6
    ld de, end_text_press_a
    call write_bg_string

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; String data for THE END screen
;;; Tile ID values matching the game charmap:
;;; A=48 B=49 C=50 D=51 E=52 F=53 G=54 H=55 I=56
;;; J=57 K=58 L=59 M=60 N=61 O=62 P=63 Q=64 R=65
;;; S=66 T=67 U=68 V=69 W=70 X=71 Y=72 Z=73
;;; a=74 b=75 c=76 d=77 e=78 f=79 g=80 h=81 i=82
;;; j=83 k=84 l=85 m=86 n=87 o=88 p=89 r=91 s=92
;;; t=93 u=94 y=98 .=106 !=102 ' '=118
;;; $FF = string terminator
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION "The End Text", ROM0

; "THE END"
end_text_the_end::
    DB 67, 55, 52, 118, 52, 61, 51, $FF

; "Ahmbar."
end_text_ahmbar::
    DB 48, 81, 86, 75, 74, 91, 106, $FF

; "Kills."
end_text_kills::
    DB 58, 82, 85, 85, 92, 106, $FF

; "Deaths."
end_text_deaths::
    DB 51, 78, 74, 93, 81, 92, 106, $FF

; "Press A"
end_text_press_a::
    DB 63, 91, 78, 92, 92, 118, 48, $FF

; "UNTOUCHABLE!"
end_text_untouchable::
    DB 68, 61, 67, 62, 68, 50, 55, 48, 49, 59, 52, 102, $FF

; "COLLECTOR!"
end_text_collector::
    DB 50, 62, 59, 59, 52, 50, 67, 62, 65, 102, $FF

; "PACIFIST!"
end_text_pacifist::
    DB 63, 48, 50, 56, 53, 56, 66, 67, 102, $FF

; "DESTROYER!"
end_text_destroyer::
    DB 51, 52, 66, 67, 65, 62, 72, 52, 65, 102, $FF
