# Guía de Implementación para Flutter

Esta guía contiene todo lo necesario para conectar tu aplicación Flutter con este backend.

## 🌐 Configuración Base

- **Base URL**: 
  - Emulador Android: `http://10.0.2.2:3000/api`
  - Simulador iOS / Web: `http://localhost:3000/api`
  - Dispositivo Físico: `http://TU_IP_LOCAL:3000/api` (Asegúrate de estar en la misma red Wi-Fi)

## 🔐 Autenticación (JWT)

### 1. Registro
**Endpoint**: `POST /auth/register`
**Body**:
```json
{
  "username": "usuario1",
  "password": "password123"
}
```
**Respuesta (201)**:
```json
{
  "message": "Usuario registrado exitosamente",
  "user": { "id": 1, "username": "usuario1", ... }
}
```

### 2. Login
**Endpoint**: `POST /auth/login`
**Body**:
```json
{
  "username": "usuario1",
  "password": "password123"
}
```
**Respuesta (200)**:
```json
{
  "message": "Login exitoso",
  "token": "eyJhbGciOiJIUzI1NiIsIn...",
  "user": { "id": 1, "username": "usuario1" }
}
```
> **Importante**: Guarda el `token` usando `flutter_secure_storage` o `SharedPreferences` para usarlo en futuras peticiones.

## 🔔 Notificaciones Push (Firebase)

### Pasos en Flutter:
1.  Implementar `firebase_messaging`.
2.  Obtener el token del dispositivo: `FirebaseMessaging.instance.getToken()`.
3.  Enviar este token al backend **después** de hacer login.

**Endpoint**: `POST /notifications/token`
**Headers**:
```
Authorization: Bearer <TU_TOKEN_JWT>
Content-Type: application/json
```
**Body**:
```json
{
  "token": "fcm_token_xyz...",
  "platform": "android" 
}
```
*(Platform puede ser 'android', 'ios' o 'web')*

## 📄 Documentación Interactiva (Swagger)
Si estás corriendo el backend localmente, visita:
`http://localhost:3000/api-docs`
Aquí puedes probar todos los endpoints y ver los esquemas detallados.

## 💡 Consejos para la IA de Flutter
- Usa el paquete `dio` o `http` para las peticiones.
- Crea un `AuthRepository` en Flutter para manejar la lógica de guardar/leer el token.
- Implementa un Interceptor en Dio para agregar automáticamente el header `Authorization: Bearer ...`.
