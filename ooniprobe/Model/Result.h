#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>
#import "JsonResult.h"
#import "Measurement.h"

@interface Result : SRKObject

@property NSString *name;
@property NSDate *startTime;
@property float duration;
@property long dataUsageDown;
@property long dataUsageUp;
@property NSString *ip;
@property NSString *asn;
@property NSString *asnName;
@property NSString *country;
@property NSString *networkName;
@property NSString *networkType;
@property BOOL viewed;
@property BOOL done;
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
-(void)addDuration:(float)value;
-(void)save;
-(Measurement*)getMeasurement:(NSString*)name;
-(SRKResultSet*)measurements;
-(void)deleteObject;
@end
