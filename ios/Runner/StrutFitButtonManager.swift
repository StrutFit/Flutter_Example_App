import Foundation
import Flutter
import UIKit
import StrutFitButtonSDK
import SwiftUI

class StrutFitButtonManager {
    
    // MARK: - Properties
    private weak var controller: FlutterViewController?
    
    // MARK: - Initializer
    init(controller: FlutterViewController) {
        self.controller = controller
        registerStrutFitButtonView()
    }
    
    /// Registers the StrutFit button platform view with Flutter.
    private func registerStrutFitButtonView() {
        guard let controller = controller else {
            print("❌ No FlutterViewController available for button registration")
            return
        }
        
        guard let registrar = controller.registrar(forPlugin: "strutfit_button_view") else {
            print("❌ Could not find registrar for strutfit_button_view")
            return
        }
        
        registrar.register(StrutFitButtonViewFactory(messenger: registrar.messenger()), withId: "strutfit_button_view")
        print("✅ StrutFit button view registered successfully")
    }
}

// MARK: - Button View Factory
class StrutFitButtonViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        if let args = args {
            print("🔥 Arguments in Factory: \(args) (Type: \(type(of: args)))")
        } else {
            print("❌ No arguments received in Factory")
        }

        return StrutFitButtonView(frame: frame, viewIdentifier: viewId, arguments: args)
    }
}

// MARK: - Button View
public class StrutFitButtonView: NSObject, FlutterPlatformView {
    private var _view: UIView

    public init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) {
        _view = UIView(frame: frame)
        super.init()

        // Extract creation parameters from Flutter
        guard let creationParams = args as? [String: Any] else { return }

        let productCode = creationParams["productCode"] as? String ?? ""
        let organizationId = creationParams["organizationId"] as? Int ?? 0
        let sizeUnit = creationParams["sizeUnit"] as? String? ?? nil
        let apparelSizeUnit = creationParams["apparelSizeUnit"] as? String? ?? nil
        let productName = creationParams["productName"] as? String ?? ""
        let productImageURL = creationParams["productImageURL"] as? String ?? ""
        
        if (organizationId == 0 || productCode.isEmpty) {
            print("❌ Missing required parameters for StrutFit Button.")
            return;
        }

        let buttonView = StrutFitButtonSDK.StrutFitButtonView(
            productCode: productCode,
            organizationUnitId: organizationId,
            sizeUnit: sizeUnit,
            apparelSizeUnit: apparelSizeUnit,
            productName: productName,
            productImageURL: productImageURL
        )

        let hostingController = UIHostingController(rootView: buttonView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.view.backgroundColor = .clear
        _view.addSubview(hostingController.view)
    }

    public func view() -> UIView {
        return _view
    }
}
