#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <measurement_kit/common.hpp>
//#import "TestLists.h"
#import "Measurement.h"

@protocol MKNetworkTestDelegate <NSObject>
-(void)test_ended;
@end

@interface MKNetworkTest : NSObject
@property mk::Settings options;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSString *name;
@property float progress;
@property Measurement *measurement;
@property NSArray *inputs;
@property BOOL max_runtime_enabled;
@property id<MKNetworkTestDelegate> delegate;

-(void) run;
@end


@interface HTTPInvalidRequestLine : MKNetworkTest
@end

@interface DNSInjection : MKNetworkTest
@end

@interface TCPConnect : MKNetworkTest
@end

@interface WebConnectivity : MKNetworkTest
@end

@interface NdtTest : MKNetworkTest
@end

@interface HttpHeaderFieldManipulation : MKNetworkTest
@end

@interface Dash : MKNetworkTest
@end

@interface Whatsapp : MKNetworkTest
@end

@interface Telegram : MKNetworkTest
@end

@interface FacebookMessenger : MKNetworkTest
@end

