#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>
#import "JsonResult.h"
#import "Measurement.h"
#define NOT_UPLOADED_QUERY @"is_failed = 0 AND (is_uploaded = 0 || report_id IS NULL)"

/// Results contains the results of a test suite (e.g. Instant messaging).
@interface Result : SRKObject

@property NSString *test_group_name;
@property NSDate *start_time;
@property float runtime;
@property BOOL is_viewed;
@property BOOL is_done;
@property long data_usage_up;
@property long data_usage_down;
@property Network *network_id;

- (long)totalMeasurements;
- (long)failedMeasurements;
- (long)okMeasurements;
- (long)anomalousMeasurements;
- (SRKResultSet*)notUploadedMeasurements;
-(NSString*)getAsn;
-(NSString*)getNetworkName;
-(NSString*)getNetworkNameOrAsn;
-(NSString*)getCountry;
-(NSString*)getFormattedDataUsageDown;
-(NSString*)getFormattedDataUsageUp;
-(NSString*)getLocalizedNetworkType;
-(void)addRuntime:(float)value;
-(NSString*)getLocalizedStartTime;
-(BOOL)isEveryMeasurementUploaded;
+(BOOL)isEveryResultUploaded:(SRKResultSet*)results;
-(void)save;
-(Measurement*)getMeasurement:(NSString*)name;
-(SRKResultSet*)measurements;
-(SRKResultSet*)allmeasurements;
-(NSString*)getLogFile:(NSString*)test_name;
-(void)deleteObject;
@end
