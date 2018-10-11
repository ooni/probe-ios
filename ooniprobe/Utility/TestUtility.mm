#import "TestUtility.h"
#import "Url.h"
#import "SettingsUtility.h"

#define ANOMALY_GREEN 0
#define ANOMALY_ORANGE 1
#define ANOMALY_RED 2

#define PERFORMANCE_TIME 60
#define MIDDLEBOXES_TIME 6
#define INSTANTMESSAGING_TIME 7

@implementation TestUtility


+ (void)showNotification:(NSString*)name {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Notification.FinishedRunning", nil), [LocalizationUtility getNameForTest:name]];
        [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    });
}

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

-(int)checkAnomaly:(NSDictionary*)test_keys{
    /*
     null => anomal = 1,
     false => anomaly = 0,
     stringa (dns, tcp-ip, http-failure, http-diff) => anomaly = 2
     
     Return values:
     0 == OK,
     1 == orange,
     2 == red
     */
    id element = [test_keys objectForKey:@"blocking"];
    int anomaly = ANOMALY_GREEN;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
        anomaly = ANOMALY_ORANGE;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        anomaly = ANOMALY_RED;
    }
    return anomaly;
}

+ (NSDictionary*)getTests{
    return @{@"websites": @[@"web_connectivity"], @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger"], @"performance": @[@"ndt", @"dash"], @"middle_boxes": @[@"http_invalid_request_line", @"http_header_field_manipulation"]};
}

+ (NSArray*)getTestTypes{
    return @[@"websites", @"instant_messaging", @"performance", @"middle_boxes"];
}

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
    if ([testName isEqualToString:@"websites"]){
        return [UIColor colorWithRGBHexString:color_indigo6 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [UIColor colorWithRGBHexString:color_fuchsia6 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [UIColor colorWithRGBHexString:color_violet8 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [UIColor colorWithRGBHexString:color_cyan6 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_blue5 alpha:1.0f];
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
    return [UIColor colorWithRGBHexString:color_blue5 alpha:alpha];
}

+ (void)downloadUrls:(void (^)(NSArray *))completion {
    //TODO automatical discovery https://github.com/ooni/orchestra/issues/49
    NSString *path = @"https://events.proteus.test.ooni.io/api/v1/urls?country_code=MX";
    if ([[SettingsUtility getSitesCategoriesDisabled] count] > 0){
        NSMutableArray *categories = [NSMutableArray arrayWithArray:[SettingsUtility getSitesCategories]];
        [categories removeObjectsInArray:[SettingsUtility getSitesCategoriesDisabled]];
        path = [NSString stringWithFormat:@"%@&category_codes=%@", path, [categories componentsJoinedByString:@","]];
    }
    NSURL *url = [NSURL URLWithString:path];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *urlsArray = [dic objectForKey:@"results"];
            NSMutableArray *urls = [[NSMutableArray alloc] init];
            for (NSDictionary* current in urlsArray){
                //List for database
                Url *url = [Url checkExistingUrl:[current objectForKey:@"url"] categoryCode:[current objectForKey:@"category_code"] countryCode:[current objectForKey:@"country_code"]];
                //List for mk
                [urls addObject:url.url];
            }
            completion(urls);
        }
        else {
            // Fail
            completion(nil);
            NSLog(@"error : %@", error.description);
        }
    }];
    [downloadTask resume];
}

+ (void)removeFile:(NSString*)fileName {
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

+ (int)getTotalTimeForTest:(NSString*)testName{
    if ([testName isEqualToString:@"websites"]){
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        return [max_runtime intValue]+30;
    }
    else {
        long totalTests = [self numberOfTest:testName];
        if (totalTests > 0){
            SRKQuery *query = [[Result query] where:[NSString stringWithFormat:@"test_group_name = '%@'", testName]];
            float runtime = [query sumOf:@"runtime"];
            return runtime/totalTests;
        }
        else if ([testName isEqualToString:@"performance"]){
            return PERFORMANCE_TIME;
        }
        else if ([testName isEqualToString:@"middle_boxes"]){
            return MIDDLEBOXES_TIME;
        }
        else if ([testName isEqualToString:@"instant_messaging"]){
            return INSTANTMESSAGING_TIME;
        }
    }
    return 0;
}

+ (NSString*)getDataForTest:(NSString*)testName{
    if ([testName isEqualToString:@"performance"]){
        return NSLocalizedString(@"Consumes data based on your network speed", nil);
    }
    else {
        long totalTests = [self numberOfTest:testName];
        if (totalTests > 0){
            SRKQuery *query = [[Result query] where:[NSString stringWithFormat:@"test_group_name = '%@'", testName]];
            double dataUsageDown = [query sumOf:@"data_usage_down"];
            double dataUsageUp = [query sumOf:@"data_usage_up"];
            return [NSString stringWithFormat:@"up %f down %f", dataUsageUp/totalTests, dataUsageDown/totalTests];
        }
        else if ([testName isEqualToString:@"websites"]){
            return @"down 500 kb UP 500 kb";
        }
        else if ([testName isEqualToString:@"middle_boxes"]){
            return @"down 9 kb UP 6 kb";
        }
        else if ([testName isEqualToString:@"instant_messaging"]){
            return @"down 35 kb UP 20 kb";
        }
    }
    return nil;
}

+ (long)numberOfTest:(NSString*)testName{
    return [[[Result query] where:@"test_group_name = ?" parameters:@[testName]] count];
}

@end
