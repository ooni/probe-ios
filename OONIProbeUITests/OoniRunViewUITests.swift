import Foundation
import XCTest

/// This class runs the UI tests for the OONI Run view.
///
/// The OONI Run view is the view that is shown when the user taps on a deeplink
/// that opens the OONI Probe app and starts a test.
///
/// The tests are performed by simulating the launch of the app from Safari using
/// a deeplink.
///
/// - seealso: [Reference thread](https://forums.developer.apple.com/forums/thread/25355?answerId=711988022#711988022)
///
/// The class is part of the OONI Probe UI tests suite.
///
class OoniRunViewUITests: XCTestCase {

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.0.0"

    func test_noInputs() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=web_connectivity&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Web Connectivity Test")
        XCTAssertEqual(app.staticTexts["OONIRun.Paragraph"].label, "You are about to run an OONI Probe test.")
        app.terminate()
    }

    func test_emptyInputs() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=web_connectivity&ta=%7B%22urls%22%3A%5B%5D%7D&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Web Connectivity Test")
        XCTAssertEqual(app.staticTexts["OONIRun.Paragraph"].label, "You are about to run an OONI Probe test.")
        app.terminate()
    }

    func test_openPartialInputs() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=web_connectivity&ta=%7B%22urls%22%3A%5B%22http%3A%2F%2F%22%5D%7D&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Web Connectivity Test")
        XCTAssertTrue(app.staticTexts["http://"].exists)
        app.terminate()
    }

    func skipped_openValidUrls() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=web_connectivity&ta=%7B%22urls%22%3A%5B%22http%3A%2F%2Fwww.google.it%22%2C%22https%3A%2F%2Frun.ooni.io%2F%22%5D%7D&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Web Connectivity Test")
        XCTAssertTrue(app.staticTexts["http://www.google.it"].exists)
        XCTAssertTrue(app.staticTexts["https://run.ooni.io/"].exists)
        app.terminate()
    }

    func test_openMalformedUrl() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=web_connectivity&ta=%7B%22urls%22%3A%5B%22http%3A%2F%2Fwww.google.it%22%2C%22https%3A%2F%2Frun.ooni.io&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)


        XCTAssertTrue(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].exists)
        XCTAssertEqual(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].label, "Close")
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Invalid parameter")
        app.terminate()
    }

    func test_openNdt() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=ndt&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "NDT Speed Test")
        app.terminate()
    }

    func test_openDash() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=dash&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "DASH Streaming Test")
        app.terminate()
    }

    func test_openHttpInvalidRequestLine() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=http_invalid_request_line&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "HTTP Invalid Request Line Test")
        app.terminate()
    }

    func test_openHttpHeaderFieldManipulation() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=http_header_field_manipulation&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        checkRunButtonIsDisplayed(app: app)
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "HTTP Header Field Manipulation Test")
        app.terminate()
    }

    func test_openInvalidTestName() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?tn=antani&mv=" + appVersion)

        let _ = app.wait(for: .runningForeground, timeout: 5)

        XCTAssertTrue(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].exists)
        XCTAssertEqual(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].label, "Close")
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Invalid parameter")
        app.terminate()
    }

    func test_openOutdatedVersion() {
        let app = XCUIApplication()

        launchUrlFromSafari("ooni://nettest?mv=2100.01.01&tn=dash")

        let _ = app.wait(for: .runningForeground, timeout: 5)

        XCTAssertTrue(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].exists)
        XCTAssertEqual(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].label, "Update")
        XCTAssertEqual(app.staticTexts["OONIRun.Title"].label, "Out of date")
        app.terminate()
    }

    private func checkRunButtonIsDisplayed(app: XCUIApplication) {
        XCTAssertTrue(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].waitForExistence(timeout: 50))
        XCTAssertEqual(app.buttons[NSLocalizedString("OONIRun.Run", comment: "")].label, "Run")
    }

    /// Launch the OONI Probe app from Safari.
    /// This method is used to simulate the launch of the app from a deeplink.
    ///
    /// - seealso: [Reference thread](https://forums.developer.apple.com/forums/thread/25355?answerId=711988022#711988022)
    ///
    /// - Parameter urlString: The deeplink URL
    private func launchUrlFromSafari(_ urlString: String) {

        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

        safari.launch()

        // Make sure Safari is really running before asserting

        XCTAssert(safari.wait(for: .runningForeground, timeout: 5))

        // Type the deeplink and execute it

        let firstLaunchContinueButton = safari.buttons["Continue"]

        if firstLaunchContinueButton.exists {

            firstLaunchContinueButton.tap()

        }

        safari.textFields["Address"].tap()

        let keyboardTutorialButton = safari.buttons["Continue"].firstMatch

        if keyboardTutorialButton.exists {

            keyboardTutorialButton.tap()

        }

        safari.typeText(urlString)

        safari.buttons["go"].tap()

        let openButton = safari.buttons["Open"]

        let _ = openButton.waitForExistence(timeout: 2)

        if openButton.exists {

            openButton.tap()

        }
    }


}
