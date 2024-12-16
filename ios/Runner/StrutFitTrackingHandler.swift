import Foundation
import StrutFitButtonSDK
import Flutter

class StrutFitTrackingHandler {
    
    func registerOrderForStrutFit(args: [String: Any], result: @escaping FlutterResult) {
        do {
            // Extract the required arguments from Flutter
            guard
                let organizationId = args["organizationId"] as? Int,
                let orderReference = args["orderReference"] as? String,
                let orderValue = args["orderValue"] as? Double,
                let currencyCode = args["currencyCode"] as? String,
                let userEmail = args["userEmail"] as? String,
                let itemsArray = args["items"] as? [[String: Any]]
            else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
                return
            }
            
            let tracking = StrutFitTracking(organizationUnitId: organizationId)
            var items: [ConversionItem] = []

            for item in itemsArray {
                let productIdentifier = item["productIdentifier"] as? String ?? "unknown"
                let price = item["price"] as? Float ?? 0.0
                let quantity = item["quantity"] as? Int ?? 0
                let size = item["size"] as? String ?? "unknown"
                
                let conversionItem = ConversionItem(productIdentifier: productIdentifier, price: price, quantity: quantity, size: size)
                items.append(conversionItem)
            }

            tracking.registerOrder(orderReference: orderReference, orderValue: Float(orderValue), currencyCode: currencyCode, items: items, userEmail: userEmail)
            result("Tracking success!")
        } catch let error {
            print("Error tracking order: \(error)")
            result(FlutterError(code: "TRACKING_ERROR", message: "Failed to register tracking pixel", details: error.localizedDescription))
        }
    }
}
