#import "Result.h"
#import "TestUtility.h"

@implementation Result
@dynamic name, startTime, duration, dataUsageUp, dataUsageDown, ip, asn, asnName, country, networkName, networkType, viewed, done;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"startTime": [NSDate date], @"duration" : [NSNumber numberWithInt:0], @"viewed" : [NSNumber numberWithBool:FALSE], @"done" : [NSNumber numberWithBool:FALSE], @"dataUsageDown" : [NSNumber numberWithInt:0], @"dataUsageUp" : [NSNumber numberWithInt:0]};
}

- (SRKResultSet*)measurements {
    return [[[[Measurement query] whereWithFormat:@"result = %@", self] orderByDescending:@"Id"] fetch];
}

-(Measurement*)getMeasurement:(NSString*)name{
    SRKResultSet *measurements = [[[[Measurement query] where:@"result = ? AND name = ?" parameters:@[self, name]] orderByDescending:@"Id"] fetch];
    if ([measurements count] > 0)
        return [measurements objectAtIndex:0];
    return nil;
}

- (long)totalMeasurements {
    SRKQuery *query = [[[Measurement query] whereWithFormat:@"result = %@", self] orderByDescending:@"Id"];
    return [query count];
}

- (long)failedMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result = ? AND state = ?" parameters:@[self, @"1"]];
    //SRKQuery *query = [[Measurement query] whereWithFormat:@"result = '%@' AND state = '%u'", self, measurementFailed];
    return [query count];
}

- (long)okMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result = ? AND state != ? AND anomaly = 0" parameters:@[self, @"1"]];
    //SRKQuery *query = [[Measurement query] whereWithFormat:@"result = '%@' AND state != '%u' AND anomaly = '0'", self, measurementFailed];
    /*SRKQuery *query = [[Measurement query] whereWithFormat:@"result = '%@'", self];
    query = [query whereWithFormat:@"state != '%u'", measurementFailed];
    query = [query where:@"anomaly = '0'"];
     */
    //SRKQuery *query = [[[[Measurement query] whereWithFormat:@"result = '%@'", self] whereWithFormat:@" state != '%u'", measurementFailed] where:@"anomaly = '0'"];

    return [query count];
}

- (long)anomalousMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result = ? AND anomaly = 1" parameters:@[self]];
    //SRKQuery *query = [[Measurement query] whereWithFormat:@"result = '%@' AND anomaly = '1'", self];
    return [query count];
}

-(NSString*)getLocalizedNetworkType{
    if ([self.networkType isEqualToString:@"wifi"])
        return NSLocalizedString(@"TestResults.Summary.Hero.WiFi", nil);
    else if ([self.networkType isEqualToString:@"mobile"])
        return NSLocalizedString(@"TestResults.Summary.Hero.Mobile", nil);
    else if ([self.networkType isEqualToString:@"no_internet"])
        return NSLocalizedString(@"TestResults.Summary.Hero.NoInternet", nil);
    return @"";
}
    
-(void)addDuration:(float)value{
    self.duration+=value;
}

//https://stackoverflow.com/questions/7846495/how-to-get-file-size-properly-and-convert-it-to-mb-gb-in-cocoa
- (NSString*)getFormattedDataUsageUp{
    return [NSByteCountFormatter stringFromByteCount:self.dataUsageUp countStyle:NSByteCountFormatterCountStyleFile];
}
    
- (NSString*)getFormattedDataUsageDown{
    return [NSByteCountFormatter stringFromByteCount:self.dataUsageDown countStyle:NSByteCountFormatterCountStyleFile];
}

-(NSString*)getAsn{
    if (self.asn != nil)
        return self.asn;
    return NSLocalizedString(@"TestResults.UnknownASN", nil);
}

-(NSString*)getAsnName{
    if (self.asnName != nil)
        return self.asnName;
    return NSLocalizedString(@"TestResults.UnknownASN", nil);
}

-(NSString*)getCountry{
    if (self.country != nil)
        return self.country;
    return NSLocalizedString(@"TestResults.UnknownASN", nil);
}

-(void)save{
    [self commit];
    /*
    NSLog(@"---- START LOGGING RESULT OBJECT----");
    NSLog(@"%@", self);
    NSLog(@"---- END LOGGING RESULT OBJECT----");
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resultUpdated" object:self];
}

-(void)deleteObject{
    for (Measurement* measurement in self.measurements){
        [TestUtility removeFile:[measurement getLogFile]];
        [TestUtility removeFile:[measurement getReportFile]];
        [measurement remove];
    }
    [self remove];
}

@end
