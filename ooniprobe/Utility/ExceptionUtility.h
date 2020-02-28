#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExceptionUtility : NSObject

+ (void)recordError:(NSString*)title code:(NSInteger)code userInfo:(NSDictionary*)userInfo;

@end

NS_ASSUME_NONNULL_END
