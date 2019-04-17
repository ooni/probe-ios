#import <XCTest/XCTest.h>
#import "Result.h"
#define REPORT_ID @"REPORT_ID"

@interface ResultTest : XCTestCase

@end

@implementation ResultTest
Result *result;
Measurement *measurement;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[[Result query] fetch] remove];
    result = [Result new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(void)addMeasurement {
    measurement = [Measurement new];
    measurement.result_id = result;
    [measurement save];
}

- (void)testNoMeasurements {
    //No measurement, isEveryMeasurementUploaded true
    XCTAssert([result isEveryMeasurementUploaded]);
}

- (void)testNotUploaded {
    //One measurement, isEveryMeasurementUploaded false
    [self addMeasurement];
    XCTAssert(![result isEveryMeasurementUploaded]);
}

- (void)testUploaded {
    //Measurement uploaded but report_id null, isEveryMeasurementUploaded false
    [self addMeasurement];
    measurement.is_uploaded = true;
    [measurement save];
    XCTAssert(![result isEveryMeasurementUploaded]);
}

- (void)testUploadedAndReport {
    //Measurement uploaded and with report_id, isEveryMeasurementUploaded true
    [self addMeasurement];
    measurement.is_uploaded = true;
    measurement.report_id = REPORT_ID;
    [measurement save];
    XCTAssert([result isEveryMeasurementUploaded]);
}

- (void)testFailed {
    //Measurement failed, isEveryMeasurementUploaded true
    [self addMeasurement];
    measurement.is_failed = true;
    [measurement save];
    XCTAssert([result isEveryMeasurementUploaded]);
}

@end
