#import <Foundation/Foundation.h>
#import "Result.h"
#import "MKNetworkTest.h"
#import "SettingsUtility.h"

@interface NetworkTest : NSObject <MKNetworkTestDelegate>
@property Result *result;
@property NSMutableArray *mkNetworkTests;
-(void)testEnded:(MKNetworkTest*)test;
-(void)run;
@end

@interface IMNetworkTest : NetworkTest
-(void)run;
@end

@interface WCNetworkTest : NetworkTest
-(void)run;
@end

@interface MBNetworkTest : NetworkTest
-(void)run;
@end

@interface SPNetworkTest : NetworkTest
-(void)run;
@end

