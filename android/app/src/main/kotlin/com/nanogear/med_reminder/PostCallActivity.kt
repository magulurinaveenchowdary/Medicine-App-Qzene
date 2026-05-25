package com.nanogear.med_reminder

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.app.Activity
import android.util.Log

class PostCallActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        // Forward to MainActivity with the same route/data so Flutter can handle the screen.
        val incomingRoute = intent.getStringExtra("route")
        val dataUri = intent.data
        val targetRoute = incomingRoute ?: dataUri?.path ?: "/after-call/single"
        val launch = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = dataUri ?: Uri.parse("medreminder://after-call/single")
            addCategory(Intent.CATEGORY_DEFAULT)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("route", targetRoute)
        }

        try {
            startActivity(launch)
        } catch (_: Exception) {
        }

        // Close this intermediate activity; MainActivity (Flutter) will be visible.
        finish()
    }
}
