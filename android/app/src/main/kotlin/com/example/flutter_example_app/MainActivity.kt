package com.example.flutter_example_app

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // Declare the CHANNEL constant
    private val CHANNEL = "STRUTFIT_TRACKING_PIXEL_CHANNEL"

    // // Declare the tracking handler
    private lateinit var trackingHandler: StrutFitTrackingHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "strutfit_button_view",
                StrutFitButtonViewFactory(this) // Pass activity directly
            ) 

        trackingHandler = StrutFitTrackingHandler(this)

        // Set up the MethodChannel to listen for "registerOrderForStrutFit"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
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

    }
}