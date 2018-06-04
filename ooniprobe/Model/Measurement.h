#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>
#import "Result.h"

@interface Measurement : SRKObject

// The possible states of a measurements are:
// * active, while the measurement is in progress
// * failed, only option is re-runs
// * done, when it's finished, but not necessarily uploaded
// * uploaded, if it has been uploaded successfully
// * processed, if the pipeline has processed the measurement
typedef enum
{
    measurementActive,
    measurementFailed,
    measurementDone,
    measurementUploaded,
    measurementProcessed
} MeasurementState;

@property NSString *name;
@property NSDate *startTime;
@property float duration;
@property NSString *ip;
@property NSString *asn;
@property NSString *asnName;
@property NSString *country;
@property NSString *networkName;
@property NSString *networkType;

@property MeasurementState state;
@property BOOL anomaly;

@property Result *result;

@property NSString *reportId;

@property NSString *input;
@property NSString *category;

-(void)setStartTimeWithUTCstr:(NSString*)dateStr;
-(NSString*)getFile:(NSString*)ext;
-(NSString*)getReportFile;
-(NSString*)getLogFile;
-(void)save;
-(void)deleteObject;

@end
