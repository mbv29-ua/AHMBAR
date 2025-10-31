INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"

SECTION "intro screen scene", ROM0

scene_intro_screen::
    call wait_vblank
    call set_black_palette
    call intro_load_fonts

    call show_credits
    call show_intro_text
    call intro_animation_scene
    ret



show_credits::
    di
    call set_black_palette
    ld hl, credits
    call write_super_extended_dialog
    ei
    call wait_until_A_pressed
    call screen_off
    call clean_bg_map
    call screen_on
    ret


show_intro_text::
    call set_black_palette
    ld hl, intro_text
    call write_super_extended_dialog
    ld b, 20
    call wait_x_frames
    call fade_to_black
    call fade_to_black
    call fade_to_black

    call screen_off
    call clean_bg_map
    call screen_on
    ret

intro_animation_scene::
    call intro_scene_init

    .scroll:
        ld a, [rSCX]
        ld b, a
        and %00000010
        ld hl, Player.tile
        jr z, .run_tile_2
            ld [hl], PLAYER_WALKING_TILE_1
            jr .continue
        .run_tile_2:
            ld [hl], PLAYER_WALKING_TILE_2
        ld hl, Player.wPlayerX
        inc [hl]

        .continue:
        ld a, b
        cp 168          ;; MAGICO HAY QUE PONER UNA CONSTANTE QUE SEA SOLO PARA ESTO
        jr nc,  .nextScreen


        ld hl, rSCX
        inc [hl]
        call wait_a_frame
        jr .scroll
        

        .nextScreen:
            call menu_start_init
            ld hl, rSCX
            ld [hl], 0
            call wait_until_start_pressed
        
            call fadeout
        ret

    
intro_load_fonts::
    call screen_off
    call clean_OAM
    call clean_bg_map
    call load_fonts
    call screen_on
    ret


intro_scene_init::
    call screen_off
    call clean_OAM
    call clean_bg_map
    call copy_DMA_routine
    call init_palettes_by_default
    call man_entity_init
    call Load_intro_Tiles
    call Load_intro_Map
    call load_player_tiles
    call init_personaje_animacion
    call enable_vblank_interrupts
    call screen_obj_on
    call screen_on
    ret

menu_start_init::
    call screen_off
    call clean_OAM
    call clean_bg_map    
    call init_palettes_by_default
    call Load_letras_intro_Tiles
    call Load_start_Map

    ld hl, Player.wPlayerY
    ld [hl], $50
    ld hl, Player.wPlayerX
    ld [hl], $10

    call enable_vblank_interrupts
    call screen_obj_on
    call screen_on
    ret

Load_intro_Tiles::
    ; Cargar tiles desde block.asm
    ld hl, intro_tiles
    ld de, VRAM0_START + 128 * TILE_SIZE 
    ld bc, intro_tiles.end - intro_tiles
    call memcpy_65536
    ret


Load_intro_Map::
    ld hl, intro_mapa
    ld de, BG_MAP_START
    ld bc, intro_mapa.end - intro_mapa
    call memcpy_65536
    ret

Load_letras_intro_Tiles::
    ld hl, city_street
    ld de, VRAM0_START + 128 * TILE_SIZE 
    ld bc, city_street.end - city_street
    call memcpy_65536
    ret

Load_start_Map::
    ld hl, mapa_start
    ld de, BG_MAP_START
    ld b, 20
    ld c, 18
    call animation_window
    ret

init_personaje_animacion::
	;; Example of initializing an enemy (valid for an entity)
	call man_entity_alloc ; Returns l=entity index
	ld b, $80 ; Y coordinate
	ld c, $20  ; X coordinate
	ld d, PLAYER_WALKING_TILE_1 ; tile
	ld e, 0   ; tile properties
	call set_entity_sprite
	ld b, 0 ; vy 
	;ld c,  0 ; vx
	ld d,  1 ; vx
	call set_entity_physics
    ret