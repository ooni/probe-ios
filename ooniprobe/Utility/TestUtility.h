#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestUtility : NSObject

+ (void)showNotification:(NSString*)name;
+ (NSString*)getFileName:(NSNumber*)uniqueId ext:(NSString*)ext;
+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;
+ (UIColor*)getColorForTest:(NSString*)testName;
+ (NSArray*)getUrlsTest;

@end
