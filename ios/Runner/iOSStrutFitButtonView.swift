import Foundation
import Flutter
import UIKit
import SwiftUI
import StrutFitButtonSDK

public class iOSStrutFitButtonView: NSObject, FlutterPlatformView {
    private var _view: UIView

    public init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) {
        // Create an empty container UIView
        _view = UIView(frame: frame)
        super.init()

        // Extract the creation parameters from the Dart side
        guard let creationParams = args as? [String: Any] else { return }

        let productCode = creationParams["productCode"] as? String ?? "TestProduct"
        let organizationId = creationParams["organizationUnitId"] as? Int ?? 1
        let sizeUnit = creationParams["sizeUnit"] as? String ?? "US"
        let apparelSizeUnit = creationParams["apparelSizeUnit"] as? String ?? "US"
        
//        let productCode = "TestProduct"
//        let organizationId =  1
//        let sizeUnit = "US"
//        let apparelSizeUnit = "US"


        // Create the SwiftUI-based StrutFitButtonView
        let buttonView = StrutFitButtonView(
            productCode: productCode, 
            organizationUnitId: organizationId, 
            sizeUnit: sizeUnit, 
            apparelSizeUnit: apparelSizeUnit
        )

        // Embed the SwiftUI view inside a UIView using UIHostingController
        let hostingController = UIHostingController(rootView: buttonView)
        
        // Set the frame and constraints for the HostingController's view
        hostingController.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Add the HostingController's view to the main UIView
        _view.addSubview(hostingController.view)
    }

    public func view() -> UIView {
        return _view
    }
}
