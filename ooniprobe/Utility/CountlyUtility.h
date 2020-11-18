#import <Foundation/Foundation.h>
#import "Countly.h"

NS_ASSUME_NONNULL_BEGIN

@interface CountlyUtility : NSObject

+ (void)initCountly;
+ (void)reloadConsents;
+ (void)recordEvent:(NSString*)event;
+ (void)recordEvent:(NSString*)event segmentation:(NSDictionary*)segmentation;
+ (void)recordView:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
