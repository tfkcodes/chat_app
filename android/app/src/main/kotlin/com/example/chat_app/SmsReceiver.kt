package com.example.chat_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) return
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)


        messages.forEach { sms ->
            val sender = sms.originatingAddress ?: return@forEach
            val body = sms.messageBody ?: return@forEach

            if (isTrustedSender(sender) && isTransactional(body)) {
                sendToFlutter(sender, body)
            }
        }
    }

    private fun sendToFlutter(sender: String, body: String) {
        val engine = FlutterEngineCache
            .getInstance()
            .get("sms_engine")
            ?: return   // Flutter not running

        MethodChannel(
            engine.dartExecutor.binaryMessenger,
            "sms_background_channel"
        ).invokeMethod(
            "onIncomingSms",
            mapOf(
                "sender" to sender,
                "body" to body,
                "timestamp" to System.currentTimeMillis()
            )
        )
    }

    private fun isTransactional(body: String): Boolean {
        val keywords = listOf(
            "Imethibitishwa",
            "Umetuma",
            "Umepokea Tsh",
            "Umepokea TZS",
        )
        return keywords.any { body.contains(it, ignoreCase = true) }
    }

    private fun isTrustedSender(sender: String): Boolean {
        val trustedSenders = listOf(
            "MPESA",
            "M-PESA",
            "AIRTELMONEY",
            "AIRTEL",
            "HALOPESA",
            "HALOTEL",
            "MIXX",
            "YAS",
            "TIGOPESA",
            "TIGO"
        )

        return trustedSenders.any {
            sender.contains(it, ignoreCase = true)
        }
    }
}
