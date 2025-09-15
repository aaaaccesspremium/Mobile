plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // El plugin de Flutter va después
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sofomcloud_mobile"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.sofomcloud_mobile"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    // Forzar NDK 27
    ndkVersion = "27.0.12077973"

    // Java 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

// Kotlin 17 (evita warnings deprecados de kotlinOptions)
kotlin {
    jvmToolchain(17)
}

flutter {
    source = "../.."
}
