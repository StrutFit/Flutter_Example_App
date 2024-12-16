import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    // MARK: - Properties
    private var buttonManager: StrutFitButtonManager!
    private var trackingManager: StrutFitTrackingManager!
    
    // MARK: - Application Lifecycle
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        guard let controller = getFlutterViewController() else {
            fatalError("❌ Could not find FlutterViewController")
        }
        
        // Initialize managers
        buttonManager = StrutFitButtonManager(controller: controller)
        trackingManager = StrutFitTrackingManager(controller: controller)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    private func getFlutterViewController() -> FlutterViewController? {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("❌ Could not cast rootViewController to FlutterViewController")
            return nil
        }
        return controller
    }
}
