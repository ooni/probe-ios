#import <XCTest/XCTest.h>
#import "Measurement.h"
#import "TestUtility.h"
#define EXISTING_REPORT_ID @"20200113T232417Z_AS577_JZoBZCfObPmU7bxkEKUImuWl40VEb00Q8ZYcifQj3MgchgjOVd"
#define EXISTING_REPORT_ID_2 @"20200113T235535Z_AS39891_ZsM2hkmJREbadpVf0dKARRLZFsrnX2LYI9PGi7HlyXFBwRyQGP"
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
    [TestUtility downloadUrls:^(NSArray *urls) {
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

- (void)testDeleteJsons {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteJsons"];
    [self addMeasurement:EXISTING_REPORT_ID writeFile:YES];
    [self addMeasurement:NONEXISTING_REPORT_ID writeFile:YES];
    [self addMeasurement:EXISTING_REPORT_ID_2 writeFile:YES];
    [self addMeasurement:NONEXISTING_REPORT_ID writeFile:YES];
    XCTAssert([[Measurement measurementsWithJson] count] == 4);
    __block int successes = 0;
    [TestUtility deleteUploadedJsonsWithMeasurementRemover:^(Measurement *measurement) {
        if ([measurement.report_id isEqualToString:EXISTING_REPORT_ID] ||
            [measurement.report_id isEqualToString:EXISTING_REPORT_ID_2]) {
            @synchronized (self) {
                successes++;
                if (successes == 2){
                    XCTAssert(true);
                    [expectation fulfill];
                }
            }
        } else {
            XCTAssert(false);
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *err) {
        XCTAssert(err == nil);
    }];
}

- (void)testJsonFromExplorer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testJsonFromExplorer"];
    [TestUtility downloadJson:JSON_URL
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
    [TestUtility downloadJson:NON_PARSABLE_URL
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
