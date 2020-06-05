#import "TestUtility.h"
#import "Url.h"
#import "SettingsUtility.h"
#import "Suite.h"
#define delete_json_delay 86400
#define delete_json_key @"deleteUploadedJsons"

@implementation TestUtility

-(NSString*) getDate {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    return [dateformatter stringFromDate:[NSDate date]];
}

+ (NSString*)getFileNamed:(NSString*)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
    return fileName;
}

+ (NSDictionary*)getTests{
    return @{@"websites": @[@"web_connectivity"],
             @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger"],
             @"circumvention": @[@"psiphon", @"tor"],
             @"performance": @[@"ndt", @"dash", @"http_invalid_request_line", @"http_header_field_manipulation"]};
}

+ (NSMutableArray*)getTestObjects{
    NSMutableArray *tests = [[NSMutableArray alloc] init];
    [tests addObject:[[WebsitesSuite alloc] init]];
    [tests addObject:[[InstantMessagingSuite alloc] init]];
    [tests addObject:[[CircumventionSuite alloc] init]];
    [tests addObject:[[PerformanceSuite alloc] init]];
    return tests;
}
//Used by dropdown
+ (NSArray*)getTestTypes{
    return [[self getTests] allKeys];
}

//used by ooni run
+ (NSString*)getCategoryForTest:(NSString*)testName{
    NSDictionary *tests = [self getTests];
    NSArray *keys = [tests allKeys];
    for (NSString *key in keys){
        NSArray *arr = [tests objectForKey:key];
        for (NSString *str in arr)
            if ([str isEqualToString:testName])
                return key;
    }
    return nil;
}

//Used by notification service
+ (NSArray*)getTestsArray{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    NSDictionary *tests = [self getTests];
    NSArray *keys = [tests allKeys];
    for (NSString *key in keys){
        NSArray *arr = [tests objectForKey:key];
        [returnArr addObjectsFromArray:arr];
    }
    return returnArr;
}

+ (UIColor*)getColorForTest:(NSString*)testName{
    return [self getColorForTest:testName alpha:1.0f];
}

+ (UIColor*)getColorForTest:(NSString*)testName alpha:(CGFloat)alpha{
    if ([testName isEqualToString:@"websites"]){
        return [UIColor colorWithRGBHexString:color_indigo6 alpha:alpha];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [UIColor colorWithRGBHexString:color_fuchsia6 alpha:alpha];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [UIColor colorWithRGBHexString:color_violet8 alpha:alpha];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [UIColor colorWithRGBHexString:color_cyan6 alpha:alpha];
    }
    else if ([testName isEqualToString:@"circumvention"]){
        return [UIColor colorWithRGBHexString:color_pink6 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_blue5 alpha:alpha];
}

+ (UIColor*)getGradientColorForTest:(NSString*)testName{
    if ([testName isEqualToString:@"websites"]){
        return [UIColor colorWithRGBHexString:color_indigo3 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [UIColor colorWithRGBHexString:color_fuchsia3 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [UIColor colorWithRGBHexString:color_violet3 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [UIColor colorWithRGBHexString:color_cyan3 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"circumvention"]){
        return [UIColor colorWithRGBHexString:color_pink4 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_blue3 alpha:1.0f];
}

+ (void)deleteUploadedJsonsWithMeasurementRemover:(void (^)(Measurement *))remover {
    for (Measurement *measurement in [Measurement measurementsWithJson]) {
        [measurement getExplorerUrl:^(NSString *measurement_url){
            remover(measurement);
        } onError:^(NSError *error) {
            /* NOTHING */
        }];
    }
}

+ (void)deleteUploadedJsons{
    [self deleteUploadedJsonsWithMeasurementRemover:^(Measurement *measurement) {
        [TestUtility removeFile:[measurement getReportFile]];
        [TestUtility removeLogAfterAWeek:measurement];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:delete_json_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLogAfterAWeek:(Measurement*)measurement{
    NSTimeInterval timeSinceTest = [[NSDate date] timeIntervalSinceDate:measurement.start_time];
    if (timeSinceTest > delete_json_delay){
        [TestUtility removeFile:[measurement getLogFile]];
    }
}

+ (BOOL)canCallDeleteJson{
    NSDate *lastCalled =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:delete_json_key];
    
    if (lastCalled == nil){
        return YES;
    }
    NSTimeInterval timeSinceLastCall = [[NSDate date] timeIntervalSinceDate:lastCalled];
    if (timeSinceLastCall > delete_json_delay){
        return YES;
    }
    return NO;
}

+ (BOOL)removeFile:(NSString*)fileName {
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
    return success;
}

+ (BOOL)fileExists:(NSString*)fileName{
    NSString *filePath = [TestUtility getFileNamed:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
        return TRUE;
    return FALSE;
}

+ (NSString*)getUTF8FileContent:(NSString*)fileName{
    NSString *filePath = [TestUtility getFileNamed:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    return nil;
}

+ (void)writeString:(NSString*)str toFile:(NSString*)fileName{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString stringWithFormat:@"\n%@", str] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:fileName atomically:YES];
    }
}

+ (NSUInteger)makeTimeout:(NSUInteger)bytes{
    //Timeout dependent on the body size considering a minimum upload speed of 16 kbit/s + 10 s
    NSUInteger timeout = bytes / 2000 + 10;
    return timeout;
}

@end
