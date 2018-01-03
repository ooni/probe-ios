#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestUtility : NSObject

+ (void)showNotification:(NSString*)name;
+(NSString*) getFileName:(NSInteger)uniqueId ext:(NSString*)ext;
@end
