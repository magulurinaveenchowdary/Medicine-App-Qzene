plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // PRD §12.7 — Firebase Crashlytics (day-1 requirement).
    id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nanogear.med_reminder"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.nanogear.med_reminder"
        // PRD §9: Min Android 8.0 (API 26).
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Google sample AdMob app id — used for debug/profile (see release override).
        manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-2961863855425096~2223149321"
            // PRD §9: APK < 30 MB — R8 full-mode shrinking.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }

}

flutter {
    source = "../.."
}

dependencies {
    // Required by flutter_local_notifications (Java 8+ APIs on older minSdk).
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
