#import <XCTest/XCTest.h>
#import "Result.h"
#define REPORT_ID @"REPORT_ID"

@interface ResultTest : XCTestCase

@end

@implementation ResultTest
Result *result;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[[Result query] fetch] remove];
    result = [Result new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNotUploaded {
    //No measurement, isEveryMeasurementUploaded true
    XCTAssert([result isEveryMeasurementUploaded]);
    Measurement *measurement = [Measurement new];
    measurement.result_id = result;
    [measurement save];
    //One measurement, isEveryMeasurementUploaded false
    XCTAssert(![result isEveryMeasurementUploaded]);
    measurement.is_uploaded = true;
    [measurement save];
    //Measurement uploaded but report_id null, isEveryMeasurementUploaded false
    XCTAssert(![result isEveryMeasurementUploaded]);
    measurement.report_id = REPORT_ID;
    [measurement save];
    //Measurement uploaded and wirh report_id, isEveryMeasurementUploaded true
    XCTAssert([result isEveryMeasurementUploaded]);
    
    Measurement *measurement2 = [Measurement new];
    measurement2.result_id = result;
    [measurement2 save];
    //Second measurement not uploaded, isEveryMeasurementUploaded false
    XCTAssert(![result isEveryMeasurementUploaded]);
    measurement2.is_failed = true;
    [measurement2 save];
    //Second measurement failed, isEveryMeasurementUploaded true
    XCTAssert([result isEveryMeasurementUploaded]);
}

@end
