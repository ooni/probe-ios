#import "Result.h"
#import "TestUtility.h"

@implementation Result
@dynamic test_group_name, start_time, runtime, is_viewed, is_done, data_usage_up, data_usage_down;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"start_time": [NSDate date], @"runtime" : [NSNumber numberWithInt:0], @"is_viewed" : [NSNumber numberWithBool:FALSE], @"done" : [NSNumber numberWithBool:FALSE], @"data_usage_down" : [NSNumber numberWithInt:0], @"data_usage_up" : [NSNumber numberWithInt:0]};
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

-(Measurement*)getFirstMeasurement{
    SRKResultSet *measurements = [[[[Measurement query] where:@"result = ?" parameters:@[self]] orderByDescending:@"Id"] fetch];
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
    Measurement *measurement = [self getFirstMeasurement];
    if ([measurement.networkType isEqualToString:@"wifi"])
        return NSLocalizedString(@"TestResults.Summary.Hero.WiFi", nil);
    else if ([measurement.networkType isEqualToString:@"mobile"])
        return NSLocalizedString(@"TestResults.Summary.Hero.Mobile", nil);
    else if ([measurement.networkType isEqualToString:@"no_internet"])
        return NSLocalizedString(@"TestResults.Summary.Hero.NoInternet", nil);
    return @"";
}
    
-(void)addRuntime:(float)value{
    self.runtime+=value;
}

//https://stackoverflow.com/questions/7846495/how-to-get-file-size-properly-and-convert-it-to-mb-gb-in-cocoa
- (NSString*)getFormattedDataUsageUp{
    return [NSByteCountFormatter stringFromByteCount:self.data_usage_up
                                          countStyle:NSByteCountFormatterCountStyleFile];
}
    
- (NSString*)getFormattedDataUsageDown{
    return [NSByteCountFormatter stringFromByteCount:self.data_usage_down countStyle:NSByteCountFormatterCountStyleFile];
}

-(NSString*)getAsn{
    Measurement *measurement = [self getFirstMeasurement];
    if (measurement.asn != nil)
        return measurement.asn;
    return NSLocalizedString(@"TestResults.UnknownASN", nil);
}

-(NSString*)getAsnName{
    Measurement *measurement = [self getFirstMeasurement];
    if (measurement.asnName != nil)
        return measurement.asnName;
    return NSLocalizedString(@"TestResults.UnknownASN", nil);
}

-(NSString*)getCountry{
    Measurement *measurement = [self getFirstMeasurement];
    if (measurement.country != nil)
        return measurement.country;
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
