#import <Foundation/Foundation.h>

@interface Measurement : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (nonatomic, assign) NSInteger dataUsageDown;
@property (nonatomic, assign) NSInteger dataUsageUp;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *asn;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *networkName;

//TODO which one to keep?
@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifi3g;

//states IRC are: running, done, uploaded
@property (strong, nonatomic) NSString *state;

@property (nonatomic, assign) NSInteger blocking;

@property (strong, nonatomic) NSString *logFile;
@property (strong, nonatomic) NSString *reportFile;
@property (strong, nonatomic) NSString *reportId;

@property (strong, nonatomic) NSString *input;
@property (strong, nonatomic) NSString *category;

@property (nonatomic, assign) NSInteger resultId;

-(id)init;
-(void)save;

@end
