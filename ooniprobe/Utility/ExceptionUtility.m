#import "ExceptionUtility.h"

@implementation ExceptionUtility

/*
//TODO
- add sentry
- call this class in the code
*/
-(void)recordError:(NSString*)title code:(NSInteger)code userInfo:(NSDictionary*)userInfo{
    [CrashlyticsKit recordError:[NSError errorWithDomain:title code:0 userInfo:userInfo]];
}

@end
