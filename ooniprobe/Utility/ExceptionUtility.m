#import "ExceptionUtility.h"
#import "SettingsUtility.h"
@import Firebase;

@implementation ExceptionUtility

+ (void)recordError:(NSString*)title reason:(NSString*)reason userInfo:(NSDictionary*)userInfo{
    NSError *error = [NSError errorWithDomain:title
                                         code:-1001
                                     userInfo:userInfo];
    [[FIRCrashlytics crashlytics] recordError:error];
}

@end
