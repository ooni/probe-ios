#import "Result.h"
#import "TestUtility.h"

@implementation Result
@dynamic test_group_name, start_time, network_id, is_viewed, is_done, data_usage_up, data_usage_down;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"start_time": [NSDate date]};
}

- (SRKResultSet*)measurements {
    //Not showing the re_run measurements
    return [[[[[[Measurement query]
               where:@"result_id = ? AND is_rerun = 0 AND is_done = 1"
               parameters:@[self]]
               orderByDescending:@"is_anomaly"]
               orderByDescending:@"is_failed"]
               orderByDescending:@"Id"]
               fetch];
}

- (SRKResultSet*)allmeasurements {
    return [[[[Measurement query] where:@"result_id = ?" parameters:@[self]] orderByDescending:@"Id"] fetch];
}

-(Measurement*)getMeasurement:(NSString*)name{
    SRKResultSet *measurements = [[[[Measurement query] where:@"result_id = ? AND test_name = ? AND is_rerun = 0" parameters:@[self, name]] orderByDescending:@"Id"] fetch];
    if ([measurements count] > 0)
        return [measurements objectAtIndex:0];
    return nil;
}

- (long)totalMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result_id = ? AND is_rerun = 0" parameters:@[self]];
    return [query count];
}

- (long)failedMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result_id = ? AND is_rerun = 0 AND is_done = 1 AND is_failed = 1" parameters:@[self]];
    return [query count];
}

- (long)okMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result_id = ? AND is_rerun = 0 AND is_done = 1 AND is_failed = 0 AND is_anomaly = 0" parameters:@[self]];
    return [query count];
}

- (long)anomalousMeasurements {
    SRKQuery *query = [[Measurement query] where:@"result_id = ? AND is_rerun = 0 AND is_done = 1 AND is_failed = 0 AND is_anomaly = 1" parameters:@[self]];
    return [query count];
}

- (SRKQuery*)notUploadedQuery{
    return [[Measurement query] where:[NSString stringWithFormat:@"result_id = ? AND %@", NOT_UPLOADED_QUERY] parameters:@[self]];
}

- (SRKResultSet*)notUploadedMeasurements {
    return [[self notUploadedQuery] fetch];
}

- (BOOL)isEveryMeasurementUploaded{
    if ([[self notUploadedQuery] count] == 0)
        return true;
    return false;
}

+ (BOOL)isEveryResultUploaded:(SRKResultSet*)results{
    SRKQuery *query = [[Measurement query] where:NOT_UPLOADED_QUERY];
    if ([query count] == 0)
        return true;
    return false;
}

-(NSString*)getLocalizedNetworkType{
    if (self.network_id.network_type != nil) {
        if ([self.network_id.network_type isEqualToString:@"wifi"])
            return NSLocalizedString(@"TestResults.Summary.Hero.WiFi", nil);
        else if ([self.network_id.network_type isEqualToString:@"mobile"])
            return NSLocalizedString(@"TestResults.Summary.Hero.Mobile", nil);
        else if ([self.network_id.network_type isEqualToString:@"no_internet"])
            return NSLocalizedString(@"TestResults.Summary.Hero.NoInternet", nil);
    }
    return @"";
}

-(Measurement*)getFirstMeasurement{
    SRKResultSet *measurements = [[[[[Measurement query]
                                    where:@"result_id = ? AND is_rerun = 0"
                                    parameters:@[self]]
                                   order:@"start_time"]
                                  limit:1] fetch];
    if ([measurements count] > 0)
        return [measurements objectAtIndex:0];
    return nil;
}

-(Measurement*)getLastMeasurement{
    SRKResultSet *measurements = [[[[[Measurement query]
                                    where:@"result_id = ? AND is_rerun = 0"
                                    parameters:@[self]]
                                   orderByDescending:@"start_time"]
                                  limit:1] fetch];
    if ([measurements count] > 0)
        return [measurements objectAtIndex:0];
    return nil;
}

-(float)getRuntime{
    Measurement *first = [self getFirstMeasurement];
    Measurement *last = [self getLastMeasurement];
    NSTimeInterval secondsBetweenTests = [last.start_time timeIntervalSinceDate:first.start_time];
    return secondsBetweenTests + last.runtime;
}

//https://stackoverflow.com/questions/7846495/how-to-get-file-size-properly-and-convert-it-to-mb-gb-in-cocoa
- (NSString*)getFormattedDataUsageUp{
    return [NSByteCountFormatter stringFromByteCount:self.data_usage_up*1024
                                          countStyle:NSByteCountFormatterCountStyleFile];
}

- (NSString*)getFormattedDataUsageDown{
    return [NSByteCountFormatter stringFromByteCount:self.data_usage_down*1024 countStyle:NSByteCountFormatterCountStyleFile];
}

-(NSString*)getAsn{
    if (self.network_id == nil)
        return NSLocalizedString(@"TestResults.UnknownASN", nil);
    return [self.network_id getAsn];
}

-(NSString*)getNetworkName{
    if (self.network_id == nil)
        return NSLocalizedString(@"TestResults.UnknownASN", nil);
    return [self.network_id getNetworkName];
}

-(NSString*)getNetworkNameOrAsn{
    if (self.network_id == nil)
        return NSLocalizedString(@"TestResults.UnknownASN", nil);
    return [self.network_id getNetworkNameOrAsn];
}

-(NSString*)getCountry{
    if (self.network_id == nil)
        return NSLocalizedString(@"TestResults.UnknownASN", nil);
    return [self.network_id getCountry];
}

-(NSString*)getLogFile:(NSString*)test_name{
    return [NSString stringWithFormat:@"%@-%@.log", self.Id, test_name];
}

-(NSString*)getLocalizedStartTime{
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:self.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    return localizedDateTime;
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
    for (Measurement* measurement in self.allmeasurements){
        [measurement deleteObject];
    }
    [self.network_id remove];
    [self remove];
}

@end
