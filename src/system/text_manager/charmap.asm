include "system/text_manager/text_manager_constants.inc"

SECTION "Charmap", ROM0

NEWCHARMAP text, main
CHARMAP "A", 128
CHARMAP "B", 129
CHARMAP "C", 130
CHARMAP "D", 131
CHARMAP "E", 132
CHARMAP "F", 133
CHARMAP "G", 134
CHARMAP "H", 135
CHARMAP "I", 136
CHARMAP "J", 137
CHARMAP "K", 138
CHARMAP "L", 139
CHARMAP "M", 140
CHARMAP "N", 141
CHARMAP "O", 142
CHARMAP "P", 143
CHARMAP "Q", 144
CHARMAP "R", 145
CHARMAP "S", 146
CHARMAP "T", 147
CHARMAP "U", 148
CHARMAP "V", 149
CHARMAP "W", 150
CHARMAP "X", 151
CHARMAP "Y", 152
CHARMAP "Z", 153
CHARMAP "a", 154
CHARMAP "b", 155
CHARMAP "c", 156
CHARMAP "d", 157
CHARMAP "e", 158
CHARMAP "f", 159
CHARMAP "g", 160
CHARMAP "h", 161
CHARMAP "i", 162
CHARMAP "j", 163
CHARMAP "k", 164
CHARMAP "l", 165
CHARMAP "m", 166
CHARMAP "n", 167
CHARMAP "o", 168
CHARMAP "p", 169
CHARMAP "q", 170
CHARMAP "r", 171
CHARMAP "s", 172
CHARMAP "t", 173
CHARMAP "u", 174
CHARMAP "v", 175
CHARMAP "w", 176
CHARMAP "x", 177
CHARMAP "y", 178
CHARMAP "z", 179
CHARMAP "Ñ", 180
CHARMAP "ñ", 181
CHARMAP "!", 182
CHARMAP "¡", 183
CHARMAP "?", 184
CHARMAP "¿", 185
CHARMAP ".", 186
CHARMAP ",", 187
CHARMAP "0", 188
CHARMAP "1", 189
CHARMAP "2", 190
CHARMAP "3", 191
CHARMAP "4", 192
CHARMAP "5", 193
CHARMAP "6", 194
CHARMAP "7", 195
CHARMAP "8", 196
CHARMAP "9", 197
CHARMAP " ", 198


; Esto debera estar en otro fichero hasta que se elimine -> fichero de textos
test_text:
DB "ABCDEFGHYJKLMNÑOP", ENDLINE
DB "QRSTUVWXYZabcdefg", ENDLINE
DB "hijklmnñopqrstuvw", ENDLINE
DB "xyz¡!¿?.,01234567", ENDLINE
DB "89 ", ENDTEXT



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
menu_title::

DB "", ENDLINE
DB "       AHMBAR", ENDLINE
DB "", ENDLINE
DB "      Start Game", ENDLINE
DB "      Controls", ENDLINE
DB "      Credits", ENDTEXT

; Pantalla de controles (centrado)
controls_text::
DB "", ENDLINE
DB "    CONTROLS", ENDLINE
DB "", ENDLINE
DB "  D-PAD: Move", ENDLINE
DB "  A: Jump", ENDLINE
DB "  B: Shoot", ENDLINE
DB "", ENDLINE
DB " Press A to return", ENDTEXT

; Pantalla de creditos
credits_screen::
DB "    CREDITS", ENDLINE
DB "", ENDLINE
DB " Sonia Mendivil", ENDLINE
DB " Miguel Beltra", ENDLINE
DB "Jaime Hernandez", ENDLINE
DB "", ENDLINE
DB "   Press A", ENDTEXT


;; ACT 1 Dialogs ;; 

act_1_scene_1_dialog::
	DB "Oh no, toxic frogs", 		ENDLINE
	DB "like my ex...", 			ENDLINE
	DB "I have to ", 		ENDLINE
	DB "reach the door. I", 		ENDLINE
	DB "need to gather all", 		ENDLINE
	DB "the ahmbar I can.",		ENDTEXT

act_1_scene_2_dialog::
	DB "OMG, the only way", 		ENDLINE
	DB "is going down...", 			ENDLINE
	DB "But how?", 		ENDTEXT

act_1_scene_3_dialog::
	DB "Easy...", 		ENDTEXT

act_1_scene_4_dialog::
	DB "Oh dear,", 		ENDLINE
	DB "here we go again.", ENDTEXT

act_1_scene_5_dialog::
	DB "Now I can", 		ENDLINE
	DB "jump twice.", 	ENDTEXT



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
	DB "hope it doesn not",		ENDLINE
	DB "live up to its",		ENDLINE
	DB "name today.",			ENDTEXT

act_2_scene_4_dialog::
	DB "The electrical",		ENDLINE
	DB "installations of",			ENDLINE
	DB "this place should",		ENDLINE
	DB "have been inspected",	ENDLINE
	DB "a long time ago.",		ENDLINE
	DB "It is a death trap.",	ENDTEXT

act_2_final_scene_dialog::
	DB "What the hell is",		ENDLINE
	DB "that monster!",			ENDLINE
	DB "Ahmbar corrupts",		ENDLINE
	DB "all living forms.",		ENDTEXT