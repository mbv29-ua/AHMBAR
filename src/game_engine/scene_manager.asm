INCLUDE "scenes/scene_constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"

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
    ; Turn off the screen
    push hl
    call screen_off

    ; Clean routines
    call clean_OAM
    call copy_DMA_routine
    call man_entity_init

    ; Load assets
    call load_cowboy_sprites
    call load_bullet_sprites

    pop hl
    call load_tileset
    call load_level_map
    call set_initial_scroll
    call init_player
    call init_palettes_by_default

    ; Load scene variables
    ;call init_counter
    ;call init_tile_animation        ; Initialize fire animation system
    ;call init_hud                   ; Initialize HUD (lives & bullets)
    
    ; Turn on the screen
    call enable_vblank_interrupts
    call enable_screen
    call screen_on
ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the tileset
;;
;; INPUT:
;;		HL: Address of the scene
;; OUTPUT:
;;		-	
;; WARNING: Destroys BC, DE

load_tileset::
	;; We compute the destiny -> VRAM0_START+SCENE_TILESET_OFFSET
	push hl
	ld de, SCENE_TILESET_OFFSET
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]

	ld hl, VRAM0_START
    add hl, de
    ld d, h
    ld e, l
    pop hl

    push hl
    ld bc, SCENE_TILESET_SIZE
    add hl, bc
    ld a, [hl+]
    ld b, [hl]
    ld c, a
    pop hl


    push hl
	;  We obtain the memory address HL where the tileset is 
	;; from [HL]
    push bc
    ld bc, SCENE_TILESET
	add hl, bc
	ld a, [hl+]
	ld b, a
	ld h, [hl]
	ld l, b
	pop bc


    call memcpy_65536

    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the tilemap
;;
;; INPUT:
;;		HL: Address of the scene
;; OUTPUT:
;;		-	
;; WARNING: Destroys BC, DE

load_level_map::

    push hl
	;  We obtain the memory address HL where the tilemap is 
	;; from [HL]
    ld bc, SCENE_TILEMAP
	add hl, bc
	ld a, [hl+]
	ld b, a
	ld h, [hl]
	ld l, b

    ld de, BG_MAP_START
    ld bc, BG_MAP_SIZE

    call memcpy_65536

    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the initial scroll
;;
;; INPUT:
;;		HL: Address of the scene
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE

set_initial_scroll::
	push hl
    ld d, 0
    ld e, SCENE_STARTING_SCREEN_SCROLL_Y
    add hl, de
    ld a, [hl]
    ldh [rSCY], a

    ld e, (SCENE_STARTING_SCREEN_SCROLL_X-SCENE_STARTING_SCREEN_SCROLL_Y)
    add hl, de
    ld a, [hl]
    ldh [rSCX], a

    pop hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine initializes the player
;;
;; INPUT:
;;		HL: Address of the scene
;; OUTPUT:
;;		-	
;; WARNING: Destroys A and DE

init_player::
	push hl

	push hl
    call man_entity_alloc ; Deja en l el indice
    ld a, l
    pop hl

    ld d, 0
    ld e, SCENE_PLAYER_STARTING_Y
    add hl, de
    ld b, [hl] ; Y coordinate

    ld e, SCENE_PLAYER_STARTING_X-SCENE_PLAYER_STARTING_Y
    add hl, de
    ld c, [hl]  ; X coordinate

    ld d, TILE_COWBOY ; tile
    ld e, 0   ; tile properties

    ld l, a
    call set_entity_sprite

    ld hl, wPlayerDirection
    set 0, [hl]

    ld h, CMP_ATTR_H
    ld l, ATT_ENTITY_FLAGS
    set E_BIT_GRAVITY, [hl]

    ld l, PHY_FLAGS
    set PHY_FLAG_GROUNDED, [hl]
    res PHY_FLAG_JUMPING, [hl]

    pop hl
    ret