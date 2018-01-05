#import "SettingsUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"sharing", @"orchestration", @"advanced"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)catName{
    //TODO return dic with key: type
    if ([catName isEqualToString:@"notifications"]) {
        return @[@"run_automatic_tests"];
    }
    else if ([catName isEqualToString:@"sharing"]) {
        if ([self get_upload_results])
            return @[@"upload_results", @"include_ip", @"include_asn", @"include_cc", @"send_crash"];
        else
            return @[@"upload_results", @"send_crash"];
    }
    else if ([catName isEqualToString:@"orchestration"]) {
        return @[];
    }
    else if ([catName isEqualToString:@"advanced"]) {
        return @[@"debug_logs"];
    }
    else
        return nil;
}

+ (NSArray*)getSettingsForTest:(NSString*)testName{
    return nil;
}

+ (BOOL)get_upload_results{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
}

@end
