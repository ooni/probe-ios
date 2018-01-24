#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <measurement_kit/common.hpp>
#import "SettingsUtility.h"
#import "Measurement.h"

@class MKNetworkTest;

@protocol MKNetworkTestDelegate <NSObject>
-(void)testEnded:(MKNetworkTest*)test;
@end

@interface MKNetworkTest : NSObject

@property mk::Settings options;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSString *name;
@property float progress;
@property int idx;
@property Measurement *measurement;
@property NSArray *inputs;
@property BOOL max_runtime_enabled;
@property id<MKNetworkTestDelegate> delegate;
@property NSInteger resultId;

-(void) run;
@end

@interface WebConnectivity : MKNetworkTest
@end

@interface HttpInvalidRequestLine : MKNetworkTest
@end

@interface HttpHeaderFieldManipulation : MKNetworkTest
@end

@interface NdtTest : MKNetworkTest
@end

@interface Dash : MKNetworkTest
@end

@interface Whatsapp : MKNetworkTest
@end

@interface Telegram : MKNetworkTest
@end

@interface FacebookMessenger : MKNetworkTest
@end

