package com.example.flutter_example_app

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import strutfit.button.models.ConversionItem
import strutfit.button.StrutFitTracking

class StrutFitTrackingHandler(private val context: Context) {

    // Handle the "registerOrder" method call
    fun registerOrderForStrutFit(args: Map<String, Any>, result: MethodChannel.Result) {
        try {
            // Extract order details from the Flutter arguments
            val organizationId = args["organizationId"] as Int
            val orderReference = args["orderReference"] as String
            val orderValue = args["orderValue"] as Double
            val currencyCode = args["currencyCode"] as String
            val userEmail = args["userEmail"] as String

            val strutFitTracking = StrutFitTracking(context, organizationId)
            val items = ArrayList<ConversionItem>()

            // Extract product items from the arguments
            val productItems = args["items"] as List<Map<String, Any>>
            for (item in productItems) {
                val productIdentifier = item["productIdentifier"] as String
                val price = item["price"] as Double
                val quantity = item["quantity"] as Int
                val size = item["size"] as String
                val sizeUnit = item["sizeUnit"] as? String

                val conversionItem = if (sizeUnit != null) {
                    ConversionItem(productIdentifier, price, quantity, size, sizeUnit)
                } else {
                    ConversionItem(productIdentifier, price, quantity, size)
                }
                items.add(conversionItem)
            }

            // Register the order using the StrutFitTracking SDK
            strutFitTracking.registerOrder(orderReference, orderValue, currencyCode, items, userEmail)
            Log.d("StrutFitTracking", "Order Tracked: $orderReference")
            result.success("Order Tracked Successfully")
        } catch (e: Exception) {
            Log.e("StrutFitTracking", "Error tracking order: ${e.message}", e)
            result.error("TRACKING_ERROR", e.message, null)
        }
    }
}