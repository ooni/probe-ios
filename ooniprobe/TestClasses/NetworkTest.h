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
@property int measurementIdx;
-(void)addTest:(NSString*)testName;
-(void)testEnded:(MKNetworkTest*)test;
-(void)runTestSuite;
@end

@interface WCNetworkTest : NetworkTest
-(id)initWithUrls:(NSArray*)urls andResult:(Result*)result;
-(void)runTestSuite;
-(void)setMaxRuntime;
@end

@interface IMNetworkTest : NetworkTest
-(id)initWithTest:(NSString*)test_name andResult:(Result*)result;
-(void)runTestSuite;
@end

@interface MBNetworkTest : NetworkTest
-(id)initWithTest:(NSString*)test_name andResult:(Result*)result;
-(void)runTestSuite;
@end

@interface SPNetworkTest : NetworkTest
-(id)initWithTest:(NSString*)test_name andResult:(Result*)result;
-(void)runTestSuite;
@end

