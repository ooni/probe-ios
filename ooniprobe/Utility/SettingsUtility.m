#import "SettingsUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"automated_testing", @"sharing", @"advanced"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)catName{
    if ([catName isEqualToString:@"notifications"]) {
        if ([self get_notifications])
            return @[@"enabled", @"", @""];
        else
            return @[@"enabled"];
    }
    else if ([catName isEqualToString:@"automated_testing"]) {
        return @[@"enabled", @"enabled_tests", @"website_categories", @"monthly_mobile_allowance", @"monthly_wifi_allowance"];
    }
    else if ([catName isEqualToString:@"sharing"]) {
        return @[@"upload_results", @"include_ip", @"include_asn", @"include_gps"];
    }
    else if ([catName isEqualToString:@"advanced"]) {
        return @[@"send_crash", @"debug_logs", @"use_domain_fronting", @"include_cc",];
    }
    else
        return nil;
}

+ (NSString*)getTypeForSetting:(NSString*)setting{
    if ([setting isEqualToString:@"website_categories"] || [setting isEqualToString:@"enabled_tests"])
        return @"segue";
    return @"bool";
}

+ (NSArray*)getSettingsForTest:(NSString*)testName{
    return nil;
}

+ (BOOL)get_notifications{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications"] boolValue];
}

+ (BOOL)get_upload_results{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
}

+ (NSDictionary*)getTests{
    return @{@"website": @[@"web_connectivity"], @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger"], @"middle_boxes": @[@"http_invalid_request_line", @"http_header_field_manipulation"], @"performance": @[@"ndt", @"dash"]};
}

+ (NSArray*)getTestTypes{
    return @[@"website", @"instant_messaging", @"middle_boxes", @"performance"];
}


+ (NSArray*)getAutomaticTestsEnabled{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"automatic_tests"];
}

+ (NSArray*)addRemoveAutomaticTest:(NSString*)test_name{
    NSMutableArray *automatic_tests = [[self getAutomaticTestsEnabled] mutableCopy];
    if ([automatic_tests containsObject:test_name])
        [automatic_tests removeObject:test_name];
    else
        [automatic_tests addObject:test_name];
    [[NSUserDefaults standardUserDefaults] setObject:automatic_tests forKey:@"automatic_tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return automatic_tests;
}

+ (NSArray*)getSitesCategories{
    return @[@"ALDR", @"REL", @"PORN", @"PROV", @"POLR", @"HUMR", @"ENV", @"MILX", @"HATE", @"NEWS", @"XED", @"PUBH", @"GMB", @"ANON", @"DATE", @"GRP", @"LGBT", @"FILE", @"HACK", @"COMT", @"MMED", @"HOST", @"SRCH", @"GAME", @"CULTR", @"ECON", @"GOVT", @"COMM", @"CTRL", @"IGO", @"MISC"];
}
+ (NSArray*)getSitesCategoriesEnabled {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"sites_categories"];
}

+ (void)addRemoveSitesCategory:(NSString*)category_name {
    NSMutableArray *sites_categories = [[self getSitesCategories] mutableCopy];
    if ([sites_categories containsObject:category_name])
        [sites_categories removeObject:category_name];
    else
        [sites_categories addObject:category_name];
    [[NSUserDefaults standardUserDefaults] setObject:sites_categories forKey:@"sites_categories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
