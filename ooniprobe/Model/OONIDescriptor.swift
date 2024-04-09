import Foundation
import UIKit

@objc(SNettest)
class SNettest : NSObject {
    
    // MARK: Initializers
    init(name: String, inputs: [String]?) {
        self.name = name
        self.inputs = inputs
    }
    
    // MARK: Properties
    @objc dynamic var name: String
    @objc dynamic var inputs: [String]?
}

@objc(OONIDescriptor)
class OONIDescriptor : NSObject {
    
    // MARK: Initializers
    init(name: String,
         title: String,
         shortDescription: String,
         longDescription: String,
         icon: String,
         color: UIColor,
         animation: String?,
         dataUsage: String,
         nettest: [SNettest],
         longRunningTests: [SNettest]?) {
        self.name = name
        self.title = title
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.icon = icon
        self.color = color
        self.animation = animation
        self.dataUsage = dataUsage
        self.nettest = nettest
        self.longRunningTests = longRunningTests
    }
    
    // MARK: Properties
    @objc dynamic var name: String
    @objc dynamic var title: String
    @objc dynamic var shortDescription: String
    @objc dynamic var longDescription: String
    @objc dynamic var icon: String
    @objc dynamic var color: UIColor
    @objc dynamic var animation: String?
    @objc dynamic var dataUsage: String
    @objc dynamic var nettest: [SNettest]
    @objc dynamic var longRunningTests: [SNettest]?
    
    // MARK: Methods
 
    // Get the OONI descriptors for the OONI dashboard.
    @objc public static func getOONIDescriptors() -> [OONIDescriptor] {
        var savedDescriptors:[OONIDescriptor] = (TestDescriptor.query().fetch() as! [TestDescriptor]).map({ (testDescriptor) -> OONIDescriptor in
            return OONIDescriptor(
                name: testDescriptor.name,
                title: testDescriptor.name,
                shortDescription: testDescriptor.shortDescription,
                longDescription: testDescriptor.iDescription,
                icon: testDescriptor.icon,
                color: UIColor(named: testDescriptor.color) ?? UIColor(named: "color_base")!,
                animation: testDescriptor.animation,
                dataUsage:  NSLocalizedString("TestResults.NotAvailable", comment: ""),
                nettest: testDescriptor.getNettests().map({ (nettest) -> SNettest in
                    return SNettest(name: nettest.test_name, inputs: nettest.inputs)
                }),
                longRunningTests: []
            )
        })

        var defaultDescriptors =  [
            OONIDescriptor(
                name: "websites",
                title: NSLocalizedString("Test.Websites.Fullname", comment: ""),
                shortDescription: NSLocalizedString("Dashboard.Websites.Card.Description", comment: ""),
                longDescription: NSLocalizedString("Dashboard.Websites.Overview.Paragraph", comment: ""),
                icon:"websites",
                color: UIColor(named: "color_indigo6")!,
                animation: "websites",
                dataUsage: "~ 8 MB",
                nettest: [
                    SNettest(name: "web_connectivity", inputs: [])
                ],
                longRunningTests: []
            ),

            OONIDescriptor(
                name: "instant_messaging",
                title: NSLocalizedString("Test.InstantMessaging.Fullname", comment: ""),
                shortDescription: NSLocalizedString("Dashboard.InstantMessaging.Card.Description", comment: ""),
                longDescription: NSLocalizedString("Dashboard.InstantMessaging.Overview.Paragraph", comment: ""),
                icon:"instant_messaging",
                color: UIColor(named: "color_indigo5")!,
                animation: "instant_messaging",
                dataUsage: NSLocalizedString("small.datausage", comment: ""),
                nettest: [
                    SNettest(name: "whatsapp", inputs: []),
                    SNettest(name: "telegram", inputs: []),
                    SNettest(name: "facebook_messenger", inputs: []),
                    SNettest(name: "signal", inputs: [])
                ],
                longRunningTests: []
            ),

            OONIDescriptor(
                name: "circumvention",
                title: NSLocalizedString("Test.Circumvention.Fullname", comment: ""),
                shortDescription: NSLocalizedString("Dashboard.Circumvention.Card.Description", comment: ""),
                longDescription: NSLocalizedString("Dashboard.Circumvention.Overview.Paragraph", comment: ""),
                icon:"circumvention",
                color: UIColor(named: "color_indigo2")!,
                animation: "circumvention",
                dataUsage: NSLocalizedString("small.datausage", comment: ""),
                nettest: [
                    SNettest(name: "psiphon", inputs: []),
                    SNettest(name: "tor", inputs: [])
                ],
                longRunningTests: []
            ),

            OONIDescriptor(
                name: "performance",
                title: NSLocalizedString("Test.Performance.Fullname", comment: ""),
                shortDescription: NSLocalizedString("Dashboard.Performance.Card.Description", comment: ""),
                longDescription: NSLocalizedString("Dashboard.Performance.Overview.Paragraph", comment: ""),
                icon:"performance",
                color: UIColor(named: "color_indigo4")!,
                animation: "performance",
                dataUsage: NSLocalizedString("performance.datausage", comment: ""),
                nettest: [
                    SNettest(name: "ndt", inputs: []),
                    SNettest(name: "dash", inputs: []),
                    SNettest(name: "http_header_field_manipulation", inputs: []),
                    SNettest(name: "http_invalid_request_line", inputs: [])
                ],
                longRunningTests: []
            ),

            OONIDescriptor(
                name: "experimental",
                title: NSLocalizedString("Test.Experimental.Fullname", comment: ""),
                shortDescription: NSLocalizedString("Dashboard.Experimental.Card.Description", comment: ""),
                longDescription: NSLocalizedString("Dashboard.Experimental.Overview.Paragraph", comment: ""),
                icon:"experimental",
                color: UIColor(named: "color_indigo1")!,
                animation: "experimental",
                dataUsage:  NSLocalizedString("TestResults.NotAvailable", comment: ""),
                nettest: [
                    SNettest(name: "stunreachability", inputs: []),
                    SNettest(name: "dnscheck", inputs: []),
                    SNettest(name: "riseupvpn", inputs: []),
                    SNettest(name: "echcheck", inputs: []),
                ],
                longRunningTests: [
                    SNettest(name: "torsf", inputs: []),
                    SNettest(name: "vanilla_tor", inputs: []),
                ]
            )
        ]
        
        return defaultDescriptors + savedDescriptors
    }

    // Get TestSuite
    @objc public func getTestSuites() -> [Any] {
        return [
            DynamicTestSuite(descriptor: self)
        ]
    }
}


class DynamicTestSuite : AbstractSuite {
    // MARK: Initializers
    init(descriptor: OONIDescriptor) {
        self.descriptor = descriptor
        super.init()
    }

    // MARK: Properties
    @objc dynamic var descriptor: OONIDescriptor
    
    // MARK: Methods
    override func getTestList() -> [Any]! {
        return [WebConnectivity()]
    }
}

class TestUtil : NSObject {
    
}
