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
