package com.nanogear.med_reminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/// Fires when AlarmManager clock triggers.
/// Delegates to AlarmForegroundService which can startActivity() reliably
/// regardless of screen state (on/off, locked/unlocked).
class DoseAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val occurrenceId = intent.getStringExtra(EXTRA_OCCURRENCE_ID) ?: return
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "Medicine Reminder"
        val body = intent.getStringExtra(EXTRA_BODY) ?: "Time to take your medicine"

        // The setAlarmClock() exemption on Android 12+ allows this receiver to start
        // a foreground service from the background.  The service then calls startActivity()
        // — which always works from a running foreground service — so the alarm screen
        // appears automatically without the user having to tap the notification.
        AlarmForegroundService.startForAlarm(context, occurrenceId, title, body)
    }

    companion object {
        const val EXTRA_OCCURRENCE_ID = "occurrence_id"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
    }
}
