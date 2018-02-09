#import "Measurement.h"

@implementation Measurement

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.Id = [[NSDate date] timeIntervalSince1970];
    self.state = measurementActive;
    return self;
}

//UNUSED
-(NSString*)getReportFile{
    return [NSString stringWithFormat:@"test-%ld.json", self.Id];
}

//UNUSED
-(NSString*)getLogFile{
    return [NSString stringWithFormat:@"test-%ld.log", self.Id];
}

-(void)save{
    NSLog(@"---- START LOGGING MEASUREMENT OBJECT----");
    NSLog(@"Id %ld", self.Id);
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
    NSLog(@"reportId %@", self.reportId);
    NSLog(@"input %@", self.input);
    NSLog(@"category %@", self.category);
    NSLog(@"resultId %ld", self.resultId);
    NSLog(@"---- END LOGGING MEASUREMENT OBJECT----");
}


@end
