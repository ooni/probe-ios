#import <Foundation/Foundation.h>
#import "Countly.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExceptionUtility : NSObject

+ (void)recordError:(NSString*)title reason:(NSString*)reason userInfo:(NSDictionary*)userInfo;

@end

NS_ASSUME_NONNULL_END
