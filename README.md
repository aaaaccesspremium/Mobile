# sofomcloud_mobile

Aplicación móvil desarrollada con Flutter y null‑safety que implementa un flujo de solicitud de préstamos con captura automática de documentos y firma digital.

## Requisitos previos

- Flutter 3.x y Dart 3.x instalados
- Dispositivo físico con cámara (probado en OnePlus NE2215 con Android 15)
- Acceso a Internet para obtener dependencias

## Estructura del proyecto

El módulo `loan_request` se encuentra en `lib/app/modules/loan_request` e incluye las siguientes pantallas:

1. `/loan/request/start` – inicio del flujo con el botón **Solicitar préstamos**.
2. `/loan/request/capture-card` – captura de tarjeta.
3. `/loan/request/capture-ine-front` – INE frente.
4. `/loan/request/capture-ine-back` – INE reverso.
5. `/loan/request/capture-doc` – documento adicional.
6. `/loan/request/sign` – firma con el dedo.
7. `/loan/request/review` – resumen y envío de la solicitud.

Las imágenes se guardan en el directorio temporal del dispositivo y sus rutas se persisten en el estado global administrado con Riverpod.

### Permisos

- **Android**: se requiere declarar `android.permission.CAMERA` y permisos de almacenamiento en `AndroidManifest.xml`.
- **iOS**: incluir `NSCameraUsageDescription` y `NSPhotoLibraryAddUsageDescription` en `Info.plist`.

## Ejecución

1. Instalar dependencias:

   ```sh
   flutter pub get
   ```
2. Conectar un dispositivo con depuración USB habilitada.
3. Ejecutar la aplicación:

   ```sh
   flutter run
   ```

Si hay múltiples dispositivos, especifica uno con `flutter run -d <deviceId>`.

> **Nota:** La captura de documentos requiere aceptar los permisos de cámara cuando se soliciten.

## Dependencias principales

- `camera` – captura y vista previa de la cámara.
- `permission_handler` – solicitud de permisos en tiempo de ejecución.
- `google_mlkit_document_scanner` o `edge_detection` – detección de documentos.
- `signature` – captura de firma en pantalla.
- `riverpod` – manejo de estado global.
- `http` o `dio` – envío de la solicitud al servicio `https://api.ejemplo.com/loan/request`.

## Desarrollo

Ejecuta los siguientes comandos para mantener la calidad del código:

```sh
dart format .
flutter analyze
```

Las pruebas se deben realizar en un dispositivo físico debido al uso de la cámara.

