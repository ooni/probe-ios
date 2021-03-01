#import "CountlyUtility.h"
#import "SettingsUtility.h"
#import "Engine.h"
#define APP_KEY_PROD @"146836f41172f9e3287cab6f2cc347de3f5ddf3b"
#define APP_KEY_DEV @"e6c2cfe53e85951d50567467cef3f9fa2eab32c3"
@import Firebase;

@implementation CountlyUtility

+ (void)initCountly {
    CountlyConfig* config = [CountlyConfig new];
    config.host = NOTIFICATION_SERVER;
    #ifdef DEBUG
        config.enableDebug = YES;
        config.pushTestMode = CLYPushTestModeDevelopment;
        config.appKey = APP_KEY_DEV;
    #else
        if ([self isTestFlight])
            config.appKey = APP_KEY_DEV;
        else
            config.appKey = APP_KEY_PROD;
    #endif
    config.features = @[CLYPushNotifications];
    config.deviceID = [SettingsUtility getOrGenerateUUID4];
    config.requiresConsent = YES;
    [Countly.sharedInstance startWithConfig:config];
    [self reloadConsents];
}

+ (void)reloadConsents{
    [Countly.sharedInstance cancelConsentForAllFeatures];
    [Countly.sharedInstance giveConsentForFeature:CLYConsentLocation];
    [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:[SettingsUtility isSendCrashEnabled]];
    
    if ([SettingsUtility isSendAnalyticsEnabled])
        [Countly.sharedInstance giveConsentForFeatures:@[CLYConsentSessions,
                                                         CLYConsentViewTracking,
                                                         CLYConsentEvents]];

    if ([SettingsUtility isNotificationEnabled])
        [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications];
}

+ (void)recordEvent:(NSString*)event{
    [Countly.sharedInstance recordEvent:event];
}

+ (void)recordEvent:(NSString*)event segmentation:(NSDictionary*)segmentation{
    [Countly.sharedInstance recordEvent:event segmentation:segmentation];
}

+ (void)recordView:(NSString*)name{
    [Countly.sharedInstance recordView:name];
}

+ (BOOL)isTestFlight{
    BOOL isRunningTestFlightBeta = [[[[NSBundle mainBundle] appStoreReceiptURL] lastPathComponent] isEqualToString:@"sandboxReceipt"];
    return isRunningTestFlightBeta;
}

@end
