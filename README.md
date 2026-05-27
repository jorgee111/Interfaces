# 🌿 EcoScanner Adventures

Aplicación móvil gamificada desarrollada en **Flutter** para fomentar la conciencia medioambiental mediante la exploración interactiva de espacios naturales como **Faunia**.

## 📱 Descripción

EcoScanner Adventures convierte la visita a espacios naturales en una aventura educativa. Los usuarios pueden escanear elementos del entorno, descubrir criaturas, completar misiones diarias y participar en trivias ecológicas para ganar recompensas.

## ✨ Funcionalidades principales

- **🏠 Dashboard** — Panel principal con resumen de progreso, misiones activas y accesos rápidos
- **🗺️ Mapa interactivo** — Mapa real de Faunia con zonas de exploración
- **📷 Escáner** — Simulación de escaneo de elementos naturales con fotos reales
- **🦎 Criaturas** — Colección de criaturas descubiertas durante las aventuras
- **🎯 Misiones diarias** — Desafíos diarios para mantener el engagement
- **🧠 Trivia ecológica** — Preguntas sobre medioambiente y naturaleza
- **🏪 Marketplace** — Tienda de recompensas canjeables (palomitas, entradas, etc.)
- **🛡️ Patrulla ecológica** — Actividades de conservación
- **👤 Perfil** — Estadísticas del usuario y personalización

## 🏗️ Arquitectura del proyecto

```
lib/
├── main.dart              # Punto de entrada y navegación principal
├── models/                # Modelos de datos (Adventure, Creature, Mission, etc.)
├── providers/             # Estado global con Provider (EcoState)
├── screens/               # Pantallas de la aplicación
├── theme/                 # Tema, colores y animaciones
└── widgets/               # Componentes reutilizables
```

## 🛠️ Tecnologías

- **Flutter** (SDK ^3.11.1)
- **Provider** — Gestión de estado
- **Google Fonts** — Tipografía personalizada
- **SharedPreferences** — Persistencia local
- **Confetti** — Animaciones de celebración

## 🚀 Cómo ejecutar

1. Asegúrate de tener [Flutter instalado](https://docs.flutter.dev/get-started/install)
2. Clona el repositorio:
   ```bash
   git clone https://github.com/jorgee111/Interfaces.git
   cd Interfaces
   ```
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## 👥 Autor

Desarrollado como proyecto de la asignatura de **Interfaces de Usuario**.
