INCLUDE "constants.inc"

SECTION "Level 2 Scene", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of the scene 2.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scene_2_enemy_spawner::
	call load_fly_tiles
	call load_darkfrog_tiles

	; Primer enemigo volador - lado izquierdo
	ld  b, $40
	ld  c, $20
	ld hl, basic_fly
	call enemy_spawn

	; Segundo enemigo volador - izquierda media
	ld  b, $60
	ld  c, $38
	ld hl, basic_fly
	call enemy_spawn

	; Tercer enemigo volador - centro
	ld  b, $50
	ld  c, $50
	ld hl, basic_fly
	call enemy_spawn

	; Cuarto enemigo volador - derecha media
	ld  b, $70
	ld  c, $68
	ld hl, basic_fly
	call enemy_spawn

	; Quinto enemigo volador - lado derecho
	ld  b, $48
	ld  c, $80
	ld hl, basic_fly
	call enemy_spawn

	; Primera rana - izquierda
	ld  b, $88
	ld  c, $30
	ld hl, jumping_frog
	call enemy_spawn

	; Segunda rana - derecha
	ld  b, $88
	ld  c, $70
	ld hl, jumping_moving_frog
	call enemy_spawn

	ret