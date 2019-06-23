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
    return [UIColor colorWithRGBHexString:color_blue5 alpha:alpha];
}

+ (void)downloadUrls:(void (^)(NSArray *))completion {
    MKGeoIPLookupTask *task = [[MKGeoIPLookupTask alloc] init];
    [task setTimeout:DEFAULT_TIMEOUT];
    MKGeoIPLookupResults *results = [task perform];
    NSString *cc = @"XX";
    if ([results good])
        cc = [results probeCC];
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
