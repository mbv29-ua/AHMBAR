# AHMBAR - TODO List y Mejoras del Juego

## PRIORIDAD CRÍTICA - Funcionalidades Básicas del Juego

### 1. Sistema de Audio
- [ ] **Añadir sonido de salto** - Reproducir cuando el jugador presiona A y salta
- [ ] **Añadir sonido de disparo** - Reproducir cuando el jugador dispara una bala
- [ ] **Implementar sistema de audio básico GB** - Driver de sonido para Game Boy
- [ ] **Añadir música de fondo** - Música para niveles y pantalla de título
- [ ] **Sonido de muerte del jugador** - Cuando pierde una vida
- [ ] **Sonido de colectar items** - Para corazones y power-ups
- [ ] **Sonido de cambio de nivel** - Cuando pasa por una puerta
- [ ] **Sonido de enemigo muerto** - Cuando el jugador mata un enemigo
- [ ] **Sonido de game over** - Para la pantalla final

### 2. HUD - Correcciones y Mejoras
- [ ] **ARREGLAR: Las balas no se quitan correctamente del HUD** - Bug actual
  - Verificar que `use_bullet()` actualiza correctamente el contador
  - Verificar que `render_bullets()` dibuja el número correcto
- [ ] **Añadir contador de score/puntos** - Mostrar puntuación en HUD
- [ ] **Añadir nivel actual** - Mostrar "NIVEL 1/2/3" en HUD
- [ ] **Añadir temporizador** (opcional) - Cronómetro o cuenta atrás
- [ ] **Mejorar diseño visual del HUD** - Mejor organización de elementos
- [ ] **Añadir icono de munición** - Sprite de bala junto al contador
- [ ] **Efecto visual cuando pierdes vida** - Flash o parpadeo de corazones

### 3. Sistema de Game Over
- [ ] **Crear pantalla de Game Over** - Nueva escena cuando vidas = 0
  - Mostrar mensaje "GAME OVER"
  - Mostrar estadísticas finales:
    - Nivel alcanzado
    - Puntuación total
    - Enemigos eliminados
    - Tiempo de juego
    - Items recolectados
- [ ] **Opción de reiniciar partida** - Presionar START para volver al inicio
- [ ] **Opción de volver al título** - Presionar SELECT para menú principal
- [ ] **Guardar mejor puntuación** (high score) - Persistir en SRAM
- [ ] **Animación de transición a Game Over** - Fade out o efecto visual

### 4. Sistema de Muerte y Respawn
- [ ] **IMPLEMENTAR: Función `game_over()`** - Actualmente es TODO en el código
  - Ubicación: `src/system/hud/hud_system.asm:247`
- [ ] **IMPLEMENTAR: Respawn por tiles mortales** - Cuando tocas spikes
  - Ubicación: `src/system/collision_manager/enviorement_interaction/check_collisions.asm:38`
- [ ] **Animación de muerte del jugador** - Sprite parpadeando o cayendo
- [ ] **Invulnerabilidad temporal tras respawn** - 2-3 segundos sin daño
- [ ] **Sonido de muerte** - Audio cuando pierdes vida
- [ ] **Sistema de checkpoints** - Respawn en último checkpoint, no en inicio

## PRIORIDAD ALTA - Mejoras de Gameplay

### 5. Sistema de Coleccionables
- [ ] **COMPLETAR: Lógica de coleccionables** - Actualmente parcial
  - Ubicación: `src/system/collision_manager/enviorement_interaction/check_collisions.asm:56`
- [ ] **Corazones recuperan vida** - +1 medio corazón al recogerlos
- [ ] **Munición extra** - Power-up que da más balas
- [ ] **Monedas/gemas para puntos** - Sistema de scoring
- [ ] **Power-ups especiales**:
  - Disparo rápido (reduce cooldown)
  - Doble salto
  - Invulnerabilidad temporal
  - Disparo triple
- [ ] **Efectos visuales al recoger** - Partículas o flash
- [ ] **Contador de coleccionables** - Mostrar X/Y items recolectados

### 6. Sistema de Enemigos
- [ ] **IA básica de enemigos** - Patrullar izquierda-derecha
- [ ] **Colisión de balas con enemigos** - Matar enemigos al dispararles
- [ ] **Colisión de jugador con enemigos** - Perder vida al tocarlos
- [ ] **Diferentes tipos de enemigos**:
  - Enemigo que camina
  - Enemigo que salta
  - Enemigo que dispara
  - Jefe de nivel (boss)
