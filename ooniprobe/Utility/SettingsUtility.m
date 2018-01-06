#import "SettingsUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"automated_testing", @"sharing", @"advanced"];
}

+ (NSArray*)getSettingsForCategory:(NSString*)catName{
    if ([catName isEqualToString:@"notifications"]) {
        return @[@"run_automatic_tests"];
    }
    else if ([catName isEqualToString:@"automated_testing"]) {
        return @[@"website_categories"];
    }
    else if ([catName isEqualToString:@"sharing"]) {
        if ([self get_upload_results])
            return @[@"upload_results", @"include_ip", @"include_asn"];
        else
            return @[@"upload_results"];
    }
    else if ([catName isEqualToString:@"advanced"]) {
        return @[@"include_cc", @"send_crash"];
    }
    else
        return nil;
}

+ (NSString*)getTypeForSetting:(NSString*)setting{
    if ([setting isEqualToString:@"website_categories"])
        return @"segue";
    return @"bool";
}

+ (NSArray*)getSettingsForTest:(NSString*)testName{
    return nil;
}

+ (BOOL)get_upload_results{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
}

+ (NSArray*)getSitesCategories{
    return @[@"ALDR", @"REL", @"PORN", @"PROV", @"POLR", @"HUMR", @"ENV", @"MILX", @"HATE", @"NEWS", @"XED", @"PUBH", @"GMB", @"ANON", @"DATE", @"GRP", @"LGBT", @"FILE", @"HACK", @"COMT", @"MMED", @"HOST", @"SRCH", @"GAME", @"CULTR", @"ECON", @"GOVT", @"COMM", @"CTRL", @"IGO", @"MISC"];
}

@end
