#import "SettingsUtility.h"
#import "TestUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    //TODO ORCHESTRA reenable @"automated_testing"
    return @[@"sharing", @"test_options", @"privacy", @"advanced", @"send_email", @"about_ooni"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)categoryName{
    //TODO NEWS reenable @"notifications_news"
    if ([categoryName isEqualToString:@"notifications"]) {
        return @[@"notifications_enabled"];
    }
    else if ([categoryName isEqualToString:@"sharing"]) {
        //TODO GPS @"include_gps"
        return @[@"upload_results", @"upload_results_manually", @"include_asn", @"include_ip"];
    }
    else if ([categoryName isEqualToString:@"privacy"]) {
        return @[@"send_analytics", @"send_crash"];
    }
    else if ([categoryName isEqualToString:@"advanced"]) {
        //TODO DOMAIN FRONTING @"use_domain_fronting"
        return @[@"debug_logs"];
    }
    else if ([categoryName isEqualToString:@"test_options"]) {
        return [TestUtility getTestTypes];
    }
    else if ([[TestUtility getTestTypes] containsObject:categoryName])
        return [SettingsUtility getSettingsForTest:categoryName :YES];
    else
        return nil;
}

+ (NSString*)getTypeForSetting:(NSString*)setting{
    if ([setting isEqualToString:@"website_categories"] || [[TestUtility getTestTypes] containsObject:setting])
        return @"segue";
    else if ([setting isEqualToString:@"monthly_mobile_allowance"] || [setting isEqualToString:@"monthly_wifi_allowance"] || [setting isEqualToString:@"max_runtime"])
        return @"int";
    return @"bool";
}

+ (NSArray*)getAutomaticTestsEnabled{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"automatic_tests"];
}

+ (NSString*)getVerbosity {
    if ([self getSettingWithName:@"debug_logs"])
        return @"DEBUG2";
    return @"INFO";
}

+ (NSArray*)addRemoveAutomaticTest:(NSString*)testName{
    NSMutableArray *automaticTests = [[self getAutomaticTestsEnabled] mutableCopy];
    if ([automaticTests containsObject:testName])
        [automaticTests removeObject:testName];
    else
        [automaticTests addObject:testName];
    [[NSUserDefaults standardUserDefaults] setObject:automaticTests forKey:@"automatic_tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return automaticTests;
}

+ (NSArray*)getSitesCategories{
    return @[@"ANON",
             @"COMT",
             @"CTRL",
             @"CULTR",
             @"ALDR",
             @"COMM",
             @"ECON",
             @"ENV",
             @"FILE",
             @"GMB",
             @"GAME",
             @"GOVT",
             @"HACK",
             @"HATE",
             @"HOST",
             @"HUMR",
             @"IGO",
             @"LGBT",
             @"MMED",
             @"MISC",
             @"NEWS",
             @"DATE",
             @"POLR",
             @"PORN",
             @"PROV",
             @"PUBH",
             @"REL",
             @"SRCH",
             @"XED",
             @"GRP",
             @"MILX"];
}

+ (NSArray*)getSitesCategoriesDisabled {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"categories_disabled"];
}

+ (long)getNumberCategoriesEnabled{
    return [[self getSitesCategories] count] - [[self getSitesCategoriesDisabled] count];
}

+ (NSArray*)addRemoveSitesCategory:(NSString*)categoryName {
    NSMutableArray *categories_disabled = [[self getSitesCategoriesDisabled] mutableCopy];
    if ([categories_disabled containsObject:categoryName])
        [categories_disabled removeObject:categoryName];
    else
        [categories_disabled addObject:categoryName];
    [[NSUserDefaults standardUserDefaults] setObject:categories_disabled forKey:@"categories_disabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return categories_disabled;
}

+ (NSArray*)getSettingsForTest:(NSString*)testName :(BOOL)includeAll{
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    if ([testName isEqualToString:@"websites"]) {
        if (includeAll) [settings addObject:@"website_categories"];
        if (includeAll) [settings addObject:@"max_runtime_enabled"];
        if (includeAll && [self getSettingWithName:@"max_runtime_enabled"])
            [settings addObject:@"max_runtime"];
    }
    else if ([testName isEqualToString:@"instant_messaging"]) {
        [settings addObject:@"test_whatsapp"];
        if (includeAll && [self getSettingWithName:@"test_whatsapp"])
            [settings addObject:@"test_whatsapp_extensive"];
        [settings addObject:@"test_telegram"];
        [settings addObject:@"test_facebook_messenger"];
    }
    else if ([testName isEqualToString:@"circumvention"]) {
        [settings addObject:@"test_psiphon"];
        [settings addObject:@"test_tor"];
    }
    else if ([testName isEqualToString:@"performance"]) {
        [settings addObject:@"run_ndt"];
        [settings addObject:@"run_dash"];
        [settings addObject:@"run_http_invalid_request_line"];
        [settings addObject:@"run_http_header_field_manipulation"];
    }
    return settings;
}

+ (BOOL)getSettingWithName:(NSString*)settingName{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:settingName] boolValue];
}

+ (NSString*)get_push_token{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"]){
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    }
    return @"";
}

+ (void)set_push_token:(NSString*)push_token{
    [[NSUserDefaults standardUserDefaults] setObject:push_token forKey:@"push_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isSendCrash {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"send_crash"] boolValue];
}

+ (BOOL)isSendAnalytics {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"send_analytics"] boolValue];
}

+ (BOOL)isNotification {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications_enabled"] boolValue];
}

@end
