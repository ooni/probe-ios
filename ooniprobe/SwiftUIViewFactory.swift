import Foundation
import SwiftUI

@objc class LaunchScreenViewFactory: NSObject {

    @objc static func create(url: String) -> UIViewController {
        let view = LaunchScreen()
        let hostingController = UIHostingController(rootView: view)

        return hostingController
    }
}
