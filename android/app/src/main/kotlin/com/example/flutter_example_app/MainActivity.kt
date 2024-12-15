package com.example.flutter_example_app

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.StandardMessageCodec
import strutfit.button.StrutFitButtonView
import strutfit.button.ui.StrutFitButton
import android.util.Log
import android.view.View

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "strutfit_button_view",
                StrutFitButtonViewFactory(this) // Pass activity directly
            )

    }
}