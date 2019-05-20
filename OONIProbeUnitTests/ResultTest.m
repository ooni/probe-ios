#import <XCTest/XCTest.h>
#import "Result.h"
#define REPORT_ID @"REPORT_ID"

@interface ResultTest : XCTestCase

@end

@implementation ResultTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // TODO(lorenzoPrimi): we need to be able to use a specific DB for tests
    [[[Result query] fetch] remove];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(Measurement*)addMeasurement:(Result*)result {
    Measurement *measurement = [Measurement new];
    measurement.result_id = result;
    [measurement save];
    return measurement;
}

- (void)testNoMeasurements {
    //No measurement, isEveryMeasurementUploaded true
    Result *result = [Result new];
    XCTAssert([result isEveryMeasurementUploaded]);
}

- (void)testNotUploaded {
    //One measurement, with is_done false, isEveryMeasurementUploaded true
    Result *result = [Result new];
    [self addMeasurement:result];
    XCTAssert([result isEveryMeasurementUploaded]);
}

- (void)testUploaded {
    //Measurement uploaded but report_id null, isEveryMeasurementUploaded false
    Result *result = [Result new];
    Measurement *measurement = [self addMeasurement:result];
    measurement.is_uploaded = true;
    measurement.is_done = true;
    [measurement save];
    XCTAssert(![result isEveryMeasurementUploaded]);
}

- (void)testUploadedAndReport {
    //Measurement uploaded and with report_id, isEveryMeasurementUploaded true
    Result *result = [Result new];
    Measurement *measurement = [self addMeasurement:result];
    measurement.is_uploaded = true;
    measurement.report_id = REPORT_ID;
    [measurement save];
    XCTAssert([result isEveryMeasurementUploaded]);
}

- (void)testFailed {
    //Measurement failed, isEveryMeasurementUploaded true
    Result *result = [Result new];
    Measurement *measurement = [self addMeasurement:result];
    measurement.is_failed = true;
    [measurement save];
    XCTAssert([result isEveryMeasurementUploaded]);
}

@end
