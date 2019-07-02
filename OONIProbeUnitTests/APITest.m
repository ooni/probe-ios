#import <XCTest/XCTest.h>
#import "Measurement.h"
#import "TestUtility.h"
#define EXISTING_REPORT_ID @"20190113T202156Z_AS327931_CgoC3KbgM6zKajvIIt1AxxybJ1HbjwwWJjsJnlxy9rpcGY54VH"
#define NONEXISTING_REPORT_ID @"EMPTY"

@interface APITest : XCTestCase

@end

@implementation APITest

- (void)setUp {
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExisting {
    //TODO test getExplorerUrlCallback with custom NSData
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExisting"];
    Measurement *measurement = [Measurement new];
    measurement.report_id = EXISTING_REPORT_ID;
    [measurement getExplorerUrl:^(NSString *measurement_url){
        XCTAssert(true);
        [expectation fulfill];
    } onError:^(NSError *error){
        XCTAssert(false);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        if(err != nil)
            XCTAssert(false);
    }];
}

- (void)testNonExisting {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testNonExisting"];
    Measurement *measurement = [Measurement new];
    measurement.report_id = NONEXISTING_REPORT_ID;
    [measurement getExplorerUrl:^(NSString *measurement_url){
        XCTAssert(false);
        [expectation fulfill];
    } onError:^(NSError *error){
        XCTAssert(true);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        if(err != nil)
            XCTAssert(false);
    }];
}

-(void)testDownloadUrls{
    //TODO test downloadUrlsCallback with custom NSData
    XCTestExpectation *expectation = [self expectationWithDescription:@"testNonExisting"];
    [TestUtility downloadUrls:^(NSArray *urls) {
        XCTAssert(true);
        [expectation fulfill];
    } onError:^(NSError *error) {
        XCTAssert(false);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        if(err != nil)
            XCTAssert(false);
    }];
}

@end
