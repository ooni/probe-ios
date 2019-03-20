#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Measurement.h"
#import "Url.h"
#import "Result.h"

@interface TestUtility : NSObject

+ (NSString*)getFileNamed:(NSString*)name;
+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;
+ (NSArray*)getTestsArray;
+ (NSString*)getCategoryForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName alpha:(CGFloat)alpha;
+ (void)downloadUrls:(void (^)(NSArray *))completion;
+ (void)removeFile:(NSString*)fileName;
+ (BOOL)isEveryMeasurementUploaded:(Result*)result;
+ (BOOL)isEveryResultUploaded:(SRKResultSet*)results;
@end
