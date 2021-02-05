#import "ExceptionUtility.h"
#import "SettingsUtility.h"
@import Firebase;
@import Sentry;

@implementation ExceptionUtility

+ (void)recordError:(NSString*)title reason:(NSString*)reason userInfo:(NSDictionary*)userInfo{
    //Preparing NSError for Firebase
    NSError *error = [NSError errorWithDomain:title
                                         code:-1001
                                     userInfo:userInfo];
    [[FIRCrashlytics crashlytics] recordError:error];
    [SentrySDK captureError:error];
}

@end
