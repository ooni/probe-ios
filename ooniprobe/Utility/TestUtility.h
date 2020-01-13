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
+ (void)deleteUploadedJsonsWithMeasurementRemover:(void (^)(Measurement *))remover;
+ (void)deleteUploadedJsons;
+ (void)removeLogAfterAWeek:(Measurement*)measurement;
+ (BOOL)canCallDeleteJson;
+ (void)downloadJson:(NSString*)urlStr onSuccess:(void (^)(NSDictionary*))successcb
    onError:(void (^)(NSError*))errorcb;
+ (BOOL)removeFile:(NSString*)fileName;
+ (BOOL)fileExists:(NSString*)fileName;
+ (NSString*)getUTF8FileContent:(NSString*)fileName;
+ (void)writeString:(NSString*)str toFile:(NSString*)fileName;
+ (NSUInteger)makeTimeout:(NSUInteger)bytes;
@end
