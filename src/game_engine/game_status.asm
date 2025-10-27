SECTION "Game status", ROM0

check_lives::
    ; Verificar si llegó a 0 vidas para game over
    ld a, [wPlayerLives]
    cp 0
    ret nz
    
    ; Si llegó a 0 vidas, game over
    call game_over
    ret