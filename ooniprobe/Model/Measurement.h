#import <Foundation/Foundation.h>

@interface Measurement : NSObject

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

@property (nonatomic, assign) NSInteger Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *asn;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *networkName;
@property (strong, nonatomic) NSString *networkType;

@property (nonatomic, assign) MeasurementStatus state;

@property (nonatomic, assign) NSInteger blocking;

@property (strong, nonatomic) NSString *reportId;

@property (strong, nonatomic) NSString *input;
@property (strong, nonatomic) NSString *category;

@property (nonatomic, assign) NSInteger resultId;

-(id)init;
-(void)save;

@end
