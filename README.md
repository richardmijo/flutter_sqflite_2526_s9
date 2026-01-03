# Flutter Clean Architecture - Login & FCM

Este proyecto es una demostración de una aplicación Flutter construida bajo los principios de **Clean Architecture**. Actualmente implementa un sistema de autenticación (Login) contra un API REST local y gestión de notificaciones Push con Firebase Cloud Messaging (FCM).

Próximamente se integrará almacenamiento local con **SQLite**.

## 🚀 Características

- **Clean Architecture**: Separación estricta de capas (Presentation, Domain, Data).
- **Gestión de Estado**: Uso de `Provider`.
- **Inyección de Dependencias**: Configuración manual en `main.dart` sin librerías externas complejas.
- **Autenticación JWT**: Login y persistencia del token.
- **Notificaciones Push**: Integración con Firebase Messaging para recibir alertas en segundo plano y primer plano.
- **Sincronización de Token**: Actualización automática del token FCM en el backend tras el login.

## 🛠️ Tecnologías

- Flutter & Dart
- `provider`: Manejo de estado.
- `http`: Peticiones REST.
- `firebase_messaging`: Notificaciones Push.
- `shared_preferences`: Persistencia de datos simple (Token).
- `dartz`: Programación funcional (Either) para manejo de errores.
- `equatable`: Comparación de objetos.

## 📂 Estructura del Proyecto

```
lib/
├── core/                  # Componentes compartidos (Errores, Constantes)
├── features/
│   ├── auth/              # Módulo de Autenticación
│   │   ├── domain/        # Entidades y Casos de Uso
│   │   ├── data/          # Modelos y Data Sources
│   │   └── presentation/  # UI y Providers
│   └── notifications/     # Módulo de Notificaciones
└── main.dart              # Punto de entrada e Inyección de Dependencias
```

## ⚙️ Configuración y Ejecución

### 1. Requisitos Previos
- Flutter SDK instalado.
- Un servidor backend local corriendo (ver `FLUTTER_HANDOFF.md` para especificaciones del API).

### 2. Configuración de Firebase
Este proyecto requiere archivos de configuración de Firebase que **NO** están incluidos en el repositorio por seguridad.

- **Android**: Coloca tu `google-services.json` en `android/app/`.
- **iOS**: Coloca tu `GoogleService-Info.plist` en `ios/Runner/`.

### 3. Configuración de Red
Edita `lib/core/constants/constants.dart` para apuntar a la IP de tu backend:

```dart
// Ejemplo para dispositivo físico en la misma red Wi-Fi
static const String baseUrl = 'http://192.168.1.X:3000/api';
```

### 4. Ejecutar
```bash
flutter pub get
flutter run
```

## 📝 Roadmap
- [x] Login & Auth Provider
- [x] Configuración de Firebase y FCM
- [ ] Implementación de SQLite (Próximamente)
