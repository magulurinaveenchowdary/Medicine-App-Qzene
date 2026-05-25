package com.nanogear.med_reminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/// Re-open app after boot so Flutter can reschedule alarms (PRD §6.9).
class BootCompletedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED) return
        val launch = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
            putExtra("reschedule_alarms", true)
        }
        context.startActivity(launch)
    }
}
