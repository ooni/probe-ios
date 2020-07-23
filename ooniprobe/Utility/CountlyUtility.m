#import "CountlyUtility.h"
#import "SettingsUtility.h"

@implementation CountlyUtility

+ (void)initCountly {
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"146836f41172f9e3287cab6f2cc347de3f5ddf3b";
    config.host = NOTIFICATION_SERVER;
    #ifndef DEBUG
        config.enableDebug = YES;
    #endif
    config.features = @[CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking];
    config.deviceID = @"Lorenzo-iOS";
    config.requiresConsent = YES;
    config.pushTestMode = CLYPushTestModeDevelopment;
    //config.pushTestMode = CLYPushTestModeTestFlightOrAdHoc;
    [Countly.sharedInstance startWithConfig:config];
    [self reloadConsents];
}

+ (void)reloadConsents{
    //TODO-COUNTLY handle give remove consent from settings
    [Countly.sharedInstance cancelConsentForAllFeatures];

    if ([SettingsUtility isSendCrash])
        [Countly.sharedInstance giveConsentForFeature:CLYConsentCrashReporting];
    
    if ([SettingsUtility isSendAnalytics])
        [Countly.sharedInstance giveConsentForFeatures:@[CLYConsentSessions,
                                                         CLYConsentViewTracking,
                                                         CLYConsentEvents]];

    if ([SettingsUtility isNotification])
        [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications];
}

@end
