import XCTest

class OONIProbeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let repoRoot = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let fixturesDir = repoRoot.appendingPathComponent("fixtures")

        if let simulatorSharedDir = ProcessInfo().environment["SIMULATOR_SHARED_RESOURCES_DIRECTORY"] {
            let appID = UIDevice.current.identifierForVendor!.uuidString

            let simulatorHomeDirURL = URL(fileURLWithPath: simulatorSharedDir)
            let containerDir = simulatorHomeDirURL.appendingPathComponent("Containers/Data/Application")
            
            let appDirs = try! FileManager.default.contentsOfDirectory(atPath: containerDir.path)

            // ATTENTION BIG CAVEAT!
            // Currently for the logic below to work you need to have installed (and run) OONI Probe at least once inside of the simulator for the target device. Once that is done it will work OK, but it won't work until then.
            // When in doubt try rerunning the tests and they should work.
            // XXX maybe a better way to do this is:
            // https://developer.apple.com/documentation/foundation/filemanager/1412643-containerurl
            var targetAppDir = containerDir
            for appDir in appDirs {
                targetAppDir = containerDir.appendingPathComponent(appDir)
                if FileManager.default.fileExists(atPath: targetAppDir.appendingPathComponent("Documents/OONIProbe.db").path) {
                    print("Success!!")
                    print(targetAppDir)
                    break
                }
            }
            XCTAssertTrue(targetAppDir != containerDir, "Could not find targetAppDir")

            let prefPath = targetAppDir.appendingPathComponent("Library/Preferences/org.openobservatory.ooniprobe.plist")
            try? FileManager.default.removeItem(at: prefPath)
            try! FileManager.default.copyItem(
                atPath: fixturesDir.appendingPathComponent("org.openobservatory.ooniprobe.plist").path,
                toPath: prefPath.path
            )
            let dbPath = targetAppDir.appendingPathComponent("Documents/OONIProbe.db")
            print("Deleting \(dbPath.path)")
            try? FileManager.default.removeItem(at: dbPath)
            try? FileManager.default.removeItem(at: targetAppDir.appendingPathComponent("Documents/OONIProbe.db-wal"))
            try? FileManager.default.removeItem(at: targetAppDir.appendingPathComponent("Documents/OONIProbe.db-shm"))

            try! FileManager.default.copyItem(
                atPath: fixturesDir.appendingPathComponent("OONIProbe.db").path,
                toPath: dbPath.path
            )
            print("repo Root \(repoRoot)\n")
            print("targetAppDir \(targetAppDir.path)\n")
            print("sharedFolderURL \(containerDir.path)\n")
            print("appID: \(appID)\n")
        }
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
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

        tabBarsQuery.buttons["Test Results"].tap()
        let thepiratebayStaticText = tablesQuery.staticTexts["http://thepiratebay.org"]

        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.image, identifier:"websites")/*[[".cells.containing(.staticText, identifier:\"1 blocked\")",".cells.containing(.staticText, identifier:\"Websites\")",".cells.containing(.staticText, identifier:\"12\/12\/18, 1:23 AM\")",".cells.containing(.image, identifier:\"websites\")",".cells.containing(.staticText, identifier:\"39 tested\")"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.staticTexts["AS30722 - Vodafone Italia S.p.A."].tap()
        thepiratebayStaticText.tap()
        snapshot("03WebsiteBlocked")
        // We make the assumption the first button in the navigationbar hierarchy is the back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        resultsButton.tap()
        tablesQuery.cells.containing(.image, identifier:"performance").staticTexts["AS30722 - Vodafone Italia S.p.A."].tap()
        tablesQuery.cells.element(boundBy: 1).tap()
        snapshot("04SpeedTest")

        // We make the assumption the first button in the navigationbar hierarchy is the back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        dashboardButton.tap()
        tablesQuery.cells.element(boundBy: 0).tap()
        app.buttons["ConfigureButton"].tap()
        tablesQuery.cells.children(matching: .textField).element.tap()
        
        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        oKey.tap()
        
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        iKey.tap()
        oKey.tap()

        tablesQuery.children(matching: .other).element.children(matching: .button).element.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.tap()

        snapshot("05ChooseWebsite")

    }
    
}
