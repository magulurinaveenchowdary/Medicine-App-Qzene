package com.nanogear.med_reminder

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.IBinder

/**
 * Foreground service used to launch the alarm / post-call screen automatically,
 * even when the screen is on and the app is in the background.
 *
 * Background activity-start is blocked on Android 10+, but a *foreground* service
 * is always allowed to call startActivity().  DoseAlarmReceiver and CallReceiver
 * start this service instead of launching the activity directly.
 *
 * For alarms: the setAlarmClock() exemption on Android 12+ lets the BroadcastReceiver
 * start a foreground service from the background without ForegroundServiceStartNotAllowedException.
 */
class AlarmForegroundService : Service() {

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, startFlags: Int, startId: Int): Int {
        val type = intent?.getStringExtra(EXTRA_TYPE) ?: TYPE_ALARM
        val occurrenceId = intent?.getStringExtra(EXTRA_OCCURRENCE_ID) ?: ""
        val title = intent?.getStringExtra(EXTRA_TITLE) ?: "Medicine Reminder"
        val body = intent?.getStringExtra(EXTRA_BODY) ?: "Time to take your medicine"

        val isAfterCall = type == TYPE_AFTER_CALL
        val notifId = if (isAfterCall) 200_002
                      else occurrenceId.hashCode().let { if (it == 0) 1 else Math.abs(it) }
        val route = if (isAfterCall) "/after-call/single"
                    else "/alarm?occurrenceId=$occurrenceId"
        val launchUri = if (isAfterCall) Uri.parse("medreminder://after-call/single")
                        else Uri.parse("medreminder://alarm?occurrenceId=$occurrenceId")
        val notifTitle = if (isAfterCall) "Call Ended" else title
        val notifBody = if (isAfterCall) "Tap to review upcoming medicines" else body

        // startForeground() must be called within 5 s of onStartCommand().
        startForeground(notifId, buildNotification(notifId, launchUri, notifTitle, notifBody, isAfterCall))

        // Running foreground service → can always start an activity.
        val launchIntent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = launchUri
            addCategory(Intent.CATEGORY_DEFAULT)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
            )
            putExtra("route", route)
        }
        try {
            startActivity(launchIntent)
        } catch (_: Exception) {
            // Rare — notification fullscreen-intent is the fallback.
        }

        stopSelf(startId)
        return START_NOT_STICKY
    }

    private fun buildNotification(
        notifId: Int,
        launchUri: Uri,
        title: String,
        body: String,
        isAfterCall: Boolean,
    ): Notification {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = if (isAfterCall) "after_call_reminders_v1" else "medicine_reminder_default_v1"
        val channelName = if (isAfterCall) "After-Call Reminders" else "Medicine reminders"
        val category = if (isAfterCall) Notification.CATEGORY_CALL else Notification.CATEGORY_ALARM

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            nm.createNotificationChannel(
                NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH).apply {
                    enableVibration(true)
                    setShowBadge(true)
                }
            )
        }

        val launchIntent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = launchUri
            addCategory(Intent.CATEGORY_DEFAULT)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
            )
            putExtra("route", launchUri.path + if (launchUri.query.isNullOrEmpty()) "" else "?${launchUri.query}")
        }
        val pending = PendingIntent.getActivity(
            this,
            notifId,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val icon = if (isAfterCall) android.R.drawable.ic_dialog_info
                   else android.R.drawable.ic_lock_idle_alarm

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        builder
            .setSmallIcon(icon)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setContentIntent(pending)
            .setFullScreenIntent(pending, true)
            .setCategory(category)

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            @Suppress("DEPRECATION")
            builder.setPriority(Notification.PRIORITY_MAX)
        }

        return builder.build()
    }

    companion object {
        const val EXTRA_TYPE = "type"
        const val EXTRA_OCCURRENCE_ID = "occurrence_id"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"

        const val TYPE_ALARM = "alarm"
        const val TYPE_AFTER_CALL = "after_call"

        fun startForAlarm(context: Context, occurrenceId: String, title: String, body: String) {
            val intent = Intent(context, AlarmForegroundService::class.java).apply {
                putExtra(EXTRA_TYPE, TYPE_ALARM)
                putExtra(EXTRA_OCCURRENCE_ID, occurrenceId)
                putExtra(EXTRA_TITLE, title)
                putExtra(EXTRA_BODY, body)
            }
            startService(context, intent)
        }

        fun startForAfterCall(context: Context) {
            val intent = Intent(context, AlarmForegroundService::class.java).apply {
                putExtra(EXTRA_TYPE, TYPE_AFTER_CALL)
            }
            startService(context, intent)
        }

        private fun startService(context: Context, intent: Intent) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
    }
}
