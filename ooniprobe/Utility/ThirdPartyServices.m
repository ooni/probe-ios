#import "ThirdPartyServices.h"
#import "SettingsUtility.h"
#import "Engine.h"
#define APP_KEY_PROD @"146836f41172f9e3287cab6f2cc347de3f5ddf3b"
#define APP_KEY_DEV @"e6c2cfe53e85951d50567467cef3f9fa2eab32c3"
@import Sentry;

@implementation ThirdPartyServices

+ (void)initCountlyAnyway {
    CountlyConfig* config = [CountlyConfig new];
    config.host = NOTIFICATION_SERVER;
    #ifdef DEBUG
        //config.enableDebug = YES;
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
    [self reloadNotificationConsent];
}

+ (void)initCountly {
    if (![SettingsUtility isNotificationEnabled])
        return;
    [self initCountlyAnyway];
}

/* We can't shutdown the SDKs during the app lifecycle so we remove consent(s) if any setting changes
 * In case of Sentry the consent ad it's handled in the options.setBeforeSend
 * we don't init the SDK if we don't have crash consent
 */
+ (void)reloadConsents {
    [self reloadNotificationConsent];
    [self initSentry];
}

+ (void)reloadNotificationConsent{
    //If deviceID exist means the SDK has been initialized
    if ([Countly sharedInstance].deviceID != nil){
        [Countly.sharedInstance cancelConsentForAllFeatures];
        if ([SettingsUtility isNotificationEnabled]){
            [Countly.sharedInstance giveConsentForFeatures:@[CLYConsentLocation, CLYConsentPushNotifications]];
            [Countly.sharedInstance giveConsentForFeature:CLYConsentLocation];
            [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications];
        }
    }
    else
        [ThirdPartyServices initCountly];
}

+ (void)initSentry{
    if (![SettingsUtility isSendCrashEnabled])
        return;
    [SentrySDK startWithConfigureOptions:^(SentryOptions *options) {
        options.dsn = @"https://fc33135e184e402aa805fa48cd65f0a5@o155150.ingest.sentry.io/5619986";
        options.beforeSend = ^SentryEvent * _Nullable(SentryEvent * _Nonnull event) {
            // modify event here or return NULL to discard the event
            if (![SettingsUtility isSendCrashEnabled])
                return NULL;
            return event;
        };
    }];
}

+ (BOOL)isTestFlight{
    BOOL isRunningTestFlightBeta = [[[[NSBundle mainBundle] appStoreReceiptURL] lastPathComponent] isEqualToString:@"sandboxReceipt"];
    return isRunningTestFlightBeta;
}

+ (void)recordError:(NSString*)title reason:(NSString*)reason userInfo:(NSDictionary*)userInfo{
    if (![SettingsUtility isSendCrashEnabled])
        return;
    NSError *error = [NSError errorWithDomain:title
                                         code:-1001
                                     userInfo:userInfo];
    @try {
        [SentrySDK captureError:error];
    }@catch(NSException *e) {

    }@finally {
        NSLog(@"Failed reporting error");
    }

}

@end
