#import <XCTest/XCTest.h>
#import "Measurement.h"
#import "TestUtility.h"
#import "OONIApi.h"
#define EXISTING_REPORT_ID @"20190113T202156Z_AS327931_CgoC3KbgM6zKajvIIt1AxxybJ1HbjwwWJjsJnlxy9rpcGY54VH"
#define EXISTING_REPORT_ID_2 @"20190702T000027Z_AS5413_6FT78sjp5qnESDVWlFlm6bfxxwOEqR08ySAwigTF6C8PFCbMsM"
#define NONEXISTING_REPORT_ID @"EMPTY"
#define NON_PARSABLE_URL @"https://\t"
#define JSON_URL @"https://api.ooni.io/api/v1/measurement/temp-id-263478291"
@interface APITest : XCTestCase

@end

@implementation APITest

- (void)setUp {
    /*
     We clean all files from simulator
     Not really needed for testing purpose
     as we only check Measurements with linked files,
     needed to don't leave garbage around.
    */
    [self removeAllFiles];
    [[[Measurement query] fetch] remove];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExisting {
    //TODO test getExplorerUrlCallback with custom NSData
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExisting"];
    Measurement *measurement = [self addMeasurement:EXISTING_REPORT_ID
                                          writeFile:NO];
    [measurement getExplorerUrl:^(NSString *measurement_url){
        XCTAssert(true);
        [expectation fulfill];
    } onError:^(NSError *error){
        XCTAssert(false);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        XCTAssert(err == nil);
    }];
}

- (void)testNonExisting {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testNonExisting"];
    Measurement *measurement = [self addMeasurement:NONEXISTING_REPORT_ID
                                          writeFile:NO];
    [measurement getExplorerUrl:^(NSString *measurement_url){
        XCTAssert(false);
        [expectation fulfill];
    } onError:^(NSError *error){
        XCTAssert(true);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        XCTAssert(err == nil);
    }];
}

-(void)testDownloadUrls{
    //TODO test downloadUrlsCallback with custom NSData
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDownloadUrls"];
    [OONIApi downloadUrls:^(NSArray *urls) {
        XCTAssert(true);
        [expectation fulfill];
    } onError:^(NSError *error) {
        XCTAssert(false);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        XCTAssert(err == nil);
    }];
}

- (void)testSelectMeasurementsWithJson {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteJsons"];
    [self addMeasurement:EXISTING_REPORT_ID writeFile:YES];
    [OONIApi checkReportId:EXISTING_REPORT_ID onSuccess:^(BOOL found){
        XCTAssert(found);
        [expectation fulfill];
    } onError:^(NSError *error) {
        XCTAssert(false);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        XCTAssert(err == nil);
    }];
}

- (void)testJsonFromExplorer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testJsonFromExplorer"];
    [OONIApi downloadJson:JSON_URL
                    onSuccess:^(NSDictionary *urls) {
                        XCTAssert(true);
                        [expectation fulfill];
                    } onError:^(NSError *error) {
                        XCTAssert(false);
                        [expectation fulfill];
                    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
      XCTAssert(err == nil);
    }];
}

- (void)testMalformedURL {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testMalformedURL"];
    [OONIApi downloadJson:NON_PARSABLE_URL
                    onSuccess:^(NSDictionary *urls) {
                        XCTAssert(false);
                        [expectation fulfill];
                    } onError:^(NSError *error) {
                        XCTAssert(true);
                        [expectation fulfill];
                    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *err) {
        XCTAssert(err == nil);
    }];
}

-(Measurement*)addMeasurement:(NSString*)report_id writeFile:(BOOL)report{
    //Simulating measurement done and uploaded
    Measurement *measurement = [Measurement new];
    measurement.report_id = report_id;
    measurement.is_done = 1;
    measurement.is_uploaded = 1;
    [measurement save];
    //The report has to be written after the DB object is saved
    if (report)
        [TestUtility writeString:@"" toFile:[TestUtility getFileNamed:[measurement getReportFile]]];
    return measurement;
}

- (void)removeAllFiles {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains
                                   (NSDocumentDirectory, NSUserDomainMask, YES)
                                   lastObject];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentDirectory error:&error];
    XCTAssert(error == nil);
    for(NSString *sourceFileName in contents) {
        NSString *sourceFile = [documentDirectory stringByAppendingPathComponent:sourceFileName];
        [fileManager removeItemAtPath:sourceFile error:&error];
    }
}

@end
