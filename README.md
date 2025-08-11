# SofomCloud Mobile

Aplicación Flutter multiplataforma para Android, iOS, Web y Desktop.

## Tabla de contenido
- [Requisitos previos](#requisitos-previos)
- [Setup rápido](#setup-rápido)
- [Selección de canal y versión](#selección-de-canal-y-versión)
- [Variables de entorno y PATH](#variables-de-entorno-y-path)
- [Configuración de Android](#configuración-de-android)
- [Configuración de iOS](#configuración-de-ios)
- [Habilitar Web y Desktop](#habilitar-web-y-desktop)
- [Plugins recomendados](#plugins-recomendados)
- [Cómo instalarlos](#cómo-instalarlos)
- [Permisos](#permisos)
- [Ejecución y build](#ejecución-y-build)
- [Solución de errores comunes](#solución-de-errores-comunes)
- [Calidad y utilidades](#calidad-y-utilidades)
- [CI](#ci)
- [Convenciones y versiones](#convenciones-y-versiones)
- [Anexos](#anexos)
- [Plantillas rápidas](#plantillas-rápidas)

## Requisitos previos

| Sistema | Herramientas |
| --- | --- |
| **Windows** | Flutter 3.22.0, Dart 3.3.0, Android Studio con SDK 34, Java 17, Git |
| **macOS** | Flutter 3.22.0, Dart 3.3.0, Android Studio con SDK 34, Xcode 15.4, CocoaPods, Java 17, Git |
| **Linux** | Flutter 3.22.0, Dart 3.3.0, Android Studio con SDK 34, Java 17, Git |

Verificar versiones:
```bash
flutter --version
java -version
node -v
npm -v
pod --version # macOS
```

## Setup rápido

```bash
git clone <url-del-repo> && cd SofomCloud-Mobile
flutter pub get
flutter doctor -v
```

## Selección de canal y versión

```bash
flutter channel stable
flutter downgrade 3.22.0 # o fvm use 3.22.0
```

## Variables de entorno y PATH

```bash
# Java 17export JAVA_HOME=/path/to/jdk17
# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk" # macOS
export PATH="$PATH:$ANDROID_HOME/platform-tools"
```

## Configuración de Android

`gradle/wrapper/gradle-wrapper.properties`
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
```

`settings.gradle.kts`
```kotlin
pluginManagement {
  repositories { google(); mavenCentral(); gradlePluginPortal() }
}
plugins {
  id("com.android.application") version "8.3.0" apply false
  id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}
```

`android/app/build.gradle.kts`
```kotlin
android {
  namespace = "com.example.sofomcloudmobile"
  compileSdk = 34
  defaultConfig {
    applicationId = "com.example.sofomcloudmobile"
    minSdk = 23
    targetSdk = 34
    versionCode = 1
    versionName = "1.0.0"
  }
  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
  }
  kotlinOptions { jvmTarget = "17" }
  buildFeatures { viewBinding = true }
  packagingOptions { resources.excludes += "/META-INF/{AL2.0,LGPL2.1}" }
}
```

`gradle.properties`
```properties
org.gradle.jvmargs=-Xmx4096m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
kotlin.daemon.jvmargs=-Xmx2048m
```

Instalar NDK/CMake si un plugin lo requiere:
1. Android Studio → SDK Manager → SDK Tools.
2. Marcar **NDK** y **CMake**.
3. Definir en `local.properties`:
```properties
ndk.dir=/path/to/ndk
```

## Configuración de iOS

- Requiere Xcode 15.4 y CocoaPods.
- Objetivo de despliegue iOS: 13.0.

```bash
cd ios
pod install # usar 'pod repo update' si falla
open Runner.xcworkspace
```

En `ios/Runner/Info.plist` agregar claves de privacidad según plugins.

## Habilitar Web y Desktop

```bash
flutter config --enable-web
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop
```

## Plugins recomendados

| Plugin | Propósito | Versión | Enlace | Plataformas |
| --- | --- | --- | --- | --- |
| camera | Acceso a cámara | 0.10.5+2 | https://pub.dev/packages/camera | A/iOS/Web/Desktop |
| image_picker | Seleccionar imágenes | 1.0.7 | https://pub.dev/packages/image_picker | A/iOS |
| path_provider | Directorios del sistema | 2.1.3 | https://pub.dev/packages/path_provider | A/iOS/Web/Desktop |
| permission_handler | Manejo de permisos | 11.0.1 | https://pub.dev/packages/permission_handler | A/iOS |
| edge_detection | Detectar bordes | 1.1.5 | https://pub.dev/packages/edge_detection | A/iOS |
| google_mlkit_document_scanner | Escáner de documentos | 0.3.0 | https://pub.dev/packages/google_mlkit_document_scanner | A/iOS |
| flutter_riverpod | Gestión de estado | 2.6.1 | https://pub.dev/packages/flutter_riverpod | Todos |
| get | Navegación simple | 4.7.2 | https://pub.dev/packages/get | Todos |
| shared_preferences | Almacenamiento local | 2.3.2 | https://pub.dev/packages/shared_preferences | Todos |

## Cómo instalarlos

`pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  camera: 0.10.5+2
  image_picker: 1.0.7
  path_provider: 2.1.3
  permission_handler: 11.0.1
  edge_detection: 1.1.5
  google_mlkit_document_scanner: 0.3.0
  flutter_riverpod: 2.6.1
  get: 4.7.2
  shared_preferences: 2.3.2
```

Instalación alternativa:
```bash
flutter pub add camera image_picker path_provider permission_handler \
  edge_detection google_mlkit_document_scanner flutter_riverpod get shared_preferences
```

### Uso básico

```dart
final image = await ImagePicker().pickImage(source: ImageSource.camera);
final prefs = await SharedPreferences.getInstance();
final cameraController = CameraController(cameras.first, ResolutionPreset.high);
final doc = await GoogleMlKit.vision.documentScanner().processImage(image);
final permission = await Permission.camera.request();
```

## Permisos

`AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-permission android:name="android.permission.CAMERA"/>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
  <application android:label="SofomCloud Mobile" android:name="${applicationName}" android:icon="@mipmap/ic_launcher">
    <activity android:name=".MainActivity" android:exported="true" android:launchMode="singleTop" android:theme="@style/LaunchTheme" android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode" android:hardwareAccelerated="true" android:windowSoftInputMode="adjustResize">
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
    </activity>
    <meta-data android:name="flutterEmbedding" android:value="2"/>
  </application>
</manifest>
```

`Info.plist`
```plist
<dict>
  <key>NSCameraUsageDescription</key>
  <string>Necesitamos acceder a la cámara</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>Necesitamos acceder a la galería</string>
</dict>
```

## Ejecución y build

```bash
flutter run -d chrome # o device id
flutter build apk --release
flutter build appbundle
flutter build ipa
flutter build web
```

### Firmas

**Android**
```bash
keytool -genkey -v -keystore ~/.keystores/sofom.jks -alias sofom -keyalg RSA -keysize 2048 -validity 10000
```
`android/key.properties`
```properties
storeFile=/path/to/sofom.jks
storePassword=********
keyAlias=sofom
keyPassword=********
```

**iOS**
- Abrir Runner.xcworkspace → seleccionar Team y certificados.

## Solución de errores comunes

| Síntoma | Fix |
| --- | --- |
| `Unresolved reference: android` | Asegura `pluginManagement` con `google()` y versiones alineadas. |
| `Plugin ... was not found` | Revisa `settings.gradle.kts` y `build.gradle.kts`. |
| `Execution failed for task :compileKotlin` | Alinear AGP 8.3.0, Gradle 8.7 y Kotlin 1.9.24. |
| `No podspec found` | `pod repo update && pod install`. |
| `minSdk` bajo | Usa `minSdk 23`. |
| `NDK not found` | Instalar NDK desde SDK Manager y definir `ndk.dir`. |
| Problemas de permisos | Revisar `AndroidManifest.xml` e `Info.plist`. |
| Errores de red/ADB | Reiniciar `adb kill-server && adb start-server`. |

## Calidad y utilidades

`Makefile`
```makefile
setup: flutter pub get
clean: flutter clean && rm -rf ios/Pods ios/Podfile.lock && ./gradlew clean
run\:android: flutter run -d android
run\:ios: flutter run -d ios
doctor: flutter doctor -v
build\:apk: flutter build apk --release
build\:aab: flutter build appbundle
build\:ios: flutter build ipa
```

Lint y formato:
```bash
flutter format .
flutter analyze
```

## CI

`.github/workflows/flutter.yml`
```yaml
name: Flutter CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

## Convenciones y versiones

- Mantener versiones fijas en `pubspec.yaml` y Gradle.
- Para actualizar: `flutter pub upgrade --major-versions` y probar.

## Anexos

### Árbol mínimo
```
lib/
android/
ios/
web/
```

### Checklists

- **Android**: `flutter doctor -v`, `./gradlew assembleDebug`.
- **iOS**: `pod install`, compilar en Xcode.
- **Web**: `flutter build web`.
- **Desktop**: `flutter run -d windows`/`macos`/`linux`.

## Plantillas rápidas

### `pubspec.yaml`
```yaml
name: sofomcloud_mobile
description: Proyecto Flutter
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: '>=3.3.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
  camera: 0.10.5+2
```

### `android/app/build.gradle.kts`
```kotlin
android {
  namespace = "com.example.sofomcloudmobile"
  compileSdk = 34
  defaultConfig {
    applicationId = "com.example.sofomcloudmobile"
    minSdk = 23
    targetSdk = 34
  }
}
```

### `AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.CAMERA"/>
</manifest>
```

### `Info.plist`
```plist
<dict>
  <key>NSCameraUsageDescription</key>
  <string>Acceso a la cámara requerido.</string>
</dict>
```

### `Podfile`
```ruby
platform :ios, '13.0'
use_frameworks!
```
