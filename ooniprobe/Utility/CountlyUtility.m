#import "CountlyUtility.h"
#import "SettingsUtility.h"
#import "Engine.h"

@implementation CountlyUtility

+ (void)initCountly {
    CountlyConfig* config = [CountlyConfig new];
    config.appKey = @"146836f41172f9e3287cab6f2cc347de3f5ddf3b";
    config.host = NOTIFICATION_SERVER;
    #ifdef DEBUG
        config.enableDebug = YES;
        config.pushTestMode = CLYPushTestModeDevelopment;
    #endif
    config.features = @[CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking];
    config.deviceID = [SettingsUtility getOrGenerateUUID4];
    config.requiresConsent = YES;
    [Countly.sharedInstance startWithConfig:config];
    [self reloadConsents];
}

+ (void)reloadConsents{
    [Countly.sharedInstance cancelConsentForAllFeatures];
    [Countly.sharedInstance giveConsentForFeature:CLYConsentLocation];

    if ([SettingsUtility isSendCrashEnabled])
        [Countly.sharedInstance giveConsentForFeature:CLYConsentCrashReporting];
    
    if ([SettingsUtility isSendAnalyticsEnabled])
        [Countly.sharedInstance giveConsentForFeatures:@[CLYConsentSessions,
                                                         CLYConsentViewTracking,
                                                         CLYConsentEvents]];

    if ([SettingsUtility isNotificationEnabled])
        [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications];
}

@end
