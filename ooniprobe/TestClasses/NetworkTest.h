#import <Foundation/Foundation.h>
#import "Result.h"
#import "MKNetworkTest.h"
#import "MKNetworkTests.h"
#import "SettingsUtility.h"
#import "MessageUtility.h"
#import "Url.h"

@interface NetworkTest : NSObject <MKNetworkTestDelegate>
@property Result *result;
@property NSMutableArray *mkNetworkTests;
-(id)initWithMeasurement:(Measurement*)existingMeasurement;
-(void)addTest:(NSString*)testName :(NSArray*)urls;
-(void)testEnded:(MKNetworkTest*)test;
-(void)runTestSuite;
@end

@interface WCNetworkTest : NetworkTest
-(id)initWithUrls:(NSArray*)urls;
-(void)runTestSuite;
@end

@interface IMNetworkTest : NetworkTest
-(void)runTestSuite;
@end

@interface MBNetworkTest : NetworkTest
-(void)runTestSuite;
@end

@interface SPNetworkTest : NetworkTest
-(void)runTestSuite;
@end

