package com.nanogear.med_reminder

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure activity can show on top of lock screen and wake up screen (PRD alignment)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                android.view.WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                android.view.WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                android.view.WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }
        window.addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        if (intent?.getBooleanExtra("reschedule_alarms", false) == true) {
            getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
                .edit()
                .putBoolean("flutter.boot_reschedule_pending_v1", true)
                .apply()
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.nanogear.med_reminder/alarm",
        )
        methodChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialRoute" -> {
                    val route = extractRoute(intent)
                    if (route != null && intent?.hasExtra("route") == true) {
                        intent?.removeExtra("route")
                    }
                    result.success(route)
                }
                "canScheduleExactAlarms" -> {
                    result.success(readCanScheduleExactAlarms())
                }
                "requestScheduleExactAlarmPermission" -> {
                    val forceOpen = call.argument<Boolean>("forceOpen") == true
                    result.success(buildExactAlarmSettingsLaunchResult(forceOpen))
                }
                "openBatteryOptimizationSettings" -> {
                    result.success(openBatteryOptimizationSettings())
                }
                "scheduleAlarmClock" -> {
                    val alarmId = call.argument<Int>("alarmId") ?: 0
                    val triggerAtMillis = call.argument<Long>("triggerAtMillis") ?: 0L
                    val occurrenceId = call.argument<String>("occurrenceId") ?: ""
                    val title = call.argument<String>("title") ?: "Medicine Reminder"
                    val body = call.argument<String>("body") ?: ""
                    scheduleAlarmClock(
                        alarmId,
                        triggerAtMillis,
                        occurrenceId,
                        title,
                        body,
                    )
                    result.success(null)
                }
                "cancelAllAlarms" -> {
                    cancelAllAlarms()
                    result.success(null)
                }
                "canUseFullScreenIntent" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                        result.success(nm.canUseFullScreenIntent())
                    } else {
                        result.success(true)
                    }
                }
                "openFullScreenIntentSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                            data = Uri.parse("package:$packageName")
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        try { startActivity(intent); result.success(true) }
                        catch (_: Exception) { result.success(false) }
                    } else {
                        result.success(true)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun readCanScheduleExactAlarms(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        return alarmManager.canScheduleExactAlarms()
    }

    /**
     * Never opens [Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM] when permission is already
     * granted — that screen shows a grey, non-interactive ON toggle and blocks the user.
     * Permission is never granted from code; the user toggles it in system settings only.
     */
    private fun buildExactAlarmSettingsLaunchResult(forceOpen: Boolean): Map<String, Any> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return mapOf(
                "openedSettings" to false,
                "alreadyGranted" to true,
                "requiresUserGrant" to false,
            )
        }
        if (!forceOpen && readCanScheduleExactAlarms()) {
            return mapOf(
                "openedSettings" to false,
                "alreadyGranted" to true,
                "requiresUserGrant" to true,
            )
        }
        val opened = openScheduleExactAlarmPermissionScreen()
        return mapOf(
            "openedSettings" to opened,
            "alreadyGranted" to false,
            "requiresUserGrant" to true,
        )
    }

    /** Battery-only settings — never [Settings.ACTION_APPLICATION_DETAILS_SETTINGS]. */
    private fun openBatteryOptimizationSettings(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false
        val packageUri = Uri.parse("package:$packageName")
        val requestIntent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
            data = packageUri
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        if (canResolveActivity(requestIntent)) {
            return try {
                startActivity(requestIntent)
                true
            } catch (_: Exception) {
                false
            }
        }
        val listIntent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        if (canResolveActivity(listIntent)) {
            return try {
                startActivity(listIntent)
                true
            } catch (_: Exception) {
                false
            }
        }
        return false
    }

    private fun canResolveActivity(intent: Intent): Boolean =
        packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null

    private fun openScheduleExactAlarmPermissionScreen(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return false
        val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
            data = Uri.parse("package:$packageName")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        val canResolve =
            packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null
        if (!canResolve) return openApplicationDetailsSettings()
        return try {
            startActivity(intent)
            true
        } catch (_: Exception) {
            openApplicationDetailsSettings()
        }
    }

    private fun openApplicationDetailsSettings(): Boolean {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        return try {
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun extractRoute(intent: Intent?): String? {
        if (intent == null) return null
        intent.getStringExtra("route")?.let { return it }
        intent.data?.let { uri ->
            val path = uri.path ?: return null
            return if (uri.query.isNullOrEmpty()) path else "$path?${uri.query}"
        }
        return null
    }

    private fun scheduleAlarmClock(
        alarmId: Int,
        triggerAtMillis: Long,
        occurrenceId: String,
        title: String,
        body: String,
    ) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

        // Broadcast intent triggers DoseAlarmReceiver, which shows a full-screen notification
        // and also attempts a direct activity launch. Using getBroadcast here so that
        // cancelAllAlarms() can look up the same PendingIntent type and actually cancel it.
        val receiverIntent = Intent(this, DoseAlarmReceiver::class.java).apply {
            putExtra(DoseAlarmReceiver.EXTRA_OCCURRENCE_ID, occurrenceId)
            putExtra(DoseAlarmReceiver.EXTRA_TITLE, title)
            putExtra(DoseAlarmReceiver.EXTRA_BODY, body)
        }
        val alarmPending = PendingIntent.getBroadcast(this, alarmId, receiverIntent, pendingFlags)

        // Activity intent shown in the system clock badge — tapping it opens the alarm screen.
        val showIntent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            putExtra("route", "/alarm?occurrenceId=$occurrenceId")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        val showPending = PendingIntent.getActivity(
            this,
            alarmId + 100_000,
            showIntent,
            pendingFlags,
        )

        val info = AlarmManager.AlarmClockInfo(triggerAtMillis, showPending)
        alarmManager.setAlarmClock(info, alarmPending)
    }

    private fun cancelAllAlarms() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        for (id in 0 until 512) {
            val intent = Intent(this, DoseAlarmReceiver::class.java)
            val flags = PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            val pending = PendingIntent.getBroadcast(this, id, intent, flags) ?: continue
            alarmManager.cancel(pending)
            pending.cancel()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val route = extractRoute(intent)
        if (route != null) {
            methodChannel?.invokeMethod("onNavigate", route)
        }
    }
}
