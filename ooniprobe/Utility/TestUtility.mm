#import "TestUtility.h"
#import "Url.h"
#define ANOMALY_GREEN 0
#define ANOMALY_ORANGE 1
#define ANOMALY_RED 2

@implementation TestUtility


+ (void)showNotification:(NSString*)name {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"finished_running", nil), NSLocalizedString(name, nil)];
        [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    });
}

-(NSString*) getDate {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    return [dateformatter stringFromDate:[NSDate date]];
}

+ (NSString*) getFileName:(NSNumber*)uniqueId ext:(NSString*)ext {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/test-%@.%@", documentsDirectory, uniqueId, ext];
    return fileName;
}


-(int)checkAnomaly:(NSDictionary*)test_keys{
    /*
     null => anomal = 1,
     false => anomaly = 0,
     stringa (dns, tcp-ip, http-failure, http-diff) => anomaly = 2
     
     Return values:
     0 == OK,
     1 == orange,
     2 == red
     */
    id element = [test_keys objectForKey:@"blocking"];
    int anomaly = ANOMALY_GREEN;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
        anomaly = ANOMALY_ORANGE;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        anomaly = ANOMALY_RED;
    }
    return anomaly;
}

+ (NSDictionary*)getTests{
    return @{@"websites": @[@"web_connectivity"], @"instant_messaging": @[@"whatsapp", @"telegram", @"facebook_messenger"], @"middle_boxes": @[@"http_invalid_request_line", @"http_header_field_manipulation"], @"performance": @[@"ndt", @"dash"]};
}

