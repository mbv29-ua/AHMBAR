DEF TILE_GROUP_MASK				EQU %01110000

DEF NO_SOLID_TILE 			 	EQU $00 ;   0 -  15
DEF SOLID_TILE 	  			 	EQU $10 ;  16 -  31
DEF WALK_BEHIND_TILE 		 	EQU $20 ;  32 -  47
DEF PLATFORM_TILE 			 	EQU $30 ;  48 -  63
DEF DOOR_TILE				 	EQU $40 ;  64 -  79
DEF COLLECTIBLE_TILE 			EQU $50 ;  80 -  95
DEF DEADLY_TILE 				EQU $60 ;  96 - 111
DEF SOLID_TILE_2	 			EQU $70 ; 112 - 127

DEF EMPTY_TILE 			        EQU $80 ;  tile $00 of the second bank -> $80
DEF AHMBAR_TILE 			    EQU $D8 ;  tile $88 of the second bank -> $D8
DEF BULLETBOX_TILE              EQU $D9 ;  tile $89 of the second bank -> $D9