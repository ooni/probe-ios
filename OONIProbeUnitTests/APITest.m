#import <XCTest/XCTest.h>
#import "Measurement.h"
#import "TestUtility.h"
#define EXISTING_REPORT_ID @"20190113T202156Z_AS327931_CgoC3KbgM6zKajvIIt1AxxybJ1HbjwwWJjsJnlxy9rpcGY54VH"
#define EXISTING_REPORT_ID_2 @"20190702T000027Z_AS5413_6FT78sjp5qnESDVWlFlm6bfxxwOEqR08ySAwigTF6C8PFCbMsM"
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
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDownloadUrls"];
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

- (void)testDeleteJsons {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteJsons"];
    Measurement *existing_1 = [self addMeasurement:EXISTING_REPORT_ID];
    Measurement *nonexisting_1 = [self addMeasurement:NONEXISTING_REPORT_ID];
    Measurement *existing_2 = [self addMeasurement:EXISTING_REPORT_ID_2];
    Measurement *nonexisting_2 = [self addMeasurement:NONEXISTING_REPORT_ID];
    [self deleteUploadedJsonsWithMeasurementRemover:^(Measurement *measurement) {
        if ([measurement.report_id isEqualToString:EXISTING_REPORT_ID] || [measurement.report_id isEqualToString:EXISTING_REPORT_ID_2])
            XCTAssert(true);
        else
            XCTAssert(false);
        //TODO how do i check that this callback has been called for both measurement in the if and fulfill only after that?
        [expectation fulfill];
    }];
}

-(Measurement*)addMeasurement:(NSString*)report_id {
    Measurement *measurement = [Measurement new];
    [TestUtility writeString:@"" toFile:[TestUtility getFileNamed:[measurement getReportFile]]];
    measurement.report_id = report_id;
    [measurement save];
    return measurement;
}


@end
