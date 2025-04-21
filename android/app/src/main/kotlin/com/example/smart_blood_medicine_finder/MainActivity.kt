package com.example.smart_blood_medicine_finder

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.pusher.pushnotifications.PushNotifications // ← Pusher Beams SDK import

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ✅ Pusher Beams Initialization and Device Subscription
        PushNotifications.start(applicationContext, "bbc1dc4c-5067-45de-800d-70cc9e0da920")
        PushNotifications.addDeviceInterest("hello")
    }
}
