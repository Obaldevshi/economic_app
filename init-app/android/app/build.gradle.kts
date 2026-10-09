import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeyProperties = Properties()
val releaseKeyFile = rootProject.file("key.properties")
if (releaseKeyFile.exists()) releaseKeyFile.inputStream().use { releaseKeyProperties.load(it) }
val previewSigning = System.getenv("NOT_SPENT_PREVIEW_SIGNING") == "1"
val unsignedPreview = System.getenv("NOT_SPENT_UNSIGNED_PREVIEW") == "1"

android {
    namespace = "app.obaldevshi.notspent"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "app.obaldevshi.notspent"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Configure 16KB page size alignment for native libraries
        externalNativeBuild {
            cmake {
                arguments += listOf("-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZE=ON")
            }
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    signingConfigs {
        if (releaseKeyFile.exists()) {
            create("release") {
                keyAlias = releaseKeyProperties.getProperty("keyAlias")
                keyPassword = System.getenv("NOT_SPENT_KEY_PASSWORD") ?: releaseKeyProperties.getProperty("keyPassword")
                storeFile = rootProject.file(releaseKeyProperties.getProperty("storeFile"))
                storePassword = System.getenv("NOT_SPENT_STORE_PASSWORD") ?: releaseKeyProperties.getProperty("storePassword")
            }
        }
    }
    buildTypes {
        getByName("release") {
            // No implicit debug certificate in a publishing artifact.
            signingConfig = when {
                unsignedPreview -> null
                previewSigning -> signingConfigs.getByName("debug")
                releaseKeyFile.exists() -> signingConfigs.getByName("release")
                else -> null
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // FileProvider shares only the generated receipt's cache file.
    implementation("androidx.core:core:1.15.0")
}
