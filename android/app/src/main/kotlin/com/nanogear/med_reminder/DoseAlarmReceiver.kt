package com.nanogear.med_reminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/// Fires when AlarmManager clock triggers — launches Flutter alarm route.
class DoseAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val occurrenceId = intent.getStringExtra(EXTRA_OCCURRENCE_ID) ?: return
        val launch = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("medreminder://alarm?occurrenceId=$occurrenceId")
            addCategory(Intent.CATEGORY_DEFAULT)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("route", "/alarm?occurrenceId=$occurrenceId")
        }
        context.startActivity(launch)
    }

    companion object {
        const val EXTRA_OCCURRENCE_ID = "occurrence_id"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
    }
}
