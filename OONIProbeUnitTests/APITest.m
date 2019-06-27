#import <XCTest/XCTest.h>
#import "Measurement.h"
#import "TestUtility.h"
#define EXISTING_REPORT_ID @"20190113T202156Z_AS327931_CgoC3KbgM6zKajvIIt1AxxybJ1HbjwwWJjsJnlxy9rpcGY54VH"
#define NONEXISTING_REPORT_ID @"EMPTY"

@interface APITest : XCTestCase

@end

@implementation APITest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExisting {
    Measurement *measurement = [Measurement new];
    measurement.report_id = EXISTING_REPORT_ID;
    [measurement getExplorerUrl:^(NSString *measurement_url){
        XCTAssert(true);
    } onError:^(NSError *error){
        XCTAssert(false);
    }];
}

- (void)testNonExisting {
    Measurement *measurement = [Measurement new];
    measurement.report_id = NONEXISTING_REPORT_ID;
    [measurement getExplorerUrl:^(NSString *measurement_url){
        XCTAssert(false);
    } onError:^(NSError *error){
        XCTAssert(true);
    }];
}

-(void)testDownloadUrls{
    [TestUtility downloadUrls:^(NSArray *urls) {
        XCTAssert(true);
    } onError:^(NSError *error) {
        XCTAssert(false);
    }];
}

@end
