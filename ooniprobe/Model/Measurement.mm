#import "Measurement.h"

@implementation Measurement

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.Id = [[NSDate date] timeIntervalSince1970];
    self.state = @"running";
    return self;
}

-(void)save{
    NSLog(@"---- START LOGGING MEASUREMENT OBJECT----");
    NSLog(@"Id %ld", self.Id);
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"dataUsageDown %ld", self.dataUsageDown);
    NSLog(@"dataUsageUp %ld", self.dataUsageUp);
    NSLog(@"ip %@", self.ip);
    NSLog(@"asn %@", self.asn);
    NSLog(@"country %@", self.country);
    NSLog(@"networkName %@", self.networkName);
    
    //TODO missing 3gwifi
    NSLog(@"state %@", self.state);
    NSLog(@"blocking %@", self.blocking);
    NSLog(@"logFile %@", self.logFile);
    NSLog(@"reportFile %@", self.reportFile);
    NSLog(@"reportId %@", self.reportId);
    NSLog(@"input %@", self.input);
    NSLog(@"category %@", self.category);
    NSLog(@"resultId %ld", self.resultId);
    NSLog(@"---- END LOGGING MEASUREMENT OBJECT----");
}


@end
