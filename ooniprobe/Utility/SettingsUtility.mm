#import "SettingsUtility.h"
#import "TestUtility.h"
#import <measurement_kit/common.hpp>

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    //TODO-2.1 reenable "automated_testing"
    return @[@"notifications", @"sharing", @"advanced", @"about_ooni"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)categoryName{
    if ([categoryName isEqualToString:@"notifications"]) {
        if ([self getSettingWithName:@"notifications_enabled"])
            return @[@"notifications_enabled", @"notifications_completion", @"notifications_news"];
        else
            return @[@"notifications_enabled"];
    }
    else if ([categoryName isEqualToString:@"automated_testing"]) {
        if ([self getSettingWithName:@"automated_testing_enabled"])
            return @[@"automated_testing_enabled", @"enabled_tests", @"website_categories", @"monthly_mobile_allowance", @"monthly_wifi_allowance"];
        else
            return @[@"automated_testing_enabled"];
    }
    else if ([categoryName isEqualToString:@"sharing"]) {
        //TODO-2.1 @"include_gps"
        return @[@"upload_results", @"include_asn", @"include_cc", @"include_ip"];
    }
    else if ([categoryName isEqualToString:@"advanced"]) {
        //TODO-2.1 @"use_domain_fronting"
        return @[@"keep_screen_on", @"send_crash", @"debug_logs"];
    }
    else
        return nil;
}

+ (NSString*)getTypeForSetting:(NSString*)setting{
    if ([setting isEqualToString:@"website_categories"] || [setting isEqualToString:@"enabled_tests"])
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
        return @"DEBUG";
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

+ (void)addRemoveSitesCategory:(NSString*)categoryName {
    NSMutableArray *categories_disabled = [[self getSitesCategoriesDisabled] mutableCopy];
    if ([categories_disabled containsObject:categoryName])
        [categories_disabled removeObject:categoryName];
    else
        [categories_disabled addObject:categoryName];
    [[NSUserDefaults standardUserDefaults] setObject:categories_disabled forKey:@"categories_disabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)getSettingsForTest:(NSString*)testName :(BOOL)includeAll{
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    if ([testName isEqualToString:@"websites"]) {
        if (includeAll) [settings addObject:@"website_categories"];
        if (includeAll) [settings addObject:@"max_runtime"];
    }
    else if ([testName isEqualToString:@"instant_messaging"]) {
        [settings addObject:@"test_whatsapp"];
        if (includeAll && [self getSettingWithName:@"test_whatsapp"])
            [settings addObject:@"test_whatsapp_extensive"];
        [settings addObject:@"test_telegram"];
        [settings addObject:@"test_facebook_messenger"];
    }
    else if ([testName isEqualToString:@"middle_boxes"]) {
        [settings addObject:@"run_http_invalid_request_line"];
        [settings addObject:@"run_http_header_field_manipulation"];
    }
    else if ([testName isEqualToString:@"performance"]) {
        [settings addObject:@"run_ndt"];
        [settings addObject:@"run_dash"];
    }
    return settings;
}

+ (BOOL)getSettingWithName:(NSString*)settingName{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:settingName] boolValue];
}
@end
