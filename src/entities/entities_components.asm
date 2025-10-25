; =============================================================
; COMPONENTES EN WRAM0
; =============================================================

INCLUDE "entities/entities.inc"

SECTION "Components - Sprites", WRAM0[SPR_BASE]
Player::
    .wPlayerY:          DS 1
    .wPlayerX:          DS 1
    .tile:              DS 1
    .wDrawAttributes:   DS 1

component_sprite: 	DS CMP_SPRITES_TOTALBYTES - 4
DS (PHYS_BASE-SPR_BASE)-CMP_SPRITES_TOTALBYTES


SECTION "Components - Physics", WRAM0[PHYS_BASE]
component_physics: 	DS CMP_PHYSICS_TOTALBYTES
DS (ATTR_BASE-PHYS_BASE)-CMP_PHYSICS_TOTALBYTES


SECTION "Components - Attributes", WRAM0[ATTR_BASE]
component_attr: 	DS CMP_ATTRIBUTES_TOTALBYTES
sentinel_attr: 		DS 1
DS (CONT_BASE-ATTR_BASE)-CMP_ATTRIBUTES_TOTALBYTES-1


SECTION "Components - Counters", WRAM0[CONT_BASE]
component_counters: DS CMP_COUNTERS_TOTALBYTES
DS (ANIM_BASE-CONT_BASE)-CMP_COUNTERS_TOTALBYTES


SECTION "Components - Animation", WRAM0[ANIM_BASE]
component_anim: 	DS CMP_ANIMATION_TOTALBYTES
DS (JAIME_BASE-ANIM_BASE)-CMP_ANIMATION_TOTALBYTES


SECTION "Components - Jaime", WRAM0[JAIME_BASE]
component_jaime: 	DS CMP_JAIME_TOTALBYTES
DS (MIGUEL_BASE-JAIME_BASE)-CMP_JAIME_TOTALBYTES


SECTION "Components - Miguel", WRAM0[MIGUEL_BASE]
component_miguel: 	DS CMP_MIGUEL_TOTALBYTES
DS (SONIA_BASE-MIGUEL_BASE)-CMP_MIGUEL_TOTALBYTES


SECTION "Components - Sonia", WRAM0[SONIA_BASE]
component_sonia: 	DS CMP_SONIA_TOTALBYTES
DS (CMP_END-SONIA_BASE)-CMP_SONIA_TOTALBYTES
