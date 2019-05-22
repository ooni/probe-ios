#import <XCTest/XCTest.h>
#import "TestUtility.h"

@interface MakeTimeoutTest : XCTestCase

@end

@implementation MakeTimeoutTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testStandard {
    NSInteger bytes = 2000;
    NSInteger timeout = 11;
    XCTAssert([TestUtility makeTimeout:bytes] == timeout);
}

- (void)testZero {
    NSInteger zero = 0;
    NSInteger timeout = 10;
    XCTAssert([TestUtility makeTimeout:zero] == timeout);
}

- (void)testMax {
    NSInteger max = NSIntegerMax;
    NSInteger timeout = NSIntegerMax/2000+10;
    XCTAssert([TestUtility makeTimeout:max] == timeout);
}

@end
