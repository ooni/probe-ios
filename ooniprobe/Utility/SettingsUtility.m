#import "SettingsUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"automated_testing", @"sharing", @"advanced"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)catName{
    if ([catName isEqualToString:@"notifications"]) {
        if ([self get_notifications])
            return @[@"notifications_enabled", @"notifications_completion", @"notifications_news"];
        else
            return @[@"notifications_enabled"];
    }
    else if ([catName isEqualToString:@"automated_testing"]) {
        if ([self get_automated_testing])
            return @[@"automated_testing_enabled", @"enabled_tests", @"website_categories", @"monthly_mobile_allowance", @"monthly_wifi_allowance"];
        else
            return @[@"automated_testing_enabled"];
    }
    else if ([catName isEqualToString:@"sharing"]) {
        return @[@"upload_results", @"include_ip", @"include_asn", @"include_gps"];
    }
    else if ([catName isEqualToString:@"advanced"]) {
        return @[@"send_crash", @"debug_logs", @"use_domain_fronting", @"include_cc"];
    }
    else
        return nil;
}

+ (NSString*)getTypeForSetting:(NSString*)setting{
    //TODO make array with type
    if ([setting isEqualToString:@"website_categories"] || [setting isEqualToString:@"enabled_tests"])
        return @"segue";
    else if ([setting isEqualToString:@"monthly_mobile_allowance"] || [setting isEqualToString:@"monthly_wifi_allowance"] || [setting isEqualToString:@"max_runtime"] || [setting isEqualToString:@"ndt_server_port"] || [setting isEqualToString:@"dash_server_port"])
        return @"int";
    else if ([setting isEqualToString:@"ndt_server"] || [setting isEqualToString:@"dash_server"] || [setting isEqualToString:@"custom_url"])
        return @"string";

    return @"bool";
}

+ (BOOL)get_notifications{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications_enabled"] boolValue];
}

+ (BOOL)get_automated_testing{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"automated_testing_enabled"] boolValue];
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

+ (NSArray*)getSettingsForTest:(NSString*)test_name {
    if ([test_name isEqualToString:@"website"]) {
        return @[@"website_categories", @"max_runtime", @"custom_url"];
    }
    else if ([test_name isEqualToString:@"instant_messaging"]) {
        return @[@"test_whatsapp", @"test_whatsapp_extensive", @"test_telegram", @"test_facebook"];
    }
    else if ([test_name isEqualToString:@"middle_boxes"]) {
        return @[@"run_http_invalid_request_line", @"run_http_header_field_manipulation"];
    }
    else if ([test_name isEqualToString:@"performance"]) {
        return @[@"run_ndt", @"ndt_server", @"ndt_server_port", @"run_dash", @"dash_server", @"dash_server_port"];
    }
    else
        return nil;
}

+ (BOOL)getSettingWithName:(NSString*)setting_name{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:setting_name] boolValue];
}
@end
