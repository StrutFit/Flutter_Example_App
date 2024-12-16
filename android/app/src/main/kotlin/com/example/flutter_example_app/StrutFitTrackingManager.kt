package com.example.flutter_example_app

import android.app.Activity
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import strutfit.button.models.ConversionItem
import strutfit.button.StrutFitTracking

class StrutFitTrackingManager(
    private val activity: Activity, 
    flutterEngine: FlutterEngine
) {

    private val channelName = "STRUTFIT_TRACKING_PIXEL_CHANNEL"
    private val trackingHandler = StrutFitTrackingHandler(activity)

    init {
        registerMethodChannel(flutterEngine)
    }

    private fun registerMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method == "registerOrderForStrutFit") {
                val args = call.arguments as? Map<String, Any>
                if (args != null) {
                    trackingHandler.registerOrderForStrutFit(args, result)
                } else {
                    result.error("INVALID_ARGS", "Arguments were null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        Log.d("StrutFitTrackingManager", "✅ Tracking pixel channel registered successfully")
    }
}