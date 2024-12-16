package com.example.flutter_example_app

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import strutfit.button.StrutFitButtonView
import strutfit.button.ui.StrutFitButton

class StrutFitButtonManager(
    private val activity: Activity, 
    flutterEngine: FlutterEngine
) {

    init {
        registerStrutFitButtonView(flutterEngine)
    }

    private fun registerStrutFitButtonView(flutterEngine: FlutterEngine) {
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "strutfit_button_view",
                StrutFitButtonViewFactory(activity) // Pass activity directly
            )
        
        Log.d("StrutFitButtonManager", "✅ StrutFit button view registered successfully")
    }

    // Platform View Factory
    class StrutFitButtonViewFactory(private val activity: Activity) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context?, id: Int, args: Any?): PlatformView {
            val creationParams = args as? Map<String, Any>
            Log.d("StrutFitButtonViewFactory", "🔥 Arguments received: $creationParams")
            return StrutFitButtonView(context!!, activity, creationParams)
        }
    }

    // Platform View
    class StrutFitButtonView(
        private val context: Context,
        private val activity: Activity,
        private val creationParams: Map<String, Any>?
    ) : PlatformView {

        private val strutFitButtonView: strutfit.button.StrutFitButtonView = strutfit.button.StrutFitButtonView(context)

        init {
            val organizationId = creationParams?.get("organizationId") as? Int ?: 0
            val productCode = creationParams?.get("productCode") as? String ?: ""
            val sizeUnit = creationParams?.get("sizeUnit") as? String ?: ""
            val apparelSizeUnit = creationParams?.get("apparelSizeUnit") as? String ?: ""

            if (organizationId == 0 || productCode.isEmpty()) {
                Log.e("StrutFitButtonView", "❌ Missing required parameters for StrutFit Button.")
            } else {
                strutFitButtonView.id = View.generateViewId()
                strutFitButtonView.visibility = View.GONE
                strutFitButtonView.post {
                    StrutFitButton(
                        activity, // Pass activity instead of context
                        strutFitButtonView.id,
                        organizationId,
                        productCode,
                        sizeUnit,
                        apparelSizeUnit
                    )
                }
            }
        }

        override fun getView(): View = strutFitButtonView

        override fun dispose() {}
    }
}