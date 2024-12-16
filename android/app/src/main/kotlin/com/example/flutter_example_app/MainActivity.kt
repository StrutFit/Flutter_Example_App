package com.example.flutter_example_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    
    private lateinit var buttonManager: StrutFitButtonManager
    private lateinit var trackingManager: StrutFitTrackingManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Pass `this` to ensure managers have access to the activity
        buttonManager = StrutFitButtonManager(this, flutterEngine)
        trackingManager = StrutFitTrackingManager(this, flutterEngine)
    }
}