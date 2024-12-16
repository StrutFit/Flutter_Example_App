import UIKit
import Flutter
import StrutFitButtonSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private let trackingChannel = "STRUTFIT_TRACKING_PIXEL_CHANNEL"
    private var trackingHandler: StrutFitTrackingHandler!

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "No Bundle Identifier"
        print("📦 Bundle Identifier: \(bundleIdentifier)") // Log the bundle identifier
        
        let controller = window?.rootViewController as! FlutterViewController
        guard let registrar = controller.registrar(forPlugin: "strutfit_button_view") else {
            print("Could not find registrar for strutfit_button_view")
            fatalError("Could not find registrar for strutfit_button_view")
        }

        // Register the platform view factory for "strutfit_button_view"
        registrar.register(StrutFitButtonViewFactory(messenger: registrar.messenger()), withId: "strutfit_button_view")
        print("View registered successfully")
        
        // 🔥 Initialize the tracking handler
        trackingHandler = StrutFitTrackingHandler()
        
        // 🔥 Register the MethodChannel for tracking pixel
        let channel = FlutterMethodChannel(name: trackingChannel, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "registerOrderForStrutFit" {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments were null", details: nil))
                    return
                }
                self?.trackingHandler.registerOrderForStrutFit(args: args, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}