package com.meowarex.rlmobile.karaoke

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.meowarex.rlmobile.R

class KaraokeForegroundService : Service() {
    companion object {
        private const val CHANNEL_ID = "karaoke_qnn_channel"
        private const val NOTIFICATION_ID = 5445
        const val ACTION_TOGGLE_KARAOKE = "com.meowarex.rlmobile.karaoke.TOGGLE_KARAOKE"
        const val ACTION_TOGGLE_MODE = "com.meowarex.rlmobile.karaoke.TOGGLE_MODE"

        fun start(context: Context) {
            val intent = Intent(context, KaraokeForegroundService::class.java)
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
            } catch (_: Throwable) {
                KaraokeLocalServer.start(context)
            }
        }

        fun stop(context: Context) {
            try {
                context.stopService(Intent(context, KaraokeForegroundService::class.java))
            } catch (_: Throwable) {
            }
            KaraokeLocalServer.stop()
        }

        fun updateNotification(context: Context) {
            try {
                val appCtx = context.applicationContext
                createNotificationChannel(appCtx)
                val nm = appCtx.getSystemService(NotificationManager::class.java) ?: return
                nm.notify(NOTIFICATION_ID, createNotification(appCtx))
            } catch (_: Throwable) {
            }
        }

        private fun createNotificationChannel(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    "Karaoke QNN Engine",
                    NotificationManager.IMPORTANCE_LOW
                ).apply {
                    description = "Runs on-device Qualcomm QNN vocal separation on 127.0.0.1:5445"
                    setShowBadge(false)
                }
                context.getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
            }
        }

        private fun createNotification(context: Context): Notification {
            val enabled = KaraokeLocalServer.karaokeEnabled
            val mode = KaraokeLocalServer.getActiveMode()
            val provider = KaraokeLocalServer.getActiveProvider()

            val togglePi = PendingIntent.getService(
                context,
                1,
                Intent(context, KaraokeForegroundService::class.java).setAction(ACTION_TOGGLE_KARAOKE),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            val modePi = PendingIntent.getService(
                context,
                2,
                Intent(context, KaraokeForegroundService::class.java).setAction(ACTION_TOGGLE_MODE),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            return NotificationCompat.Builder(context, CHANNEL_ID)
                .setContentTitle("Radiant Karaoke QNN · ${if (enabled) "ON" else "OFF"}")
                .setContentText("Mode: $mode · $provider (127.0.0.1:5445)")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setOngoing(true)
                .setOnlyAlertOnce(true)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .addAction(0, if (enabled) "Turn OFF" else "Turn ON", togglePi)
                .addAction(0, if (mode == "karaoke") "Switch: Inst" else "Switch: Kara", modePi)
                .build()
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel(this)
        startForeground(NOTIFICATION_ID, createNotification(this))
        KaraokeLocalServer.start(applicationContext)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        KaraokeLocalServer.start(applicationContext)
        when (intent?.action) {
            ACTION_TOGGLE_KARAOKE -> {
                val next = !KaraokeLocalServer.karaokeEnabled
                if (next && !ModelCatalog.isModelInstalled(applicationContext, KaraokeLocalServer.getActiveMode())) {
                    val fallback = when {
                        ModelCatalog.isModelInstalled(applicationContext, "karaoke") -> "karaoke"
                        ModelCatalog.isModelInstalled(applicationContext, "instrumental") -> "instrumental"
                        else -> null
                    }
                    if (fallback != null) {
                        KaraokeLocalServer.setActiveMode(applicationContext, fallback)
                        KaraokeLocalServer.setKaraokeEnabled(applicationContext, true)
                    } else {
                        updateNotification(applicationContext)
                    }
                } else if (!next) {
                    KaraokeLocalServer.setKaraokeEnabled(applicationContext, false)
                    stopForeground(STOP_FOREGROUND_REMOVE)
                    stopSelf()
                    return START_NOT_STICKY
                } else {
                    KaraokeLocalServer.setKaraokeEnabled(applicationContext, true)
                }
            }
            ACTION_TOGGLE_MODE -> {
                val nextMode = if (KaraokeLocalServer.getActiveMode() == "karaoke") "instrumental" else "karaoke"
                KaraokeLocalServer.setActiveMode(applicationContext, nextMode)
            }
            else -> updateNotification(applicationContext)
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        KaraokeLocalServer.stop()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
