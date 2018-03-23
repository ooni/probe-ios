#import "Result.h"
#import "Measurement.h"

@implementation Result
@dynamic name, startTime, duration, summary, dataUsageUp, dataUsageDown, ip, asn, asnName, country, networkName, networkType, done;

+ (NSDictionary *)defaultValuesForEntity {
    return @{@"startTime": [NSDate date], @"duration" : [NSNumber numberWithInt:0], @"done" : [NSNumber numberWithBool:FALSE], @"dataUsageDown" : [NSNumber numberWithInt:0], @"dataUsageUp" : [NSNumber numberWithInt:0]};
}

- (SRKResultSet*)measurements {
    return [[[Measurement query] whereWithFormat:@"result = %@", self] fetch];
}

-(void)setAsnAndCalculateName:(NSString *)asn{
    //TODO calculate asnname
    self.asnName = @"Vodafone";
    self.asn = asn;
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
    return @"";
}

-(NSString*)getAsnName{
    if (self.asnName != nil)
        return self.asnName;
    return @"";
}

-(NSString*)getCountry{
    if (self.country != nil)
        return self.country;
    return @"";
}

-(void)save{
    [self commit];
    NSLog(@"---- START LOGGING RESULT OBJECT----");
    NSLog(@"%@", self);
    NSLog(@"---- END LOGGING RESULT OBJECT----");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resultUpdated" object:self];
    /*
     NSLog(@"---- START LOGGING RESULT OBJECT----");
     NSLog(@"%@", self);
     NSLog(@"---- END LOGGING RESULT OBJECT----");
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"summary %@", self.summary);
    NSLog(@"dataUsageDown %ld", self.dataUsageDown);
    NSLog(@"dataUsageUp %ld", self.dataUsageUp);
     */
}

-(void)deleteObject{
    for (Measurement* measurement in self.measurements){
        [self removeFile:[measurement getLogFile]];
        [self removeFile:[measurement getReportFifle]];
        [measurement remove];
    }
    [self remove];
}

- (void)removeFile:(NSString*)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"File %@ deleted", fileName);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
