#import "LocalizationUtility.h"

@implementation LocalizationUtility

+ (NSString*)getNameForTest:(NSString*)testName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *stringDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if ([stringDict objectForKey:testName])
        return NSLocalizedString([stringDict objectForKey:testName], nil);
    else if (testName == nil)
        return NSLocalizedString(@"TestResults.Overview.Hero.Tests", nil);
    else
        return testName;
}

+ (NSString*)getFilterNameForTest:(NSString*)testName {
    if ([testName isEqualToString:@"websites"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.Websites", nil);
    else if ([testName isEqualToString:@"performance"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.Performance", nil);
    //__deprecated
    else if ([testName isEqualToString:@"middle_boxes"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.MiddleBoxes", nil);
    else if ([testName isEqualToString:@"instant_messaging"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.InstantMessaging", nil);
    else if ([testName isEqualToString:@"circumvention"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.Circumvention", nil);
    else if ([testName isEqualToString:@"experimental"])
        return NSLocalizedString(@"TestResults.Overview.FilterTests.Experimental", nil);
    return @"";
}

+ (NSString*)getDescriptionForTest:(NSString*)testName {
    if ([testName isEqualToString:@"websites"])
        return NSLocalizedString(@"Dashboard.Websites.Card.Description", nil);
    else if ([testName isEqualToString:@"performance"])
        return NSLocalizedString(@"Dashboard.Performance.Card.Description", nil);
    //__deprecated
    else if ([testName isEqualToString:@"middle_boxes"])
        return NSLocalizedString(@"Dashboard.Middleboxes.Card.Description", nil);
    else if ([testName isEqualToString:@"instant_messaging"])
        return NSLocalizedString(@"Dashboard.InstantMessaging.Card.Description", nil);
    else if ([testName isEqualToString:@"circumvention"])
        return NSLocalizedString(@"Dashboard.Circumvention.Card.Description", nil);
    else if ([testName isEqualToString:@"experimental"])
        return NSLocalizedString(@"Dashboard.Experimental.Card.Description", nil);
    return @"";
}

+ (NSString*)getLongDescriptionForTest:(NSString*)testName{
    if ([testName isEqualToString:@"websites"])
        return NSLocalizedString(@"Dashboard.Websites.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"performance"])
        return NSLocalizedString(@"Dashboard.Performance.Overview.Paragraph.Updated", nil);
    //__deprecated
    else if ([testName isEqualToString:@"middle_boxes"])
        return NSLocalizedString(@"Dashboard.Middleboxes.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"instant_messaging"])
        return NSLocalizedString(@"Dashboard.InstantMessaging.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"circumvention"])
        return NSLocalizedString(@"Dashboard.Circumvention.Overview.Paragraph", nil);
    else if ([testName isEqualToString:@"experimental"])
        return NSLocalizedFormatString(@"Dashboard.Experimental.Overview.Paragraph",
                [NSString stringWithFormat:@"%@ %@ %@",
                        @"\n\n- [STUN Reachability](https://github.com/ooni/spec/blob/master/nettests/ts-025-stun-reachability.md) "
                        "\n\n- [DNS Check](https://github.com/ooni/spec/blob/master/nettests/ts-028-dnscheck.md) "
                        "\n\n- [ECH Check](https://github.com/ooni/spec/blob/master/nettests/ts-039-echcheck.md)",
                        [NSString stringWithFormat:@"%@ ( %@ )", @"\n\n- [Tor Snowflake](https://ooni.org/nettest/tor-snowflake/) ",NSLocalizedFormatString(@"Settings.TestOptions.LongRunningTest",nil)],
                        [NSString stringWithFormat:@"%@ ( %@ )",  @"\n\n- [Vanilla Tor](https://github.com/ooni/spec/blob/master/nettests/ts-016-vanilla-tor.md) ",NSLocalizedFormatString(@"Settings.TestOptions.LongRunningTest",nil)]
                ]);
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

+ (NSString*)getUrlForTest:(NSString*)testName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TestUrls" ofType:@"plist"];
    NSDictionary *stringDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if ([stringDict objectForKey:testName])
        return [stringDict objectForKey:testName];
    return nil;
}

+ (NSString*)getReadableRuntime:(int)runTime{
    //TODO convert seconds to minutes and hours when needed
    //if getRuntime is MAX_RUNTIME_DISABLED show one hour
    if (runTime <= [MAX_RUNTIME_DISABLED intValue])
        runTime = (int)SECONDS_IN_HOUR;
    NSString *time = NSLocalizedFormatString(@"Dashboard.Card.Seconds", [NSString stringWithFormat:@"%d", runTime]);
    return time;
}

@end
