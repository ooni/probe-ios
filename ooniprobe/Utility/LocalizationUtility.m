#import "LocalizationUtility.h"

@implementation LocalizationUtility

+ (NSString*)getNameForTest:(NSString*)testName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *stringDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if ([stringDict objectForKey:testName])
        return NSLocalizedString([stringDict objectForKey:testName], nil);
    return testName;
}

+ (NSString*)getMKNameForTest:(NSString*)testName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Tests" ofType:@"plist"];
    NSDictionary *stringDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if ([stringDict objectForKey:testName])
        return NSLocalizedString([stringDict objectForKey:testName], nil);
    return testName;
}

+ (NSString*)getFilterNameForTest:(NSString*)testName {
    if ([testName isEqualToString:@"websites"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.Websites", nil);
    else if ([testName isEqualToString:@"performance"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.MiddleBoxes", nil);
    else if ([testName isEqualToString:@"middle_boxes"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.InstantMessaging", nil);
    else if ([testName isEqualToString:@"instant_messaging"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.Performance", nil);
    return @"";
}

+ (NSString*)getDescriptionForTest:(NSString*)testName {
    if ([testName isEqualToString:@"websites"])
        return NSLocalizedString(@"Dashboard.Websites.Card.Description", nil);
    else if ([testName isEqualToString:@"performance"])
        return NSLocalizedString(@"Dashboard.Performance.Card.Description", nil);
    else if ([testName isEqualToString:@"middle_boxes"])
        return NSLocalizedString(@"Dashboard.Middleboxes.Card.Description", nil);
    else if ([testName isEqualToString:@"instant_messaging"])
        return NSLocalizedString(@"Dashboard.InstantMessaging.Card.Description", nil);
    return @"";
}

+ (NSString*)getLongDescriptionForTest:(NSString*)testName{
    if ([testName isEqualToString:@"websites"])
        return NSLocalizedString(@"Dashboard.Websites.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"performance"])
        return NSLocalizedString(@"Dashboard.Performance.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"middle_boxes"])
        return NSLocalizedString(@"Dashboard.Middleboxes.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"instant_messaging"])
        return NSLocalizedString(@"Dashboard.InstantMessaging.Overview.Paragraph", nil);
    return @"";
}

+ (NSString*)getNameForSetting:(NSString*)settingName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *stringDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if ([stringDict objectForKey:settingName])
        return NSLocalizedString([stringDict objectForKey:settingName], nil);
    return settingName;
}

+(NSString*)getSingularPluralTemplate:(long)value :(NSString*)locString{
    NSString *string;
    if (value == 1){
        string = [NSString stringWithFormat:@"%@.Singular", locString];
    }
    else {
        string = [NSString stringWithFormat:@"%@.Plural", locString];
    }
    return NSLocalizedFormatString(string, [NSString stringWithFormat:@"%ld", value]);
}

+(NSString*)getSingularPlural:(long)value :(NSString*)locString{
    NSString *string;
    if (value == 1){
        string = [NSString stringWithFormat:@"%@.Singular", locString];
    }
    else {
        string = [NSString stringWithFormat:@"%@.Plural", locString];
    }
    return NSLocalizedString(string, nil);
}

@end
