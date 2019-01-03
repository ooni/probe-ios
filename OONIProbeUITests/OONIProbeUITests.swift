//
//  OONIProbeUITests.swift
//  OONIProbeUITests
//  Created by Arturo Filastò on 11/12/2018.
//  Copyright © 2018 OONI. All rights reserved.
//

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

            //7E5DBB2A-6BE3-4102-995E-5A2280445854/Documents/OONIProbe.db
            
            // running on the simulator. We'll write to ~/Library/Caches
            let simulatorHomeDirURL = URL(fileURLWithPath: simulatorSharedDir)
            let containerDir = simulatorHomeDirURL.appendingPathComponent("Containers/Data/Application")
            
            let appDirs = try! FileManager.default.contentsOfDirectory(atPath: containerDir.path)

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
            let dbPath = targetAppDir.appendingPathComponent("Documents/OONIProbe.db")
            try? FileManager.default.removeItem(at: prefPath)
            try! FileManager.default.copyItem(
                atPath: fixturesDir.appendingPathComponent("org.openobservatory.ooniprobe.plist").path,
                toPath: targetAppDir.appendingPathComponent("Library/Preferences/org.openobservatory.ooniprobe.plist").path
            )
            try? FileManager.default.removeItem(at: dbPath)
            try! FileManager.default.copyItem(
                atPath: fixturesDir.appendingPathComponent("OONIProbe.db").path,
                toPath: targetAppDir.appendingPathComponent("Documents/OONIProbe.db").path
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

    func testDashboard() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Dashboard"].tap()
        snapshot("01Dashboard")
    }

}