- [ ] **Sistema de vida de enemigos** - Algunos requieren múltiples disparos
- [ ] **Drop de items al matar enemigos** - Corazones, munición, puntos
- [ ] **Contador de enemigos eliminados** - Para estadísticas

### 7. Sistema de Balas - Mejoras
- [ ] **ARREGLAR: Dirección de spawn de balas** - Respecto a dirección del jugador
  - Ubicación: `src/entities/bullet/bullet_fire.asm:130`
- [ ] **OPTIMIZAR: Estado activo de balas como bit flag** - Usar 1 bit en vez de 1 byte
  - Ubicación: `src/entities/bullet/bullet_fire.asm:136`
- [ ] **Colisión de balas con paredes** - Destruir bala al chocar con tile sólido
- [ ] **Límite de balas en pantalla** - Máximo 3-5 balas simultáneas
- [ ] **Diferentes tipos de munición**:
  - Bala normal
  - Bala perforante (atraviesa enemigos)
  - Bala explosiva (área de daño)
- [ ] **Efecto visual de impacto** - Partículas cuando la bala choca

### 8. Sistema de Niveles
- [ ] **Completar Nivel 3** - Actualmente usa tiles del Nivel 1
- [ ] **Añadir más niveles** - Mínimo 5-6 niveles
- [ ] **Diseño de niveles más complejo** - Puzzles, plataformas móviles
- [ ] **Jefes al final de nivel** - Boss fights
- [ ] **Áreas secretas** - Bonus rooms con rewards
- [ ] **Transición entre niveles** - Animación al pasar por puerta
- [ ] **Pantalla de "Nivel Completado"** - Mostrar stats antes del siguiente nivel
- [ ] **Sistema de mundos** - Agrupar niveles por temática

## PRIORIDAD MEDIA - Polish y Calidad de Vida

### 9. Controles y Feel del Jugador
- [ ] **Ajustar velocidad de movimiento** - Tunear para mejor sensación
- [ ] **Ajustar altura de salto** - Tunear para mejor control
- [ ] **Coyote time** - Permitir salto unos frames después de dejar plataforma
- [ ] **Jump buffering** - Registrar input de salto antes de tocar suelo
- [ ] **Aceleración/desaceleración** - Movimiento más natural (no instantáneo)
- [ ] **Partículas al caminar** - Polvo bajo los pies
- [ ] **Animación de sprites del jugador**:
  - Caminar (frames de animación)
  - Saltar (pose en el aire)
  - Disparar (frame de disparo)
  - Morir (animación de muerte)

### 10. Efectos Visuales
- [ ] **Shake de cámara** - Cuando recibes daño o dispara jefe
- [ ] **Partículas**:
  - Al saltar
  - Al disparar
  - Al matar enemigo
  - Al recoger item
- [ ] **Flashes de feedback**:
  - Jugador parpadea al recibir daño
  - Enemigo parpadea al ser golpeado
  - Pantalla flash al morir
- [ ] **Mejor uso de paletas** - Cambiar colores por nivel/ambiente
- [ ] **Parallax scrolling** - Capas de fondo a diferente velocidad
- [ ] **Animaciones ambientales** - Agua, banderas, antorchas

### 11. UI y Menús
- [ ] **Menú de pausa** - Presionar START para pausar
  - Continuar
  - Reiniciar nivel
  - Volver al título
- [ ] **Menú principal mejorado** - No solo esperar botón A
  - Nueva partida
  - Continuar (si hay save)
  - Opciones
  - Créditos
- [ ] **Pantalla de opciones**:
  - Volumen de música
  - Volumen de SFX
  - Dificultad
- [ ] **Pantalla de créditos** - Mostrar equipo de desarrollo
- [ ] **Tutorial inicial** - Primeros segundos enseñan controles

### 12. Sistema de Guardado
- [ ] **Guardar progreso** - Save en SRAM
  - Nivel actual
  - Vidas restantes
  - Puntuación
  - Items recolectados
- [ ] **Múltiples slots de guardado** - 3 partidas guardadas
- [ ] **Auto-save** - Guardar automáticamente en checkpoints
- [ ] **Continuar desde último checkpoint** - Al morir o cerrar juego

## PRIORIDAD BAJA - Características Avanzadas

