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
    NSLog(@"Id %ld", self.Id);
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"dataUsage %ld", self.dataUsage);
    NSLog(@"ip %@", self.ip);
    NSLog(@"asn %@", self.asn);
    NSLog(@"country %@", self.country);
    NSLog(@"networkName %@", self.networkName);
    NSLog(@"state %@", self.state);
    NSLog(@"blocking %@", self.blocking);
    NSLog(@"reportFile %@", self.reportFile);
    NSLog(@"reportId %@", self.reportId);
    NSLog(@"input %@", self.input);
    NSLog(@"resultId %ld", self.resultId);
}

@end
