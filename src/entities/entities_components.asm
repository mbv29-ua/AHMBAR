; =============================================================
; COMPONENTES EN WRAM0
; =============================================================

INCLUDE "entities/entities.inc"

; SECTION "Components - Sprites", WRAM0[SPR_BASE]
; component_sprite: DS CMP_SPRITES_TOTALBYTES

SECTION "Components - Physics", WRAM0[PHYS_BASE]
component_physics: DS CMP_PHYSICS_TOTALBYTES

SECTION "Components - Attributes", WRAM0[ATTR_BASE]
component_attr: DS CMP_ATTRIBUTES_TOTALBYTES
sentinel_attr: DS 1

SECTION "Components - Counters", WRAM0[CONT_BASE]
component_counters: DS CMP_COUNTERS_TOTALBYTES

SECTION "Components - Animation", WRAM0[ANIM_BASE]
component_anim: DS CMP_ANIMATION_TOTALBYTES

SECTION "Components - Jaime", WRAM0[$C500]
component_jaime: DS CMP_JAIME_TOTALBYTES

SECTION "Components - Miguel", WRAM0[$C600]
component_miguel: DS NUM_ENTITIES * MIGUEL_SIZE

SECTION "Components - Sonia", WRAM0[$C700]
component_sonia: DS NUM_ENTITIES * SONIA_SIZE

