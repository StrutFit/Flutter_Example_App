package com.example.flutter_example_app


import android.app.Activity
import android.content.Context
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class StrutFitButtonViewFactory(
    private val activity: Activity
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, id: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any> // Extract Dart creationParams
        return StrutFitButtonPlatformView(context!!, activity, creationParams)
    }
}