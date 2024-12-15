import UIKit
import Flutter
import StrutFitButtonSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
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
    
    print("🔥 View registered successfully")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
