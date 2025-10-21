INCLUDE "entities/entities.inc"

SECTION "Render Entities", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; render_entity_to_oam
;; Copia un sprite de entidad a OAM
;; Input: de = indice de entidad (apuntando a ATTR)
;; Destroys: a, hl, bc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_entity_to_oam::
    ; Verificar si la entidad esta libre o es sentinel
    ld a, [de]
    bit E_BIT_FREE, a
    ret nz              ; Si esta libre, no renderizar
    cp ENTITY_CMP_SENTINEL
    ret z               ; Si es sentinel, no renderizar

    ; Obtener indice de la entidad
    ld a, e
    sub ATTR_BASE & $FF
    srl a
    srl a               ; a = indice * 4 / 4 = indice

    ; Calcular direccion OAM: OAM_START + (indice * 4)
    sla a
    sla a               ; a = indice * 4
    ld l, a
    ld h, $FE           ; hl = $FE00 + (indice * 4)

    ; Cargar datos del sprite desde componente SPRIT
    ld a, e
    ld d, CMP_SPRIT_H
    ld e, a

    ; Copiar Y
    ld a, [de]
    ld [hl+], a

    ; Copiar X
    inc e
    ld a, [de]
    ld [hl+], a

    ; Copiar Tile ID
    inc e
    ld a, [de]
    ld [hl+], a

    ; Copiar Attributes
    inc e
    ld a, [de]
    ld [hl], a

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; render_all_entities
;; Renderiza todas las entidades activas a OAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
render_all_entities::
    ld hl, render_entity_to_oam
    call man_entity_for_each
    ret
