//
//  OONIProbeUITests.m
//  OONIProbeUITests
//
//  Created by Arturo Filastò on 11/12/2018.
//  Copyright © 2018 OONI. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OONIProbeUITests-Swift.h"

@interface OONIProbeUITests : XCTestCase

@end

@implementation OONIProbeUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *window = [[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0];
    [[[[[[window childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeButton].element tap];
    [Snapshot snapshot:@"01Onboarding" timeWaitingForIdle:10];
    
    XCUIElement *trueButton = app.buttons[@"True "];
    [trueButton tap];
    [trueButton tap];
    [app.buttons[@"Let's go"] tap];
    
    [Snapshot snapshot:@"02Dashboard" timeWaitingForIdle:10];

    XCUIElementQuery *tablesQuery = app.tables;
    [/*@START_MENU_TOKEN@*/[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Websites"]/*[["tablesQuery","[",".cells containingType:XCUIElementTypeStaticText identifier:@\"~120s\"]",".cells containingType:XCUIElementTypeStaticText identifier:@\"Test the blocking of websites\"]",".cells containingType:XCUIElementTypeStaticText identifier:@\"Websites\"]"],[[[-1,0,1]],[[1,4],[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/.buttons[@"Run"] tap];
    
    XCUIElement *dashboardButton = app.tabBars.buttons[@"Dashboard"];
    [dashboardButton tap];
    [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Instant Messaging"].buttons[@"Run"] tap];
    [dashboardButton tap];
    [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Performance"].buttons[@"Run"] tap];
    [Snapshot snapshot:@"03Results" timeWaitingForIdle:10];

    [dashboardButton tap];

}

@end