+ (NSArray*)getTestTypes{
    return @[@"websites", @"instant_messaging", @"middle_boxes", @"performance"];
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
    NSArray *urlsArray =  @[@{@"category_code":@"NEWS",@"url":@"http://www.foxnews.com",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"https://www.1and1.com/",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://www.anonymsurfen.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.bearshare.com",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.themwl.org",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.muhammadanism.com",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://www.counter-strike.net",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://craigslist.org",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://www.4chan.org",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"http://www.mywebcalls.com",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.upci.org",@"country_code":@"XX"},@{@"category_code":@"HATE",@"url":@"http://godhatesfags.com",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"https://www.torproject.org",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.kcna.kp",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"http://www.livejournal.com",@"country_code":@"XX"},@{@"category_code":@"XED",@"url":@"https://www.plannedparenthood.org/",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://marijuana.nl",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.download.com",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"https://mixi.jp/",@"country_code":@"XX"},@{@"category_code":@"PUBH",@"url":@"http://www.circumcision.org",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"https://cyber.harvard.edu/",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.irna.ir",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.csmonitor.com",@"country_code":@"XX"},@{@"category_code":@"PORN",@"url":@"http://beeg.com",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"https://outlook.live.com/",@"country_code":@"XX"},@{@"category_code":@"HACK",@"url":@"http://www.securitytracker.com",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"http://voice.yahoo.jajah.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.utorrent.com",@"country_code":@"XX"},@{@"category_code":@"ECON",@"url":@"http://wkkf.org/",@"country_code":@"XX"},@{@"category_code":@"ECON",@"url":@"http://www.imf.org",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.isiswomen.org",@"country_code":@"XX"},@{@"category_code":@"GOVT",@"url":@"http://www.opec.org",@"country_code":@"XX"},@{@"category_code":@"XED",@"url":@"http://sfsi.org/",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"https://psiphon.ca/",@"country_code":@"XX"},@{@"category_code":@"PORN",@"url":@"http://www.playboy.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://www.kazaa.com",@"country_code":@"XX"},@{@"category_code":@"LGBT",@"url":@"http://www.gayegypt.com",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://www.linkedin.com/",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"https://ipi.media/",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://www.netflix.com/",@"country_code":@"XX"},@{@"category_code":@"LGBT",@"url":@"http://transsexual.org",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://anonym.to",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"https://www.blogger.com/",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.khrp.org",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"https://www.om.org/",@"country_code":@"XX"},@{@"category_code":@"GRP",@"url":@"http://twitter.com/anonops",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.ifj.org",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.ucc.org",@"country_code":@"XX"},@{@"category_code":@"PUBH",@"url":@"http://www.implantinfo.com",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.thegooddrugsguide.com",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.pravda.ru",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"https://www.csidonline.org/",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://ddo.com/",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.rxmarijuana.com",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://peacefire.org/",@"country_code":@"XX"},@{@"category_code":@"GOVT",@"url":@"http://www.dia.mil",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://company.wizards.com/",@"country_code":@"XX"},@{@"category_code":@"ANON",@"url":@"http://www.jmarshall.com/tools/cgiproxy/",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.dailymotion.com",@"country_code":@"XX"},@{@"category_code":@"GMB",@"url":@"http://www.spinpalace.com",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://twitpic.com/",@"country_code":@"XX"},@{@"category_code":@"SRCH",@"url":@"https://kids.yahoo.com",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.theepochtimes.com",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.oneworld.net",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.scientology.org",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://video.google.com",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://mp3.com/",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"http://www.foreignword.com",@"country_code":@"XX"},@{@"category_code":@"SRCH",@"url":@"http://www.google.com/search?q=lesbian",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.marijuana.com",@"country_code":@"XX"},@{@"category_code":@"MILX",@"url":@"http://www.aleph.to",@"country_code":@"XX"},@{@"category_code":@"PROV",@"url":@"https://trashy.com/",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://www.fring.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"http://imesh.com/",@"country_code":@"XX"},@{@"category_code":@"ECON",@"url":@"http://care.org",@"country_code":@"XX"},@{@"category_code":@"GAME",@"url":@"http://www.ghostrecon.com",@"country_code":@"XX"},@{@"category_code":@"XED",@"url":@"http://www.sexandu.ca/",@"country_code":@"XX"},@{@"category_code":@"LGBT",@"url":@"http://www.grindr.com/",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"https://extratorrent.cc",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"http://www.webspawner.com",@"country_code":@"XX"},@{@"category_code":@"HOST",@"url":@"https://noblogs.org",@"country_code":@"XX"},@{@"category_code":@"PUBH",@"url":@"http://www.hivandhepatitis.com",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"https://www.buydutchseeds.com/",@"country_code":@"XX"},@{@"category_code":@"MILX",@"url":@"http://www.arabrenewal.com",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://www.pandora.com",@"country_code":@"XX"},@{@"category_code":@"NEWS",@"url":@"http://www.arabtimes.com",@"country_code":@"XX"},@{@"category_code":@"SRCH",@"url":@"http://www.maven.co.il",@"country_code":@"XX"},@{@"category_code":@"ALDR",@"url":@"http://www.cannabis.info",@"country_code":@"XX"},@{@"category_code":@"PROV",@"url":@"http://blueskyswimwear.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"https://thepiratebay.se",@"country_code":@"XX"},@{@"category_code":@"POLR",@"url":@"http://www.piratpartiet.se",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"https://www.liveleak.com/",@"country_code":@"XX"},@{@"category_code":@"HUMR",@"url":@"http://www.actionaid.org",@"country_code":@"XX"},@{@"category_code":@"COMT",@"url":@"https://login.live.com/",@"country_code":@"XX"},@{@"category_code":@"MMED",@"url":@"http://delicious.com",@"country_code":@"XX"},@{@"category_code":@"PROV",@"url":@"https://www.3wishes.com/",@"country_code":@"XX"},@{@"category_code":@"ENV",@"url":@"https://www.epa.gov/",@"country_code":@"XX"},@{@"category_code":@"POLR",@"url":@"http://www.fondationdefrance.org/",@"country_code":@"XX"},@{@"category_code":@"REL",@"url":@"http://www.wiesenthal.com",@"country_code":@"XX"},@{@"category_code":@"FILE",@"url":@"https://addons.mozilla.org",@"country_code":@"XX"}];
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (NSDictionary* current in urlsArray){
        Url *currentUrl = [[Url alloc] initWithUrl:[current objectForKey:@"url"] category:[current objectForKey:@"category_code"]];
        [urls addObject:currentUrl];
    }
    return urls;
}

@end
