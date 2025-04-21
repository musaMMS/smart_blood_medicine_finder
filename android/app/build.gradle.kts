plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.2" // Firebase plugin
}

android {
    namespace = "com.example.smart_blood_medicine_finder" // Main app namespace
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.smart_blood_medicine_finder"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ✅ Compatibility for Pusher Beams dependency workaround
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
}

dependencies {
    // ✅ Firebase Cloud Messaging
    implementation("com.google.firebase:firebase-messaging:24.1.1")

    // ✅ Pusher Beams SDK
    implementation("com.pusher:push-notifications-android:1.9.0")
}

flutter {
    source = "../.."
}
