import Foundation
import Flutter
import UIKit
import StrutFitButtonSDK

class StrutFitButtonViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    // 🟢 Add this method to ensure arguments are decoded properly
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

        return iOSStrutFitButtonView(frame: frame, viewIdentifier: viewId, arguments: args)
    }
}
