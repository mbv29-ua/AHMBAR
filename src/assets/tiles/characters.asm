SECTION "characters" , ROMX

Cowboy_Sprites::
    ; Bola negra (jugador)
    DB $00,$00,$3C,$3C,$7E,$7E,$FF,$FF
    DB $FF,$FF,$7E,$7E,$3C,$3C,$00,$00
Cowboy_Sprites_End::

Goal_Sprite::
    ; Cuadrado objetivo (meta del nivel)
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
Goal_Sprite_End::

Tile_Bullet::
    DB $00,$00,$18,$18,$7E,$7E,$FF,$FF
    DB $FF,$FF,$7E,$7E,$18,$18,$00,$00
Tile_Bullet_End::