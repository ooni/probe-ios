#import <Foundation/Foundation.h>
#import "Countly.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThirdPartyServices : NSObject

+ (void)initCountlyAnyway;
+ (void)reloadConsents;
+ (void)recordError:(NSString*)title reason:(NSString*)reason userInfo:(NSDictionary*)userInfo;

@end

NS_ASSUME_NONNULL_END
