#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>
#import "JsonResult.h"
#import "Measurement.h"

@interface Result : SRKObject

//Data schema from https://github.com/ooni/probe-cli/blob/6d2ca54590314b2442a60901d33e6d429bb9ff84/data/migrations/1_create_msmt_results.sql

@property NSString *test_group_name;
@property NSDate *start_time;
@property float runtime;
@property BOOL is_viewed;
@property BOOL is_done;
@property long data_usage_up;
@property long data_usage_down;

- (long)totalMeasurements;
- (long)failedMeasurements;
- (long)okMeasurements;
- (long)anomalousMeasurements;
-(NSString*)getAsn;
-(NSString*)getAsnName;
-(NSString*)getCountry;
-(NSString*)getFormattedDataUsageDown;
-(NSString*)getFormattedDataUsageUp;
-(NSString*)getLocalizedNetworkType;
-(void)addRuntime:(float)value;
-(void)save;
-(Measurement*)getMeasurement:(NSString*)name;
-(SRKResultSet*)measurements;
-(NSString*)getLogFile:(NSString*)test_name;
-(void)deleteObject;
@end
