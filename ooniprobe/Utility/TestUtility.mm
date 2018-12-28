#import "TestUtility.h"
#import "Url.h"
#import "SettingsUtility.h"
#import <mkall/MKGeoIPLookup.h>

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
    return @{@"websites": @[@"web_connectivity"], @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger"], @"performance": @[@"ndt", @"dash"], @"middle_boxes": @[@"http_invalid_request_line", @"http_header_field_manipulation"]};
}

//Used by dropdown
//TODO improve
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
    MKGeoIPLookupSettings *settings = [[MKGeoIPLookupSettings alloc] init];
    [settings setTimeout:17];
    MKGeoIPLookupResults *results = [settings perform];
    NSString *cc = @"XX";
    if ([results good])
        cc = [results getProbeCC];
    NSString *path = [NSString stringWithFormat:@"https://orchestrate.ooni.io/api/v1/test-list/urls?country_code=%@", cc];
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

+ (NSString*)getDataForTest:(NSString*)testName{
    if ([testName isEqualToString:@"performance"]){
        return @"5 - 200 MB";
    }
    else if ([testName isEqualToString:@"websites"]){
        return @"~ 8 MB";
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return @"< 1 MB";
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return @"< 1 MB";
    }
    return nil;
}

+ (long)numberOfTest:(NSString*)testName{
    return [[[Result query] where:@"test_group_name = ?" parameters:@[testName]] count];
}

@end
