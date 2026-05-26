# Flutter / Dart keep rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Isar
-keep class dev.isar.** { *; }

# Crashlytics
-keep class com.crashlytics.** { *; }
-dontwarn com.crashlytics.**

# AdMob
-keep class com.google.android.gms.ads.** { *; }

# Keep the alarm receiver and boot receiver
-keep class com.nanogear.med_reminder.DoseAlarmReceiver { *; }
-keep class com.nanogear.med_reminder.BootCompletedReceiver { *; }
-keep class com.nanogear.med_reminder.AlarmForegroundService { *; }
-keep class com.nanogear.med_reminder.MainActivity { *; }

# Suppress missing Play Core / SplitInstall warnings referenced during R8 shrinking.
# These rules were suggested by the Gradle missing_rules.txt output.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
