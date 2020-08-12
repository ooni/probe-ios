#import "ExceptionUtility.h"
#import "SettingsUtility.h"

@implementation ExceptionUtility

+ (void)recordError:(NSString*)title reason:(NSString*)reason userInfo:(NSDictionary*)userInfo{
    NSException* exception = [NSException exceptionWithName:title
                                                         reason:reason
                                                       userInfo:userInfo];
    [Countly.sharedInstance recordHandledException:exception];
}

@end
