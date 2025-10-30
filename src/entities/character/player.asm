INCLUDE "entities/entities.inc"
INCLUDE "constants.inc"


SECTION "Player variables", WRAM0
wPowerupDoubleJump:: ds 1
wCounterJump:: ds 1
SECTION "Character Sprites", ROM0


;; QUITAR CONSTANTES MAGICAS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the bullet sprite in the 
;; VRAM.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_cowboy_sprites::
    ; Cargar sprite de la bola negra (jugador)
    ld hl, Cowboy_Sprites
    ld de, VRAM0_START + TILE_COWBOY * TILE_SIZE
    ld bc, Cowboy_Sprites_End - Cowboy_Sprites
    call memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enemy_damage
;;; Called when player collides with enemy
;;; Loses 1 life and activates cooldown
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enemy_damage::
    ; Activar cooldown de 60 frames (1 segundo)
    ld a, 60
    ld [wSpikeCooldown], a

    ; Perder 1 vida
    ld hl, wPlayerLives
    ;ld a, [hl]
    ;or a
    ;ret z  ; Si ya está en 0, no hacer nada

    dec [hl]

    ; Marcar que HUD necesita actualizarse
    ld a, 1
    ld [wHUDNeedsUpdate], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the player tiles in the 
;; VRAM.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_player_tiles::
    ; Cargar sprite de la bola negra (jugador)
    ld hl, player_beta_tiles
    ld de, VRAM0_START + PLAYER_WALKING_TILE_1 * TILE_SIZE
    ld  b, player_beta_tiles.end - player_beta_tiles.start
    call memcpy_256
    ret