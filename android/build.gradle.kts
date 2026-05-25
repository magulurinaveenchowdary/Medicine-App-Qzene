import com.android.build.gradle.LibraryExtension

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // PRD §12.7: Firebase Crashlytics Gradle plugin.
        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        extensions.findByType<LibraryExtension>()?.apply {
            // isar_flutter_libs ships compileSdk 30; androidx needs API 31+ (lStar).
            compileSdk = 36
            if (namespace.isNullOrBlank()) {
                namespace = project.group.toString().ifBlank {
                    "dev.isar.isar_flutter_libs"
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
