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

component_sprite: 	DS CMP_SPRITES_TOTALBYTES-4
DS (PHYS_BASE-SPR_BASE)-CMP_SPRITES_TOTALBYTES


SECTION "Components - Physics", WRAM0[PHYS_BASE]
PlayerSpeed::
    .wY:     DS 1
    .wSubY:  DS 1
    .wX:     DS 1
    .wSubX:  DS 1

component_physics: 	DS CMP_PHYSICS_TOTALBYTES-4
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
DS (AABB_BASE-ANIM_BASE)-CMP_ANIMATION_TOTALBYTES


SECTION "Components - AABB", WRAM0[AABB_BASE]
component_aabb: 	DS CMP_AABB_TOTALBYTES
DS (AI_BASE-AABB_BASE)-CMP_AABB_TOTALBYTES


SECTION "Components - AI", WRAM0[AI_BASE]
component_miguel: 	DS CMP_AI_TOTALBYTES
DS (SONIA_BASE-AI_BASE)-CMP_AI_TOTALBYTES


SECTION "Components - Sonia", WRAM0[SONIA_BASE]
component_sonia: 	DS CMP_SONIA_TOTALBYTES
DS (CMP_END-SONIA_BASE)-CMP_SONIA_TOTALBYTES
