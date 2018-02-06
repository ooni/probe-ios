#import <Foundation/Foundation.h>

@interface Measurement : NSObject

@property (nonatomic, assign) NSInteger uniqueId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (nonatomic, assign) NSInteger dataUsage;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *asn;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *networkName;

//states IRC are: running, done, uploaded
@property (strong, nonatomic) NSString *state;

@property (nonatomic, assign) NSInteger blocking;
//@property (strong, nonatomic) NSString *failure;

@property (strong, nonatomic) NSString *logFile;
@property (strong, nonatomic) NSString *reportFile;
@property (strong, nonatomic) NSString *reportId;

@property (strong, nonatomic) NSString *input;
@property (strong, nonatomic) NSString *category;
//TODO performance need upload and download

@property (nonatomic, assign) NSInteger resultId;

//mancano entry e anomaly. anomaly è gestita da failure

-(id)init;
-(void)save;

@end
