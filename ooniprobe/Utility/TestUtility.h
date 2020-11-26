#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Measurement.h"
#import "Url.h"
#import "Result.h"

@interface TestUtility : NSObject

+ (NSString*)getFileNamed:(NSString*)name;
+ (NSDictionary*)getTests;
+ (NSMutableArray*)getTestObjects;
+ (NSArray*)getTestTypes;
+ (NSArray*)getTestsArray;
+ (NSString*)getCategoryForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName;
+ (UIColor*)getColorForTest:(NSString*)testName alpha:(CGFloat)alpha;
+ (UIColor*)getGradientColorForTest:(NSString*)testName;
+ (void)deleteMeasurementWithReportId:(NSString*)report_id;
+ (void)deleteUploadedJsons;
+ (void)deleteOldLogs;
+ (void)removeLogAfterADay:(Measurement*)measurement;
+ (BOOL)canCallDeleteJson;
+ (BOOL)removeFile:(NSString*)fileName;
+ (BOOL)fileExists:(NSString*)fileName;
+ (NSString*)getUTF8FileContent:(NSString*)fileName;
+ (void)writeString:(NSString*)str toFile:(NSString*)fileName;
+ (NSUInteger)makeTimeout:(NSUInteger)bytes;
+ (JsonResult*)jsonResultfromDic:(NSDictionary*)json_str;
+ (uint64_t)storageUsed;
+ (void)cleanUp;
@end
