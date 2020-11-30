#import "TestUtility.h"
#import "Url.h"
#import "SettingsUtility.h"
#import "Suite.h"
#import "OONIApi.h"
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

+(void)deleteMeasurementWithReportId:(NSString*)report_id{
    for (Measurement *m in [Measurement selectWithReportId:report_id]){
        [TestUtility removeFile:[m getReportFile]];
    }
}

+ (void)deleteUploadedJsons{
    for (NSString *report_id in [Measurement getReportsUploaded]) {
        [OONIApi checkReportId:report_id onSuccess:^(BOOL found){
            if (found)
                [self deleteMeasurementWithReportId:report_id];
        } onError:^(NSError *error) {
            /* NOTHING */
        }];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:delete_json_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteOldLogs{
    for (Measurement *measurement in [Measurement measurementsWithLog]) {
        [TestUtility removeLogAfterADay:measurement];
    }
}

+ (void)removeLogAfterADay:(Measurement*)measurement{
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

/*
 Return the storage used in the Document folder (in bytes) from .json and .log files indluding db
 */
+ (uint64_t)storageUsed
{
    uint64_t usedSpace = 0;
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
    BOOL isDir;
     for (NSString *path in paths) {
         NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
         if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
             //Don't consider assets or resources directories
             if (!isDir){
                 NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
                 usedSpace += [fileAttributes fileSize];
             }
         }
    }
    return usedSpace;
}

+ (void)cleanUp{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
    BOOL isDir;
    for (NSString *path in paths) {
        NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            //Don't remove the database or other directories
            if (!isDir && ([path containsString:@".json"] || [path containsString:@".log"])){
                [fileManager removeItemAtPath:fullPath error:nil];
            }
        }
    }
    [SharkORM rawQuery:@"DELETE FROM Result;"];
    [SharkORM rawQuery:@"DELETE FROM Measurement;"];
    [SharkORM rawQuery:@"DELETE FROM Network;"];
    [SharkORM rawQuery:@"DELETE FROM Url;"];
    [SharkORM rawQuery:@"commit;"];
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

+ (JsonResult*)jsonResultfromDic:(NSDictionary*)jsonDic{
    InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
    ObjectMapper *mapper = [[ObjectMapper alloc] init];
    mapper.mappingProvider = mappingProvider;

    //Hack to add UTC format to dates
    [mappingProvider mapFromDictionaryKey:@"measurement_start_time" toPropertyKey:@"measurement_start_time" forClass:[JsonResult class] withTransformer:^id(id currentNode, id parentNode) {
        NSString *currentDateStr = [NSString stringWithFormat:@"%@Z", (NSString*)currentNode];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
        return [dateFormatter dateFromString:currentDateStr];
    }];
    [mappingProvider mapFromDictionaryKey:@"test_start_time" toPropertyKey:@"test_start_time" forClass:[JsonResult class] withTransformer:^id(id currentNode, id parentNode) {
        NSString *currentDateStr = [NSString stringWithFormat:@"%@Z", (NSString*)currentNode];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
        return [dateFormatter dateFromString:currentDateStr];
    }];
    [mappingProvider mapFromDictionaryKey:@"tampering" toPropertyKey:@"tampering" forClass:[TestKeys class] withTransformer:^id(id currentNode, id parentNode) {
        return [[Tampering alloc] initWithValue:currentNode];
    }];
    return [mapper objectFromSource:jsonDic toInstanceOfClass:[JsonResult class]];
}

@end