### 13. Mecánicas Avanzadas
- [ ] **Plataformas móviles** - Plataformas que se mueven
- [ ] **Trampolines** - Tiles que te impulsan hacia arriba
- [ ] **Interruptores y puertas** - Puzzles básicos
- [ ] **Escaleras** - Movimiento vertical
- [ ] **Agua** - Física de natación
- [ ] **Viento** - Empuja al jugador en una dirección
- [ ] **Teletransportadores** - Portales entre secciones
- [ ] **Bloques empujables** - Para puzzles
- [ ] **Bloques rompibles** - Destruir con disparo

### 14. Power-ups y Upgrades
- [ ] **Sistema de mejoras permanentes**:
  - Capacidad de munición aumentada
  - Más vidas máximas
  - Salto más alto
  - Velocidad aumentada
- [ ] **Armas alternativas** - Shotgun, láser, etc.
- [ ] **Items equipables** - Seleccionar arma con SELECT

### 15. Modos de Juego
- [ ] **Modo historia** - Campaña principal
- [ ] **Modo tiempo** - Completar niveles lo más rápido posible
- [ ] **Modo supervivencia** - Aguantar oleadas de enemigos
- [ ] **Modo boss rush** - Pelear todos los jefes seguidos
- [ ] **Modo difícil** - Menos vidas, enemigos más fuertes

### 16. Mejoras Técnicas
- [ ] **Optimizar uso de VRAM** - Reducir tiles duplicados
- [ ] **Optimizar entity system** - Mejorar performance con muchos entities
- [ ] **Sistema de pooling** - Reusar balas/enemigos sin reasignar
- [ ] **Mejor gestión de scroll** - Prevenir artefactos visuales
- [ ] **Debugging tools** - Modo debug con información en pantalla
- [ ] **Refactorizar código** - Limpiar TODOs y código comentado
- [ ] **Documentación del código** - Comentarios en español/inglés consistentes

### 17. Contenido Extra
- [ ] **Cutscenes** - Historia entre niveles
- [ ] **Sprites de enemigos variados** - Más variedad visual
- [ ] **Más tilesets** - Diferentes biomas (desierto, nieve, cueva, castillo)
- [ ] **NPCs** - Personajes que dan consejos o misiones
- [ ] **Mini-juegos** - Pequeños bonus games
- [ ] **Easter eggs** - Secretos ocultos en niveles

## BUGS CONOCIDOS A ARREGLAR

### 18. Corrección de Bugs
- [x] ~~HUD no se veía correctamente (Window tilemap conflict)~~ - ARREGLADO
- [x] ~~Faltaba `fireFrame0::` label~~ - ARREGLADO
- [x] ~~Door collision desactivada en nivel 2~~ - ARREGLADO
- [ ] **Las balas no se restan correctamente del HUD** - PENDIENTE
- [ ] **Dirección de spawn de balas incorrecta** - Comentado en código
- [ ] **Enemigos de prueba sin comportamiento** - Actualmente estáticos
- [ ] **Colisión con tiles mortales no mata al jugador** - TODO en código
- [ ] **Collectibles no dan beneficio** - TODO en código
- [ ] **Mejorar y crear una buena door collision** - TODO en codigo

## MEJORAS SUGERIDAS POR CATEGORÍA

### Feedback del Jugador
- Sonidos (salto, disparo, daño, muerte)
- Partículas visuales
- Screen shake
- Flashes de impacto
- Animaciones de sprites

### Progresión del Juego
- Sistema de puntuación
- Estadísticas (enemigos eliminados, tiempo, items)
- Checkpoints
- Guardado de progreso
- High scores

### Rejugabilidad
- Múltiples niveles bien diseñados
- Diferentes tipos de enemigos
- Power-ups variados
- Áreas secretas
- Modos de juego alternativos

### Accesibilidad
- Tutorial inicial
- Menú de pausa
- Opciones de dificultad
- Controles configurables (si es posible en GB)

---

## NOTAS DE DESARROLLO

### Prioridades Inmediatas (Sprint 1)
1. Arreglar sistema de balas en HUD
2. Implementar sonido de salto y disparo
3. Crear pantalla de Game Over básica
4. Implementar muerte del jugador y respawn

### Próximos Pasos (Sprint 2)
1. Completar sistema de coleccionables
2. Implementar IA básica de enemigos
3. Añadir colisión de balas con enemigos
4. Mejorar animaciones del jugador

### Futuro (Sprint 3+)
1. Más niveles
2. Jefes de nivel
3. Power-ups avanzados
4. Sistema de guardado
5. Música y efectos de sonido completos

---
