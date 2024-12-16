import Foundation
import Flutter
import StrutFitButtonSDK

class StrutFitTrackingManager {
    
    // MARK: - Properties
    private weak var controller: FlutterViewController?
    private let trackingChannel = "STRUTFIT_TRACKING_PIXEL_CHANNEL"
    private var trackingHandler: StrutFitTrackingHandler!
    
    // MARK: - Initializer
    init(controller: FlutterViewController) {
        self.controller = controller
        setupTrackingHandler()
        setupTrackingPixelChannel()
    }
    
    /// Initializes the tracking handler.
    private func setupTrackingHandler() {
        trackingHandler = StrutFitTrackingHandler()
    }
    
    /// Sets up a MethodChannel for tracking pixel requests from Flutter.
    private func setupTrackingPixelChannel() {
        guard let controller = controller else {
            print("❌ No FlutterViewController available for tracking channel")
            return
        }
        
        let channel = FlutterMethodChannel(name: trackingChannel, binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            switch call.method {
            case "registerOrderForStrutFit":
                self.handleRegisterOrderForStrutFit(call: call, result: result)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        print("✅ Tracking pixel channel registered successfully")
    }
    
    /// Handles the "registerOrderForStrutFit" method call.
    private func handleRegisterOrderForStrutFit(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            print("❌ Invalid arguments received for registerOrderForStrutFit")
            result(FlutterError(code: "INVALID_ARGS", message: "Arguments were null", details: nil))
            return
        }
        
        print("📦 Received order registration request: \(args)")
        trackingHandler.registerOrderForStrutFit(args: args, result: result)
    }
}

class StrutFitTrackingHandler {
    
    func registerOrderForStrutFit(args: [String: Any], result: @escaping FlutterResult) {
        do {
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
            let items = itemsArray.map {
                ConversionItem(
                    productIdentifier: $0["productIdentifier"] as? String ?? "",
                    price: Float($0["price"] as? Double ?? 0),
                    quantity: $0["quantity"] as? Int ?? 0,
                    size: $0["size"] as? String ?? ""
                )
            }

            tracking.registerOrder(orderReference: orderReference, orderValue: Float(orderValue), currencyCode: currencyCode, items: items, userEmail: userEmail)
            result("Tracking success!")
        } catch {
            result(FlutterError(code: "TRACKING_ERROR", message: "Failed to register", details: error.localizedDescription))
        }
    }
}
