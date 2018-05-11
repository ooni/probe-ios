#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Measurement.h"

@interface TestUtility : NSObject

+ (void)showNotification:(NSString*)name;
+ (NSString*)getFileName:(Measurement*)measurement ext:(NSString*)ext;
+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;
+ (NSString*)getCategoryforTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName;
+ (NSArray*)getUrlsTest;
+ (void)removeFile:(NSString*)fileName;
@end
