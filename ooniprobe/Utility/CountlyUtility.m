#import "CountlyUtility.h"

@implementation CountlyUtility

- (void)initCountly {
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"146836f41172f9e3287cab6f2cc347de3f5ddf3b";
    config.host = NOTIFICATION_SERVER;
    #ifndef DEBUG
        config.enableDebug = YES;
    #endif
    config.features = @[CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking];
    config.deviceID = @"TODO";

    [Countly.sharedInstance startWithConfig:config];
}

@end
