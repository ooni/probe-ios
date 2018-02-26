#import "SettingsUtility.h"

@implementation SettingsUtility

+ (NSArray*)getSettingsCategories{
    return @[@"notifications", @"automated_testing", @"sharing", @"advanced", @"about_ooni"];
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
        return @[@"upload_results", @"include_ip", @"include_asn", @"include_gps"];
    }
    else if ([categoryName isEqualToString:@"advanced"]) {
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
    return @[@"ALDR", @"REL", @"PORN", @"PROV", @"POLR", @"HUMR", @"ENV", @"MILX", @"HATE", @"NEWS", @"XED", @"PUBH", @"GMB", @"ANON", @"DATE", @"GRP", @"LGBT", @"FILE", @"HACK", @"COMT", @"MMED", @"HOST", @"SRCH", @"GAME", @"CULTR", @"ECON", @"GOVT", @"COMM", @"CTRL", @"IGO", @"MISC"];
}
+ (NSArray*)getSitesCategoriesEnabled {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"sites_categories"];
}

+ (void)addRemoveSitesCategory:(NSString*)categoryName {
    NSMutableArray *sites_categories = [[self getSitesCategories] mutableCopy];
    if ([sites_categories containsObject:categoryName])
        [sites_categories removeObject:categoryName];
    else
        [sites_categories addObject:categoryName];
    [[NSUserDefaults standardUserDefaults] setObject:sites_categories forKey:@"sites_categories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)getSettingsForTest:(NSString*)testName :(BOOL)includeAll{
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    if ([testName isEqualToString:@"websites"]) {
        if (includeAll) [settings addObject:@"website_categories"];
        if (includeAll) [settings addObject:@"max_runtime"];
        if (includeAll) [settings addObject:@"custom_url"];
    }
    else if ([testName isEqualToString:@"instant_messaging"]) {
        [settings addObject:@"test_whatsapp"];
        if (includeAll && [self getSettingWithName:@"test_whatsapp"])
            [settings addObject:@"test_whatsapp_extensive"];
        [settings addObject:@"test_telegram"];
        [settings addObject:@"test_facebook"];
    }
    else if ([testName isEqualToString:@"middle_boxes"]) {
        [settings addObject:@"run_http_invalid_request_line"];
        [settings addObject:@"run_http_header_field_manipulation"];
    }
    else if ([testName isEqualToString:@"performance"]) {
        NSMutableArray *settings = [[NSMutableArray alloc] init];
        [settings addObject:@"run_ndt"];
        if (includeAll && [self getSettingWithName:@"run_ndt"]){
            [settings addObject:@"ndt_server_auto"];
            if (![self getSettingWithName:@"ndt_server_auto"]){
                [settings addObject:@"ndt_server"];
                [settings addObject:@"ndt_server_port"];
            }
        }
        [settings addObject:@"run_dash"];
        if (includeAll && [self getSettingWithName:@"run_dash"]){
            [settings addObject:@"dash_server_auto"];
            if (![self getSettingWithName:@"dash_server_auto"]){
                [settings addObject:@"dash_server"];
                [settings addObject:@"dash_server_port"];
            }
        }
    }
    return settings;
}

+ (BOOL)getSettingWithName:(NSString*)settingName{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:settingName] boolValue];
}

