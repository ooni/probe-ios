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
-(void)testEnded:(MKNetworkTest*)test;
-(void)run;
@end

@interface IMNetworkTest : NetworkTest
-(void)run;
@end

@interface WCNetworkTest : NetworkTest
-(id)initWithUrls:(NSArray*)urls;
-(void)run;
@end

@interface MBNetworkTest : NetworkTest
-(void)run;
@end

@interface SPNetworkTest : NetworkTest
-(void)run;
@end

