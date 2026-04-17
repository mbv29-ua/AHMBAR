include "system/text_manager/text_manager_constants.inc"

SECTION "Charmap", ROM0

NEWCHARMAP text, main
CHARMAP "A", 48
CHARMAP "B", 49
CHARMAP "C", 50
CHARMAP "D", 51
CHARMAP "E", 52
CHARMAP "F", 53
CHARMAP "G", 54
CHARMAP "H", 55
CHARMAP "I", 56
CHARMAP "J", 57
CHARMAP "K", 58
CHARMAP "L", 59
CHARMAP "M", 60
CHARMAP "N", 61
CHARMAP "O", 62
CHARMAP "P", 63
CHARMAP "Q", 64
CHARMAP "R", 65
CHARMAP "S", 66
CHARMAP "T", 67
CHARMAP "U", 68
CHARMAP "V", 69
CHARMAP "W", 70
CHARMAP "X", 71
CHARMAP "Y", 72
CHARMAP "Z", 73
CHARMAP "a", 74
CHARMAP "b", 75
CHARMAP "c", 76
CHARMAP "d", 77
CHARMAP "e", 78
CHARMAP "f", 79
CHARMAP "g", 80
CHARMAP "h", 81
CHARMAP "i", 82
CHARMAP "j", 83
CHARMAP "k", 84
CHARMAP "l", 85
CHARMAP "m", 86
CHARMAP "n", 87
CHARMAP "o", 88
CHARMAP "p", 89
CHARMAP "q", 90
CHARMAP "r", 91
CHARMAP "s", 92
CHARMAP "t", 93
CHARMAP "u", 94
CHARMAP "v", 95
CHARMAP "w", 96
CHARMAP "x", 97
CHARMAP "y", 98
CHARMAP "z", 99
CHARMAP "Ñ", 100
CHARMAP "ñ", 101
CHARMAP "!", 102
CHARMAP "¡", 103
CHARMAP "?", 104
CHARMAP "¿", 105
CHARMAP ".", 106
CHARMAP ",", 107
CHARMAP "0", 108
CHARMAP "1", 109
CHARMAP "2", 110
CHARMAP "3", 111
CHARMAP "4", 112
CHARMAP "5", 113
CHARMAP "6", 114
CHARMAP "7", 115
CHARMAP "8", 116
CHARMAP "9", 117
CHARMAP " ", 118

; Esto debera estar en otro fichero hasta que se elimine -> fichero de textos
;test_text:
;DB "ABCDEFGHYJKLMNÑOP", ENDLINE
;DB "QRSTUVWXYZabcdefg", ENDLINE
;DB "hijklmnñopqrstuvw", ENDLINE
;DB "xyz¡!¿?.,01234567", ENDLINE
;DB "89 ", ENDTEXT



credits::
DB "A game by the", ENDLINE
DB "Hernandez", ENDLINE
DB "Mendivil", ENDLINE
DB "Beltra", ENDLINE
DB "Automatic", ENDLINE
DB "Reasoning Team", ENDTEXT

intro_text::
DB "Long ago,", ENDLINE
DB "Ahmbar changed", ENDLINE
DB "the fate of the ", ENDLINE
DB "world.", ENDTEXT

; Menu principal (centrado, mas abajo)
;menu_title::
;DB "", ENDLINE
;DB "       AHMBAR", ENDLINE
;DB "", ENDLINE
;DB "      Start Game", ENDLINE
;DB "      Controls", ENDLINE
;DB "      Credits", ENDTEXT

; Pantalla de controles (centrado)
;controls_text::
;DB "", ENDLINE
;DB "    CONTROLS", ENDLINE
;DB "", ENDLINE
;DB "  D-PAD: Move", ENDLINE
;DB "  A: Jump", ENDLINE
;DB "  B: Shoot", ENDLINE
;DB "", ENDLINE
;DB " Press A to return", ENDTEXT

; Pantalla de creditos
;credits_screen::
;DB "    CREDITS", ENDLINE
;DB "", ENDLINE
;DB " Sonia Mendivil", ENDLINE
;DB " Miguel Beltra", ENDLINE
;DB "Jaime Hernandez", ENDLINE
;DB "", ENDLINE
;DB "   Press A", ENDTEXT


;; ACT 1 Dialogs ;; 

act_1_scene_1_dialog::
	DB "Oh no, toxic frogs.", 	ENDLINE
	DB "I have to ", 			ENDLINE
	DB "reach the door. I", 	ENDLINE
	DB "need to gather all", 	ENDLINE
	DB "the Ahmbar I can.",		ENDTEXT

act_1_scene_2_dialog::
	DB "OMG, the only way", 	ENDLINE
	DB "is going down...", 		ENDLINE
	DB "But how?", 				ENDTEXT

act_1_scene_3_dialog::
	DB "Easy...", 				ENDTEXT

act_1_scene_4_dialog::
	DB "Oh dear,", 				ENDLINE
	DB "here we go again.", 	ENDTEXT

act_1_scene_5_dialog::
	DB "Now I can", 			ENDLINE
	DB "jump twice.", 			ENDTEXT



;;; ACT 2 Dialogs ;;;

act_2_scene_1_dialog::
	DB "Oh, Toshokan, my", 		ENDLINE
	DB "city. Once", 			ENDLINE
	DB "prosperous and", 		ENDLINE
	DB "rich, now only", 		ENDLINE
	DB "ruins remain of", 		ENDLINE
	DB "what it once was.",		ENDTEXT

act_2_scene_2_dialog::
	DB "The old station.", 		ENDLINE
	DB "There is too much", 	ENDLINE
	DB "noise. I would", 		ENDLINE
	DB "better go clean", 		ENDLINE
	DB "it up.",				ENDTEXT

act_2_scene_3_dialog::
	DB "I know a shortcut.",	ENDLINE
	DB "They call it the",		ENDLINE
	DB "Leap of Death. I",		ENDLINE
	DB "hope it does not",		ENDLINE
	DB "live up to its",		ENDLINE
	DB "name today.",			ENDTEXT

act_2_scene_4_dialog::
	DB "The electrical",		ENDLINE
	DB "installations of",		ENDLINE
	DB "this place should",		ENDLINE
	DB "have been inspected",	ENDLINE
	DB "a long time ago.",		ENDLINE
	DB "It is a death trap.",	ENDTEXT

act_2_final_scene_dialog::
	DB "A corrupted",	ENDLINE
	DB "life form! Ahmbar ",	ENDLINE
	DB "curses all living",	ENDLINE
	DB "forms. I must kill",	ENDLINE
	DB "it before this",		ENDLINE
	DB "collapses.",			ENDTEXT
