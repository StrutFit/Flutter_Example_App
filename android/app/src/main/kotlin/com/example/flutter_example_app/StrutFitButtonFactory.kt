package com.example.flutter_example_app

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import strutfit.button.StrutFitButtonView
import strutfit.button.ui.StrutFitButton

class StrutFitButtonPlatformView(
    private val context: Context,
    private val activity: Activity,
    private val creationParams: Map<String, Any>?
) : PlatformView {

    private val strutFitButtonView: StrutFitButtonView = StrutFitButtonView(context)

    init {
        // Extract parameters from creationParams
        val organizationId = creationParams?.get("organizationId") as? Int ?: 1
        val productCode = creationParams?.get("productCode") as? String ?: "TestProduct"
        val sizeUnit = creationParams?.get("sizeUnit") as? String ?: "US"
        val apparelSizeUnit = creationParams?.get("apparelSizeUnit") as? String ?: "US"
        val width = (creationParams?.get("width") as? Int) ?: 800
        val height = (creationParams?.get("height") as? Int) ?: 120

        // Log.d("StrutFitButton", "Params: organizationId=$organizationId, productCode=$productCode")
        // Log.e("StrutFitButton", "strutFitButtonView: " + strutFitButtonView.id)
        // Log.e("StrutFitButton", "findViewById: " + activity.findViewById(strutFitButtonView.id))
        val packageName = context.packageName
        Log.d("MainActivity", "Package Name: $packageName")

        // Customize layout
        strutFitButtonView.layoutParams = FrameLayout.LayoutParams(width, height)
        strutFitButtonView.id = View.generateViewId()

        // Add the button view to the root layout
        val rootView = activity.findViewById<FrameLayout>(android.R.id.content)
        rootView.addView(strutFitButtonView)

        // Initialize the StrutFitButton
        StrutFitButton(
            activity, 
            strutFitButtonView.id, 
            organizationId, 
            productCode, 
            sizeUnit, 
            apparelSizeUnit
        )
    }

    override fun getView(): android.view.View = strutFitButtonView
    override fun dispose() {}
}