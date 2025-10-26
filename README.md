# AHMBAR
## RA project


## Style Notes
- Snake Case
En este documento describiremos la organización del proyecto y el propósito de cada carpeta y archivo.  
> 📄 *Actualízalo cuando se añadan o modifiquen módulos para mantener la documentación al día.*

---
## 📁 Estructura General

AHMBAR/src/  
│  
├── assets/  
│ ├── sprites/ # Sprites y tiles (VRAM $8000)  
│ ├── tilemaps/ # Mapas de tiles (VRAM $9800)  
│ └── sounds/ # Efectos de sonido y música  
│  
├── game-engine/  
│ ├── physics/ # Lógica de físicas (gravedad, colisiones, etc.)  
│ └── scenes/ # Control de escenas (scene1, scene2, scene3…)  
│  
├── entity-manager/ # Gestión de entidades del juego  
│ └── entity_manager.asm  
│  
├── scenes/ # Datos de los escenarios del juego  
│ └── scene1/scene_1_conf.asm  
│ └── scene2/scene_2_conf.asm  
│  
├── utils/  
│ ├── utils.asm # Funciones generales (memcpy, memset)  
│ ├── sys.asm # Funciones del sistema (wait_vblank, clearOAM, lcd_on/off)  
│ ├── joypad.asm # Lectura de botones y gestión del buffer  
│ └── joypad.inc # Constantes  
│  
├── constants.inc # Constantes globales (propósito general)  
├── header.asm # Cabeceras e inicialización  
└── main.asm # Punto de entrada del juego (call init, call scene.start)

---

### 📦 Distribución en memoria (WRAM0)

| Dirección Base | Componente | Tamaño por entidad | Descripción                                 |
| -------------- | ---------- | ------------------ | ------------------------------------------- |
| `$C000`        | **SPR**    | 4 bytes            | Datos de sprite (posición, tile, atributos) |
| `$C100`        | **PHYS**   | 4 bytes            | Física (velocidades, estado, flags)         |
| `$C200`        | **ATTR**   | 4 bytes            | Atributos generales                         |
| `$C300`        | **CONT**   | 4 bytes            | Contadores                                  |
| `$C400`        | **ANIM**   | 4 bytes            | Animación o estados visuales                |
| `$C500`        | **JAIME**  | 4 bytes            | Componente auxiliar (libre)                 |
| `$C600`        | **MIGUEL** | 4 bytes            | Componente auxiliar (libre)                 |
| `$C700`        | **SONIA**  | 4 bytes            | Componente auxiliar (libre)                 |

--- 

## 🧱 Detalle de Módulos

### 🎨 **assets/**
Contiene todos los recursos del juego.

| Carpeta     | Descripción                                       | VRAM    |
| ----------- | ------------------------------------------------- | ------- |
| `tiles/`    | Sprites y tiles del jugador, enemigos, objetos... | `$8000` |
| `tilemaps/` | Mapas de fondo y niveles                          | `$9800` |
| `sounds/`   | Efectos y música                                  | —       |

---

### ⚙️ **game-engine/**
Motor principal del juego, encargado de las físicas y el flujo entre escenas.



---

### 👾 **entity-manager/**
Maneja todas las entidades del juego (jugador, enemigos, objetos, etc.).

- `entity_manager.asm` →  
  - Crea y destruye entidades  
  - Recorre entidades activas (`for each entity`)  
  - Controla componentes (sprite, físicas...)

---

### 🎥 **scenes/**
Contiene la información de cada una de las escenas y algunas rutinas para animar escenas particulares.

- `sceneN/scene_N_conf.asm` → Contiene la información básica acerca de la escena:

| Etiqueta | Tamaño | Propósito |
|----------|----|------------|
| `.starting_y` | 1 byte | Coordenada Y inicial del jugador |
| `.starting_x` | 1 byte | Coordenada X inicial del jugador |
| `.initial_scroll_y` | 1 byte | Desplazamiento de la pantalla en el eje Y |
| `.initial_scroll_x` | 1 byte | Desplazamiento de la pantalla en el eje X |
| `.tileset` | 2 byte (dirección) | Conjunto de tiles asociados a la escena |
| `.tilset_size` | 2 byte | Tamaño del tileset en la VRAM |
| `.tileset_offset` | 2 byte | Desplazamiento del tileset en la VRAM |
| `.tilemap` | 2 byte (dirección) | Mapa asociado a la escena |
| `.goal_y` | 1 byte | Coordenada y del objetivo |
| `.goal_x` | 1 byte | Coordenada x del objetivo |
| `.next_scene` | 2 bytes (dirección) | Siguiente escena |

⚠️ Es muy importante que los datos se encuentren en este mismo orden. De lo contrario, podrían producirse comportamientos inesperados.

---

### 🧰 **utils/**
Funciones de propósito general utilizadas por todo el proyecto.

| Archivo | Propósito | Funciones principales |
|----------|------------|-----------------------|
| `utils.asm` | Utilidades genéricas | `memcpy`, `memset`, `memreset` |
| `sys.asm` | Rutinas del sistema | `wait_vblank`, `clearOAM`, `lcd_on`, `lcd_off` |
| `joypad.asm` | Entrada del jugador | Lectura y buffer del joypad |

---
### ⚙️ **constants.inc**
Archivo de **constantes globales** (máscaras de bits, direcciones, tamaños, etc.).

---
### 🚀 **main.asm**
Archivo principal del juego.

```asm
call init
call scene.start
```

---
### 🎮 **Instrucciones para añadir tus propios escenarios**

Necesitas únicamente tres elementos:
1. Un tileset, que puedes diseñar con Tile Designer (GB).
2. Un tilemap, que puedes diseñar con Map Builder (GB).
3. Un fichero `scene_N_conf.asm` con los datos del escenario.

⚠️ Tienes dos formas para poder acceder a tu escenario en el juego:
1. Editar la rutina `start_game` que se encuentra en `src/game_engine/game_start.asm` (ideal para probarlo).
2. Editar el fichero `scene_N_conf.asm` del escenario previo al tuyo. 
