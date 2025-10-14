INCLUDE "constants.inc"

SECTION "sys", ROM0

clean_OAM::
    ld hl, OAM_START
    ld b, OAM_SIZE
    call memreset_256
    ret

wait_vblank::
    ld hl, rLY
    ld a, START_VBLANK
    .loop
        cp [hl]
        jr nz, .loop
    ret

screen_off::
    di
    call wait_vblank
    ld hl, rLCDC
    res BIT_PPU_ENABLES, [hl]
    ei
    ret

screen_on::
    ld hl, rLCDC
    set BIT_PPU_ENABLES, [hl]
    ret