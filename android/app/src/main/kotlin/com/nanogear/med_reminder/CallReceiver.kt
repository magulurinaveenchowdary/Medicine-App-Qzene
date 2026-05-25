package com.nanogear.med_reminder

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.telephony.TelephonyManager

class CallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != TelephonyManager.ACTION_PHONE_STATE_CHANGED) return

        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE) ?: return
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        val afterCallEnabled = prefs.getBoolean("flutter.after_call_enabled", true)
        if (!afterCallEnabled) return

        val lastState = prefs.getString("last_phone_state", TelephonyManager.EXTRA_STATE_IDLE)
        prefs.edit().putString("last_phone_state", state).apply()

        if (state == TelephonyManager.EXTRA_STATE_IDLE &&
            (lastState == TelephonyManager.EXTRA_STATE_OFFHOOK ||
             lastState == TelephonyManager.EXTRA_STATE_RINGING)) {

            // Try to launch via foreground service (works even when screen is on).
            // On Android 12+ this may throw ForegroundServiceStartNotAllowedException
            // if the app has been in the background too long — the notification below
            // acts as a reliable fallback in that case.
            var serviceLaunched = false
            try {
                AlarmForegroundService.startForAfterCall(context)
                serviceLaunched = true
            } catch (_: Exception) { }

            // Show a high-priority fullscreen notification as fallback.
            // On a locked screen this also auto-opens without a tap.
            // On Android 14+ the user must grant USE_FULL_SCREEN_INTENT once.
            if (!serviceLaunched) {
                showAfterCallNotification(context)
            }
        }
    }

    private fun showAfterCallNotification(context: Context) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "after_call_reminders_v1"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            nm.createNotificationChannel(
                NotificationChannel(channelId, "After-Call Reminders", NotificationManager.IMPORTANCE_HIGH).apply {
                    description = "Shows medicine reminders after phone calls end"
                }
            )
        }

        val launchIntent = Intent(context, PostCallActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("medreminder://after-call/single")
            addCategory(Intent.CATEGORY_DEFAULT)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("route", "/after-call/single")
        }

        val pending = PendingIntent.getActivity(
            context,
            200_001,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }

        builder
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Call Ended")
            .setContentText("Tap to review your upcoming medicines")
            .setAutoCancel(true)
            .setContentIntent(pending)
            .setFullScreenIntent(pending, true)
            .setCategory(Notification.CATEGORY_CALL)

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            @Suppress("DEPRECATION")
            builder.setPriority(Notification.PRIORITY_MAX)
        }

        nm.notify(200_001, builder.build())
    }
}
