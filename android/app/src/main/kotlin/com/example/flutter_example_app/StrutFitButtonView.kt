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
        val organizationId = creationParams?.get("organizationId") as? Int ?: 0
        val productCode = creationParams?.get("productCode") as? String ?: ""
        val sizeUnit = creationParams?.get("sizeUnit") as? String ?: ""
        val apparelSizeUnit = creationParams?.get("apparelSizeUnit") as? String ?: ""

        strutFitButtonView.id = View.generateViewId()
        strutFitButtonView.visibility = View.GONE

        // Log.d("StrutFitButton", "Params: organizationId=$organizationId, productCode=$productCode")
        // Log.e("StrutFitButton", "strutFitButtonView: " + strutFitButtonView.id)
        // Log.e("StrutFitButton", "findViewById: " + activity.findViewById(strutFitButtonView.id))
        // val packageName = context.packageName
        // Log.d("MainActivity", "Package Name: $packageName")

        if (organizationId == 0 || 
            productCode == ""
        ) {
            Log.e("StrutFitButton", "Required parameters are missing or null. Aborting view initialization.")
            Log.e("StrutFitButton", "Parameters received: $creationParams")

        } else {
            // Customize layout
            // Initialize the StrutFitButton
            strutFitButtonView.post {
                StrutFitButton(
                    activity,
                    strutFitButtonView.id,
                    organizationId,
                    productCode,
                    sizeUnit,
                    apparelSizeUnit
                )
            }

        }
    }

    override fun getView(): android.view.View = strutFitButtonView
    override fun dispose() {}
}