#import "Measurement.h"

@implementation Measurement

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.uniqueId = [[NSDate date] timeIntervalSince1970];
    self.state = @"running";
    return self;
}

-(void)save{
    NSLog(@"uniqueId %ld", self.uniqueId);
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"dataUsage %ld", self.dataUsage);
    NSLog(@"ip %@", self.ip);
    NSLog(@"asn %ld", self.asn);
    NSLog(@"country %@", self.country);
    NSLog(@"networkName %@", self.networkName);
    NSLog(@"state %@", self.state);
    NSLog(@"failure %@", self.failure);
    NSLog(@"reportFile %@", self.reportFile);
    NSLog(@"reportId %@", self.reportId);
    NSLog(@"input %@", self.input);
    NSLog(@"measurementId %@", self.measurementId);
    NSLog(@"resultId %ld", self.resultId);
}

@end
