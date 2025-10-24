INCLUDE "scenes/scene_constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

SECTION "Scene address", WRAM0[$CAF0]

current_scene_info_address: DS 2

SECTION "Scene manager", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine stops the gravity to all 
;; to the L-th entity.if it is grounded
;;
;; INPUT:
;;		HL: Address of scene.conf
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC, DE, HL

load_scene::
    call save_current_scene_info_address
    
    ; Turn off the screen
    call screen_off

    ; Clean routines
    call clean_OAM
    call copy_DMA_routine
    call man_entity_init

    ; Load assets
    call load_cowboy_sprites
    call load_bullet_sprites

    call load_tileset
    call load_level_map
    call set_initial_scroll
    call init_player
    ; call init_enemigos_prueba
    call init_palettes_by_default

    ; Load scene variables
    ;call init_counterload_scene
    ;call init_tile_animation        ; Initialize fire animation system
    call init_hud                   ; Initialize HUD (lives & bullets)
    
    ; Turn on the screen
    call enable_vblank_interrupts
    call enable_screen
    call screen_bg_on
    call screen_obj_on
    call scree_hud_on
    call screen_window_dialog
    call screen_on
ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine saves the current scene information
;; address
;;
;; INPUT:
;;      HL: Address of the scene
;; OUTPUT:
;;      -   
;; WARNING: Destroys A and DE

save_current_scene_info_address::
    ld de, current_scene_info_address
    
    ld a, h
    ld [de], a
    inc de
    
    ld a, l
    ld [de], a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets the current scene information
;; address
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      HL: Current scene information   
;; WARNING: Destroys A

get_current_scene_info_address::
    ld hl, current_scene_info_address
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the tileset using 
;; the current scene information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys BC, DE

load_tileset::
	;; We compute the destiny -> VRAM0_START+SCENE_TILESET_OFFSET
    call get_current_scene_info_address ; in hl
	ld de, SCENE_TILESET_OFFSET
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]

	ld hl, VRAM0_START
    add hl, de
    ld d, h
    ld e, l

    call get_current_scene_info_address; in hl
    ld bc, SCENE_TILESET_SIZE
    add hl, bc
    ld b, [hl]
    inc hl
    ld c, [hl]


	;  We obtain the memory address HL where the tileset is 
	;; from [HL]
    push bc
    call get_current_scene_info_address ; in hl
    ld bc, SCENE_TILESET
	add hl, bc
	ld a, [hl+]
	ld l, [hl]
	ld h, a
	pop bc

    call memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the tilemap using 
;; the current scene information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys BC, DE

load_level_map::
	;  We obtain the memory address HL where the tilemap is from [HL]
    call get_current_scene_info_address ; in hl
    ld bc, SCENE_TILEMAP
	add hl, bc
	ld a, [hl+]
	ld l, [hl]
	ld h, a

    ld de, BG_MAP_START
    ld bc, BG_MAP_SIZE

    call memcpy_65536

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the initial scroll using 
;; the current scene information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE

set_initial_scroll::
	call get_current_scene_info_address ; in hl
    ld d, 0
    ld e, SCENE_STARTING_SCREEN_SCROLL_Y
    add hl, de
    ld a, [hl]
    ldh [rSCY], a

    ld e, (SCENE_STARTING_SCREEN_SCROLL_X-SCENE_STARTING_SCREEN_SCROLL_Y)
    add hl, de
    ld a, [hl]
    ldh [rSCX], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine initializes the player using 
;; the current scene information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC, DE and HL

init_player::
    call get_current_scene_info_address ; in hl
    ld d, 0
    ld e, SCENE_PLAYER_STARTING_Y
    add hl, de
    ld b, [hl] ; Y coordinate

    ld e, SCENE_PLAYER_STARTING_X-SCENE_PLAYER_STARTING_Y
    add hl, de
    ld c, [hl]  ; X coordinate

    call man_entity_alloc ; Deja en l el indice
    ld d, TILE_COWBOY ; tile
    ld e, 0           ; tile properties
    call set_entity_sprite

    ld h, CMP_ATTR_H
    ld l, ATT_ENTITY_FLAGS
    set E_BIT_GRAVITY, [hl]

    ld l, PHY_FLAGS
    set PHY_FLAG_GROUNDED, [hl]
    res PHY_FLAG_JUMPING, [hl]

    ld hl, wPlayerDirection
    set 0, [hl]

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine advances to the next scene using 
;; the current scene information
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      HL: Address of next scene   
;; WARNING: Destroys A, BC and HL

get_next_scene::
    call get_current_scene_info_address ; in hl
    ld bc, SCENE_NEXT_SCENE
    add hl, bc
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    ret