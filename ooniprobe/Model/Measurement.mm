#import "Measurement.h"

@implementation Measurement
@dynamic name, startTime, endTime, ip, asn, asnName, country, networkName, networkType, state, blocking, input, category, result;

-(void)setAsn:(NSString *)asn{
    //TODO calculate asnname
    self.asnName = @"Vodafone";
    self.asn = asn;
}

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
    NSLog(@"---- END LOGGING MEASUREMENT OBJECT----");
    /*
     NSLog(@"---- START LOGGING MEASUREMENT OBJECT----");
     NSLog(@"%@", self);
     NSLog(@"---- END LOGGING MEASUREMENT OBJECT----");
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
}


@end
