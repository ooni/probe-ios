#import "SettingsUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"automated_testing", @"sharing", @"advanced", @"about_ooni"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)catName{
    if ([catName isEqualToString:@"notifications"]) {
        if ([self getSettingWithName:@"notifications_enabled"])
            return @[@"notifications_enabled", @"notifications_completion", @"notifications_news"];
        else
            return @[@"notifications_enabled"];
    }
    else if ([catName isEqualToString:@"automated_testing"]) {
        if ([self getSettingWithName:@"automated_testing_enabled"])
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
    if ([setting isEqualToString:@"website_categories"] || [setting isEqualToString:@"enabled_tests"] || [setting isEqualToString:@"custom_url"])
        return @"segue";
    else if ([setting isEqualToString:@"monthly_mobile_allowance"] || [setting isEqualToString:@"monthly_wifi_allowance"] || [setting isEqualToString:@"max_runtime"] || [setting isEqualToString:@"ndt_server_port"] || [setting isEqualToString:@"dash_server_port"])
        return @"int";
    else if ([setting isEqualToString:@"ndt_server"] || [setting isEqualToString:@"dash_server"])
        return @"string";
    return @"bool";
}

+ (NSDictionary*)getTests{
    return @{@"websites": @[@"web_connectivity"], @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger"], @"middle_boxes": @[@"http_invalid_request_line", @"http_header_field_manipulation"], @"performance": @[@"ndt", @"dash"]};
}

+ (NSArray*)getTestTypes{
    return @[@"websites", @"instant_messaging", @"middle_boxes", @"performance"];
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
    //TODO redo all with nsmutablearray for semplicity
    if ([test_name isEqualToString:@"website"]) {
        return @[@"website_categories", @"max_runtime", @"custom_url"];
    }
    else if ([test_name isEqualToString:@"instant_messaging"]) {
        if ([self getSettingWithName:@"test_whatsapp"])
            return @[@"test_whatsapp", @"test_whatsapp_extensive", @"test_telegram", @"test_facebook"];
        else
            return @[@"test_whatsapp", @"test_telegram", @"test_facebook"];
    }
    else if ([test_name isEqualToString:@"middle_boxes"]) {
        return @[@"run_http_invalid_request_line", @"run_http_header_field_manipulation"];
    }
    else if ([test_name isEqualToString:@"performance"]) {
        NSMutableArray *settings = [[NSMutableArray alloc] init];
        [settings addObject:@"run_ndt"];
        if ([self getSettingWithName:@"run_ndt"]){
            [settings addObject:@"ndt_server_auto"];
            if (![self getSettingWithName:@"ndt_server_auto"]){
                [settings addObject:@"ndt_server"];
                [settings addObject:@"ndt_server_port"];
            }
        }
        [settings addObject:@"run_dash"];
        if ([self getSettingWithName:@"run_dash"]){
            [settings addObject:@"dash_server_auto"];
            if (![self getSettingWithName:@"dash_server_auto"]){
                [settings addObject:@"dash_server"];
                [settings addObject:@"dash_server_port"];
            }
        }
        return settings;
        /*
        if ([self getSettingWithName:@"ndt_server_auto"] && [self getSettingWithName:@"dash_server_auto"])
            //TODO keep ports?
            //TODO remove server settings when disable tests ?
            return @[@"run_ndt", @"ndt_server_auto", @"run_dash", @"dash_server_auto"];
        else if ([self getSettingWithName:@"ndt_server_auto"])
            return @[@"run_ndt", @"ndt_server_auto", @"run_dash", @"dash_server_auto", @"dash_server", @"dash_server_port"];
        else if ([self getSettingWithName:@"dash_server_auto"])
            return @[@"run_ndt", @"ndt_server_auto", @"ndt_server", @"ndt_server_port", @"run_dash", @"dash_server_auto"];
        else
            return @[@"run_ndt", @"ndt_server_auto", @"ndt_server", @"ndt_server_port", @"run_dash", @"dash_server_auto", @"dash_server", @"dash_server_port"];
         */
    }
    else
        return nil;
}

+ (BOOL)getSettingWithName:(NSString*)setting_name{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:setting_name] boolValue];
}
@end
