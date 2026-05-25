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
import android.util.Log

class CallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != TelephonyManager.ACTION_PHONE_STATE_CHANGED) return

        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE) ?: return
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        // Read if after-call screen is enabled in settings (default: true)
        val afterCallEnabled = prefs.getBoolean("flutter.after_call_enabled", true)
        if (!afterCallEnabled) {
            return
        }

        val lastState = prefs.getString("last_phone_state", TelephonyManager.EXTRA_STATE_IDLE)
        
        // Save new state
        prefs.edit().putString("last_phone_state", state).apply()

        // Transition from OFFHOOK (active call) or RINGING (incoming call) to IDLE (call ended)
        if (state == TelephonyManager.EXTRA_STATE_IDLE && 
            (lastState == TelephonyManager.EXTRA_STATE_OFFHOOK || lastState == TelephonyManager.EXTRA_STATE_RINGING)) {
            
            // Call ended, launching after-call full-screen activity
            
            // 1. Try to launch the activity directly (works if app is in foreground or on older Android versions).
            // Add a fallback deep link-style URI so route data survives the cold-start path.
            val launch = Intent(context, PostCallActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = android.net.Uri.parse("medreminder://after-call/single")
                addCategory(Intent.CATEGORY_DEFAULT)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
                putExtra("route", "/after-call/single")
            }
            try {
                context.startActivity(launch)
            } catch (e: Exception) {
                // Direct activity start may be blocked on Android 10+ (normal behavior)
            }

            // Post high-priority notification as fallback for full-screen intent
            showAfterCallNotification(context)
        }
    }

    private fun showAfterCallNotification(context: Context) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "after_call_reminders_v1"
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "After-Call Reminders",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows medicine reminders after phone calls end"
            }
            notificationManager.createNotificationChannel(channel)
        }
        
        val launchIntent = Intent(context, PostCallActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("medreminder://after-call/single")
            addCategory(Intent.CATEGORY_DEFAULT)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("route", "/after-call/single")
        }
        
        val pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pending = PendingIntent.getActivity(context, 200_001, launchIntent, pendingFlags)
        
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }
        
        builder.setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Call Ended")
            .setContentText("Tap to review your upcoming medicines")
            .setAutoCancel(true)
            .setContentIntent(pending)
            .setFullScreenIntent(pending, true)
            .setCategory(Notification.CATEGORY_CALL)
            
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            builder.setPriority(Notification.PRIORITY_HIGH)
        }
        
        notificationManager.notify(200_001, builder.build())
    }
}
