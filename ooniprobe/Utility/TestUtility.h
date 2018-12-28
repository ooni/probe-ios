#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Measurement.h"
#import "Url.h"
#import "Result.h"

@interface TestUtility : NSObject

//TODO deprecate color, category
+ (NSString*)getFileNamed:(NSString*)name;
+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;
+ (NSArray*)getTestsArray;
+ (NSString*)getCategoryForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName alpha:(CGFloat)alpha;
+ (void)downloadUrls:(void (^)(NSArray *))completion;
+ (void)removeFile:(NSString*)fileName;
//+ (NSString*)getDataForTest:(NSString*)testName;
@end
