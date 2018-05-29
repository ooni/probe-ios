#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>
#import "Result.h"

@interface Measurement : SRKObject

// The possible states of a measurements are:
// * active, while the measurement is in progress
// * done, when it's finished, but not necessarily uploaded
// * uploaded, if it has been uploaded successfully
// * processed, if the pipeline has processed the measurement
typedef enum
{
    measurementActive = 1,
    measurementDone,
    measurementUploaded,
    measurementProcessed
} MeasurementStatus;

@property NSString *name;
@property NSDate *startTime;
@property float duration;
@property NSString *ip;
@property NSString *asn;
@property NSString *asnName;
@property NSString *country;
@property NSString *networkName;
@property NSString *networkType;

@property MeasurementStatus state;

@property int blocking;

@property Result *result;

@property NSString *reportId;

@property NSString *input;
@property NSString *category;

-(void)setStartTimeWithUTCstr:(NSString*)dateStr;
-(void)setAsnAndCalculateName:(NSString *)asn;
-(NSString*)getFile:(NSString*)ext;
-(NSString*)getReportFile;
-(NSString*)getLogFile;
-(void)save;
-(void)deleteObject;

@end
