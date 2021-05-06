#import "SettingsUtility.h"
#import "TestUtility.h"
#import "Engine.h"
#import "ThirdPartyServices.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"test_options", @"privacy", @"advanced", @"ooni_backend_proxy", @"send_email", @"about_ooni"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)categoryName{
    //TODO NEWS reenable @"notifications_news"
    if ([categoryName isEqualToString:@"notifications"]) {
        return @[@[@"notifications_enabled"]];
    }
    else if ([categoryName isEqualToString:@"privacy"]) {
        return @[@[@"upload_results", @"send_crash"]];
    }
    else if ([categoryName isEqualToString:@"advanced"]) {
        //TODO DOMAIN FRONTING @"use_domain_fronting"
        return @[@[@"debug_logs", @"storage_usage"]];
    }
    else if ([categoryName isEqualToString:@"ooni_backend_proxy"]) {
        NSString *proxy_value = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_enabled"];
        //TODO make functions
        if ([proxy_value isEqualToString:@"proxy_custom"])
            return @[@[@"proxy_none", @"proxy_psiphon", @"proxy_custom"], @[@"HTTP", @"SOCKS5"], @[@"proxy_custom_hostname", @"proxy_custom_value", @"proxy_custom_port", @"proxy_custom_password"], @[@"proxy_psiphon_over_custom"]];
        else
            return @[@[@"proxy_none", @"proxy_psiphon", @"proxy_custom"]];

    }
    else if ([categoryName isEqualToString:@"test_options"]) {
        return @[[TestUtility getTestTypes]];
    }
    else if ([[TestUtility getTestTypes] containsObject:categoryName])
        return @[[SettingsUtility getSettingsForTest:categoryName :YES]];
    else
        return nil;
}

+ (NSString*)getTypeForSetting:(NSString*)setting{
    if ([setting isEqualToString:@"website_categories"] || [[TestUtility getTestTypes] containsObject:setting])
        return @"segue";
    else if ([setting isEqualToString:@"monthly_mobile_allowance"] ||
             [setting isEqualToString:@"monthly_wifi_allowance"] ||
             [setting isEqualToString:@"max_runtime"] ||
             [setting isEqualToString:@"proxy_custom_port"])
        return @"int";
    if ([setting isEqualToString:@"storage_usage"])
        return @"button";
    else if ([setting isEqualToString:@"proxy_none"] ||
             [setting isEqualToString:@"proxy_psiphon"] ||
             [setting isEqualToString:@"proxy_custom"] ||
             [setting isEqualToString:@"HTTP"] ||
             [setting isEqualToString:@"SOCKS5"] ||
             [setting isEqualToString:@"proxy_psiphon_over_custom"])
        return @"checkmark";
    else if ([setting isEqualToString:@"proxy_custom_hostname"] ||
             [setting isEqualToString:@"proxy_custom_value"] ||
             [setting isEqualToString:@"proxy_custom_protocol"] ||
             [setting isEqualToString:@"proxy_custom_password"])
        return @"string";
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

+ (NSArray*)getSitesCategoriesEnabled {
    NSMutableArray *categories = [[self getSitesCategories] mutableCopy];
    [categories removeObjectsInArray:[self getSitesCategoriesDisabled]];
    return categories;
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
        [settings addObject:@"test_telegram"];
        [settings addObject:@"test_facebook_messenger"];
        [settings addObject:@"test_signal"];
    }
    else if ([testName isEqualToString:@"circumvention"]) {
        [settings addObject:@"test_psiphon"];
        [settings addObject:@"test_tor"];
        [settings addObject:@"test_riseupvpn"];
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

+ (BOOL)isSendCrashEnabled {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"send_crash"] boolValue];
}

+ (BOOL)isNotificationEnabled {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications_enabled"] boolValue];
}

+ (NSString*)getOrGenerateUUID4{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uuid4"] ||
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid4"] isKindOfClass:[NSString class]]){
        NSString *uuid = [Engine newUUID4];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid4"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return uuid;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid4"];
}

+ (void)incrementAppOpenCount{
    [[NSUserDefaults standardUserDefaults] setInteger:[self getAppOpenCount]+1 forKey:NOTIFICATION_POPUP];
}

+ (NSInteger)getAppOpenCount{
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:NOTIFICATION_POPUP];
    if(count < 0) count = 0;
    return count;
}

+ (void)registeredForNotifications {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notifications_enabled"];
    [ThirdPartyServices reloadConsents];
}

@end
