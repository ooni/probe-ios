#import "TestUtility.h"
#import "Url.h"
#import "SettingsUtility.h"
#import "Suite.h"
#import "OONIApi.h"
#define delete_logs_delay 604800
#define delete_json_delay 86400
#define delete_json_key @"deleteUploadedJsons"
#import "RunningTest.h"
#import "ReachabilityManager.h"

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
             @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger", @"signal"],
             @"circumvention": @[@"psiphon", @"tor", @"riseupvpn"],
             @"performance": @[@"ndt", @"dash", @"http_invalid_request_line", @"http_header_field_manipulation"]};
}

+ (NSMutableArray*)getTestObjects{
    NSMutableArray *tests = [[NSMutableArray alloc] init];
    [tests addObject:[[WebsitesSuite alloc] init]];
    [tests addObject:[[InstantMessagingSuite alloc] init]];
    [tests addObject:[[CircumventionSuite alloc] init]];
    [tests addObject:[[PerformanceSuite alloc] init]];
    [tests addObject:[[ExperimentalSuite alloc] init]];
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
        return [[UIColor colorNamed:@"color_indigo6"] colorWithAlphaComponent:alpha];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [[UIColor colorNamed:@"color_fuchsia6"] colorWithAlphaComponent:alpha];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [[UIColor colorNamed:@"color_violet8"] colorWithAlphaComponent:alpha];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [[UIColor colorNamed:@"color_cyan6"] colorWithAlphaComponent:alpha];
    }
    else if ([testName isEqualToString:@"circumvention"]){
        return [UIColor colorNamed:@"color_pink6"];
    }
    else if ([testName isEqualToString:@"experimental"]){
        return [UIColor colorNamed:@"color_gray7_1"];
    }
    return [[UIColor colorNamed:@"color_blue5"] colorWithAlphaComponent:alpha];
}

+ (UIColor*)getBackgroundColorForTest:(NSString*)testName {
    if ([testName isEqualToString:@"websites"]){
        return [UIColor colorNamed:@"color_indigo5"];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [UIColor colorNamed:@"color_fuchsia5"];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [UIColor colorNamed:@"color_violet7"];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [UIColor colorNamed:@"color_cyan5"];
    }
    else if ([testName isEqualToString:@"circumvention"]){
        return [UIColor colorNamed:@"color_pink5"];
    }
    else if ([testName isEqualToString:@"experimental"]){
        return [UIColor colorNamed:@"color_gray7_1"];
    }
    return [UIColor colorNamed:@"color_blue5"];
}

+ (UIColor*)getGradientColorForTest:(NSString*)testName{
    if ([testName isEqualToString:@"websites"]){
        return [UIColor colorNamed:@"color_indigo3"];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [UIColor colorNamed:@"color_fuchsia3"];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [UIColor colorNamed:@"color_violet3"];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [UIColor colorNamed:@"color_cyan3"];
    }
    else if ([testName isEqualToString:@"circumvention"]){
        return [UIColor colorNamed:@"color_pink4"];
    }
    else if ([testName isEqualToString:@"experimental"]){
        return [UIColor colorNamed:@"color_gray6"];
    }
    return [UIColor colorNamed:@"color_blue3"];
}

+(void)deleteMeasurementWithReportId:(NSString*)report_id{
    for (Measurement *m in [Measurement selectWithReportId:report_id]){
        [TestUtility removeFile:[m getReportFile]];
    }
}

+ (void)deleteUploadedJsons{
    for (NSString *report_id in [Measurement getReportsUploaded]) {
        [self deleteMeasurementWithReportId:report_id];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:delete_json_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteOldLogs{
    for (Measurement *measurement in [Measurement measurementsWithLog]) {
        [TestUtility removeLogAfterAWeek:measurement];
    }
}

+ (void)removeLogAfterAWeek:(Measurement*)measurement{
    NSTimeInterval timeSinceTest = [[NSDate date] timeIntervalSinceDate:measurement.start_time];
    if (timeSinceTest > delete_logs_delay){
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

+ (BOOL)checkConnectivity:(UIViewController *)view{
    if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] == NotReachable){
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil)
                               message:NSLocalizedString(@"Modal.Error.NoInternet", nil) inView:view];
        return false;
    }
    return true;
}

+ (BOOL)checkTestRunning:(UIViewController *)view{
    if ([RunningTest currentTest].isTestRunning){
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil)
                               message:NSLocalizedString(@"Modal.Error.TestAlreadyRunning", nil) inView:view];
        return false;
    }
    return true;
}

@end
