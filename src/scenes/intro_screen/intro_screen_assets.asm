INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
SECTION "intro screen scene", ROM0

scene_intro_screen::
	call intro_scene_init

    

    .scroll:
        ld h, CMP_SPRIT_H 
        ld l, 0
        ld de, SPR_X 

        add hl, de 

        ld a, [hl]
        cp 168          ;; MAGICO HAY QUE PONER UNA CONSTANTE QUE SEA SOLO PARA ESTO
        jr nc,  .nextScreen


        call update_all_entities_positions
        ld hl, rSCX
        inc [hl]
        call wait_a_frame
        jr .scroll
        

        .nextScreen:
        call menu_start_init

        call wait_until_start_pressed
        
        call fadeout
        ret


intro_scene_init::
    call screen_off
    call clean_OAM
    call clean_bg_map
    call copy_DMA_routine
    call Load_letras_intro_Tiles
    call Load_start_Map
    call init_palettes_by_default
    call man_entity_init
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
call Load_intro_Tiles
call Load_intro_Map
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

    ld hl, letras_inicio
    ld de, VRAM0_START + 128 * TILE_SIZE 
    ld bc, letras_inicio.end - letras_inicio
    call memcpy_65536
    ret

Load_start_Map::
    ld hl, mapa_start
    ld de, BG_MAP_START
    ld bc, mapa_start.end - mapa_start
    call memcpy_65536
    ret







init_personaje_animacion::
	;; Example of initializing an enemy (valid for an entity)
	call man_entity_alloc ; Returns l=entity index
	ld b, $48 ; Y coordinate
	ld c, $14  ; X coordinate
	ld d, $05 ; tile
	ld e, 0   ; tile properties
	call set_entity_sprite
	ld b, 0 ; vy 
	;ld c,  0 ; vx
	ld d,  1 ; vx
	call set_entity_physics
    ret