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
| `sprites/`  | Sprites y tiles del jugador, enemigos, objetos... | `$8000` |
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

### 🧰 **utils/**
Funciones de propósito general utilizadas por todo el proyecto.

| Archivo | Propósito | Funciones principales |
|----------|------------|-----------------------|
| `utils.asm` | Utilidades genéricas | `memcpy`, `memset` |
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

Aquí podriamos poner el flujo del main si quereis
