package com.example.flutter_example_app

import android.app.Activity
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import strutfit.button.models.ConversionItem
import strutfit.button.StrutFitTracking

class StrutFitTrackingManager(
    activity: Activity,
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

    class StrutFitTrackingHandler(private val activity: Activity) {

        fun registerOrderForStrutFit(args: Map<String, Any>, result: MethodChannel.Result) {
            try {
                val organizationId = args["organizationId"] as Int
                val orderReference = args["orderReference"] as String
                val orderValue = args["orderValue"] as Double
                val currencyCode = args["currencyCode"] as String
                val userEmail = args["userEmail"] as String?

                val strutFitTracking = StrutFitTracking(activity, organizationId)
                val items = ArrayList<ConversionItem>()

                val productItems = args["items"] as List<Map<String, Any>>
                for (item in productItems) {
                    val productIdentifier = item["productIdentifier"] as String
                    val price = item["price"] as Double
                    val quantity = item["quantity"] as Int
                    val size = item["size"] as String
                    val conversionItem = ConversionItem(productIdentifier, price, quantity, size)
                    items.add(conversionItem)
                }

                strutFitTracking.registerOrder(orderReference, orderValue, currencyCode, items, userEmail)
                Log.d("StrutFitTracking", "✅ Order Tracked: $orderReference")
                result.success("Order Tracked Successfully")
            } catch (e: Exception) {
                Log.e("StrutFitTracking", "❌ Error tracking order: ${e.message}", e)
                result.error("TRACKING_ERROR", e.message, null)
            }
        }
    }
}

