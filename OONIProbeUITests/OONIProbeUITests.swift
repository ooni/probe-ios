import XCTest

class OONIProbeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)

        // Solution taken rom https://blog.codecentric.de/en/2018/06/resetting-ios-application-state-userdefaults-ui-tests/
        //Preventing Informed Consent to appear
        app.launchArguments += ["-first_run", "ok"]
        app.launchArguments += ["-upload_result_manually_popup", "ok"]
        app.launchArguments += ["enable_ui_testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testScreenshots() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()

        let tabBarsQuery = app.tabBars
        let tablesQuery = app.tables

        let dashboardButton = tabBarsQuery.buttons.element(boundBy: 0)
        let resultsButton = tabBarsQuery.buttons.element(boundBy: 1)
        
        dashboardButton.tap()
        snapshot("01Dashboard")

        resultsButton.tap()
        snapshot("02TestResults")
        
        let thepiratebayStaticText = tablesQuery.staticTexts["http://thepiratebay.org"]
        tablesQuery.cells.containing(.staticText, identifier:"Websites").staticTexts["AS30722 - Vodafone Italia S.p.A."].tap()
        thepiratebayStaticText.tap()
        snapshot("03WebsiteBlocked")
        
        // We make the assumption the first button in the navigationbar hierarchy is the back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        resultsButton.tap()
        tablesQuery.cells.containing(.staticText, identifier:"Performance").staticTexts["AS30722 - Vodafone Italia S.p.A."].tap()
        tablesQuery.cells.element(boundBy: 1).tap()
        snapshot("04SpeedTest")

        // We make the assumption the first button in the navigationbar hierarchy is the back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        dashboardButton.tap()
        tablesQuery.cells.element(boundBy: 0).tap()
        app.buttons["ConfigureButton"].tap()
        tablesQuery.cells.children(matching: .textField).element.tap()
        
        let oKey = app.keyboards.keys["o"]
        oKey.tap()
        oKey.tap()
        
        let nKey = app.keyboards.keys["n"]
        nKey.tap()
        
        let iKey = app.keyboards.keys["i"]
        iKey.tap()
        
        let key = app.keyboards.keys["."]
        key.tap()
        iKey.tap()
        oKey.tap()

        tablesQuery.children(matching: .other).element.children(matching: .button).element.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.tap()
        snapshot("05ChooseWebsite")
    }
}
