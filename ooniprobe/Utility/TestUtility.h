#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Measurement.h"

@interface TestUtility : NSObject

+ (void)showNotification:(NSString*)name;
+ (NSString*)getFileName:(Measurement*)measurement ext:(NSString*)ext;
+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;
+ (NSArray*)getTestsArray;
+ (NSString*)getCategoryForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName alpha:(CGFloat)alpha;
+ (NSArray*)getUrlsTest;
+ (NSString*)getCategoryForUrl:(NSString*)url;
+ (void)removeFile:(NSString*)fileName;
@end