+ (UIColor*)getColorForTest:(NSString*)testName{
    if ([testName isEqualToString:@"websites"]){
        return [UIColor colorWithRGBHexString:color_indigo6 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"performance"]){
        return [UIColor colorWithRGBHexString:color_fuchsia6 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        return [UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        return [UIColor colorWithRGBHexString:color_cyan6 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_blue5 alpha:1.0f];
}

+ (NSArray*)getUrlsTest{
    return @[@{@"category_code":@"NEWS",@"url":@"http://www.foxnews.com",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"https://www.1and1.com/",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://www.anonymsurfen.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.bearshare.com",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.themwl.org",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.muhammadanism.com",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://www.counter-strike.net",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://craigslist.org",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://www.4chan.org",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"http://www.mywebcalls.com",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.upci.org",@"country_code":@"XX"},@{@"category_code":@"HATE",@"url":@"http://godhatesfags.com",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"https://www.torproject.org",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.kcna.kp",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"http://www.livejournal.com",@"country_code":@"XX"},@{@"category_code":@"XED",@"url":@"https://www.plannedparenthood.org/",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://marijuana.nl",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.download.com",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"https://mixi.jp/",@"country_code":@"XX"},@{@"category_code":@"PUBH",@"url":@"http://www.circumcision.org",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"https://cyber.harvard.edu/",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.irna.ir",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.csmonitor.com",@"country_code":@"XX"},@{@"category_code":@"PORN",@"url":@"http://beeg.com",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"https://outlook.live.com/",@"country_code":@"XX"},@{@"category_code":@"HACK",@"url":@"http://www.securitytracker.com",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"http://voice.yahoo.jajah.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.utorrent.com",@"country_code":@"XX"},@{@"category_code":@"ECON",@"url":@"http://wkkf.org/",@"country_code":@"XX"},@{@"category_code":@"ECON",@"url":@"http://www.imf.org",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.isiswomen.org",@"country_code":@"XX"},@{@"category_code":@"GOVT",@"url":@"http://www.opec.org",@"country_code":@"XX"},@{@"category_code":@"XED",@"url":@"http://sfsi.org/",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"https://psiphon.ca/",@"country_code":@"XX"},@{@"category_code":@"PORN",@"url":@"http://www.playboy.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.kazaa.com",@"country_code":@"XX"},@{@"category_code":@"LGBT",@"url":@"http://www.gayegypt.com",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://www.linkedin.com/",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"https://ipi.media/",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://www.netflix.com/",@"country_code":@"XX"},@{@"category_code":@"LGBT",@"url":@"http://transsexual.org",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://anonym.to",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"https://www.blogger.com/",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.khrp.org",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"https://www.om.org/",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://twitter.com/anonops",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.ifj.org",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.ucc.org",@"country_code":@"XX"},@{@"category_code":@"PUBH",@"url":@"http://www.implantinfo.com",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.thegooddrugsguide.com",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.pravda.ru",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"https://www.csidonline.org/",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://ddo.com/",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.rxmarijuana.com",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://peacefire.org/",@"country_code":@"XX"},@{@"category_code":@"GOVT",@"url":@"http://www.dia.mil",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://company.wizards.com/",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://www.jmarshall.com/tools/cgiproxy/",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.dailymotion.com",@"country_code":@"XX"},@{@"category_code":@"GMB",@"url":@"http://www.spinpalace.com",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://twitpic.com/",@"country_code":@"XX"},@{@"category_code":@"SRCH",@"url":@"https://kids.yahoo.com",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.theepochtimes.com",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.oneworld.net",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.scientology.org",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://video.google.com",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://mp3.com/",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"http://www.foreignword.com",@"country_code":@"XX"},@{@"category_code":@"SRCH",@"url":@"http://www.google.com/search?q=lesbian",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.marijuana.com",@"country_code":@"XX"},@{@"category_code":@"MILX",@"url":@"http://www.aleph.to",@"country_code":@"XX"},@{@"category_code":@"PROV",@"url":@"https://trashy.com/",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://www.fring.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://imesh.com/",@"country_code":@"XX"},@{@"category_code":@"ECON",@"url":@"http://care.org",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://www.ghostrecon.com",@"country_code":@"XX"},@{@"category_code":@"XED",@"url":@"http://www.sexandu.ca/",@"country_code":@"XX"},@{@"category_code":@"LGBT",@"url":@"http://www.grindr.com/",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"https://extratorrent.cc",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"http://www.webspawner.com",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"https://noblogs.org",@"country_code":@"XX"},@{@"category_code":@"PUBH",@"url":@"http://www.hivandhepatitis.com",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"https://www.buydutchseeds.com/",@"country_code":@"XX"},@{@"category_code":@"MILX",@"url":@"http://www.arabrenewal.com",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://www.pandora.com",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.arabtimes.com",@"country_code":@"XX"},@{@"category_code":@"SRCH",@"url":@"http://www.maven.co.il",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.cannabis.info",@"country_code":@"XX"},@{@"category_code":@"PROV",@"url":@"http://blueskyswimwear.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"https://thepiratebay.se",@"country_code":@"XX"},@{@"category_code":@"POLR",@"url":@"http://www.piratpartiet.se",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://www.liveleak.com/",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.actionaid.org",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"https://login.live.com/",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://delicious.com",@"country_code":@"XX"},@{@"category_code":@"PROV",@"url":@"https://www.3wishes.com/",@"country_code":@"XX"},@{@"category_code":@"ENV",@"url":@"https://www.epa.gov/",@"country_code":@"XX"},@{@"category_code":@"POLR",@"url":@"http://www.fondationdefrance.org/",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.wiesenthal.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"https://addons.mozilla.org",@"country_code":@"XX"}];
}
@end
