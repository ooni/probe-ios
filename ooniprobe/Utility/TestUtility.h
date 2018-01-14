#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestUtility : NSObject
//deprecated half

+ (void)showNotification:(NSString*)name;
+(NSString*) getFileName:(NSInteger)uniqueId ext:(NSString*)ext;
@end
