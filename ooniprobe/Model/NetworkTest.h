#import <Foundation/Foundation.h>
#import "Result.h"
#import "MKNetworkTest.h"

@interface NetworkTest : NSObject <MKNetworkTestDelegate>
@property Result *result;
@property NSMutableArray *mk_network_tests;
-(void)test_ended;
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

