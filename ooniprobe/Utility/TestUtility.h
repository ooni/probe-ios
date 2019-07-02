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
+ (void)downloadUrls:(void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb;
+ (void)removeFile:(NSString*)fileName;
+ (BOOL)fileExists:(NSString*)fileName;
+ (NSString*)getUTF8FileContent:(NSString*)fileName;
+ (void)writeString:(NSString*)str toFile:(NSString*)fileName;
+ (NSUInteger)makeTimeout:(NSUInteger)bytes;
@end
