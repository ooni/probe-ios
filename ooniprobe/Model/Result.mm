#import "Result.h"
#import "Measurement.h"
#import "TestUtility.h"

@implementation Result
@dynamic name, startTime, duration, summary, dataUsageUp, dataUsageDown, ip, asn, asnName, country, networkName, networkType, viewed, done;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"startTime": [NSDate date], @"duration" : [NSNumber numberWithInt:0], @"viewed" : [NSNumber numberWithBool:FALSE], @"done" : [NSNumber numberWithBool:FALSE], @"dataUsageDown" : [NSNumber numberWithInt:0], @"dataUsageUp" : [NSNumber numberWithInt:0]};
}

- (SRKResultSet*)measurements {
    return [[[[Measurement query] whereWithFormat:@"result = %@", self] orderByDescending:@"Id"] fetch];
}

-(void)setAsnAndCalculateName:(NSString *)asn{
    //TODO-SBS calculate asnname
    self.asnName = @"Vodafone";
    self.asn = asn;
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

-(void)setStartTimeWithUTCstr:(NSString*)dateStr{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *localDate = [dateFormatter dateFromString:dateStr];
    self.startTime = localDate;
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

//Shark supports indexing by overriding the indexDefinitionForEntity method and returning an SRKIndexDefinition object which describes all of the indexes that need to be maintained on the object.

/*
+ (SRKIndexDefinition *)indexDefinitionForEntity {
    SRKIndexDefinition* idx = [SRKIndexDefinition new];
    [idx addIndexForProperty:@"name" propertyOrder:SRKIndexSortOrderAscending];
    [idx addIndexForProperty:@"age" propertyOrder:SRKIndexSortOrderAscending];
    return idx;
}
*/

/*
 Three scenarios:
   I'm running the test, I start the empty summary, I add stuff and save
   I'm running the test, there is data in the summary, I add stuff and save
   I have to get the summary of an old test and don't modify it
 */
- (Summary*)getSummary{
    if (!self.summaryObj){
        if (self.summary)
            self.summaryObj = [[Summary alloc] initFromJson:self.summary];
        else
            self.summaryObj = [[Summary alloc] init];
    }
    return self.summaryObj;
}

- (void)setSummary{
    self.summary = [self.summaryObj getJsonStr];
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
