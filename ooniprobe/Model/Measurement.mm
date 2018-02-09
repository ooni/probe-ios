#import "Measurement.h"

@implementation Measurement
@dynamic name, startTime, endTime, ip, asn, country, networkName, networkType, state, blocking, input, category, result;
/*
-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.Id = [[NSDate date] timeIntervalSince1970];
    self.state = measurementActive;
    return self;
}
*/

//UNUSED
-(NSString*)getReportFile{
    return [NSString stringWithFormat:@"test-%@.json", self.Id];
}

//UNUSED
-(NSString*)getLogFile{
    return [NSString stringWithFormat:@"test-%@.log", self.Id];
}

-(void)save{
    [self commit];
    NSLog(@"---- START LOGGING MEASUREMENT OBJECT----");
    NSLog(@"%@", self);
    NSLog(@"logFile %@", [self getLogFile]);
    NSLog(@"reportFile %@", [self getReportFile]);
    /*
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"ip %@", self.ip);
    NSLog(@"asn %@", self.asn);
    NSLog(@"country %@", self.country);
    NSLog(@"networkName %@", self.networkName);
    NSLog(@"networkType %@", self.networkType);
    NSLog(@"state %ud", self.state);
    NSLog(@"blocking %ld", self.blocking);
    NSLog(@"logFile %@", [self getLogFile]);
    NSLog(@"reportFile %@", [self getReportFile]);
    //NSLog(@"reportId %@", self.reportId);
    NSLog(@"input %@", self.input);
    NSLog(@"category %@", self.category);
    NSLog(@"resultId %ld", self.resultId);
     */
    NSLog(@"---- END LOGGING MEASUREMENT OBJECT----");
}


@end
