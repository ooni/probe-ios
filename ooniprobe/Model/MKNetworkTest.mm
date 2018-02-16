#import "MKNetworkTest.h"

#import "VersionUtility.h"
#import "TestUtility.h"
#import "ReachabilityManager.h"

#include <measurement_kit/ooni.hpp>
#include <measurement_kit/nettests.hpp>
#include <measurement_kit/ndt.hpp>

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

#define VERBOSITY MK_LOG_WARNING
#define ANOMALY_GREEN 0
#define ANOMALY_ORANGE 1
#define ANOMALY_RED 2


@implementation MKNetworkTest

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self createMeasurementObject];
    return self;
}

-(void)run {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self.measurement setState:measurementActive];
    //TODO use startTime in OnEntry
    [self.measurement setStartTime:[NSDate date]];
    [self.measurement save];
}

- (void)createMeasurementObject{
    self.measurement = [Measurement new];
    [self.measurement setResult:self.result];
    self.backgroundTask = UIBackgroundTaskInvalid;
}

- (void) init_common:(mk::nettests::BaseTest&) test{
    BOOL include_ip = [SettingsUtility getSettingWithName:@"include_ip"];
    BOOL include_asn = [SettingsUtility getSettingWithName:@"include_asn"];
    BOOL include_cc = [SettingsUtility getSettingWithName:@"include_cc"];
    BOOL upload_results = [SettingsUtility getSettingWithName:@"upload_results"];
    NSString *software_version = [VersionUtility get_software_version];
    NSString *geoip_asn = [[NSBundle mainBundle] pathForResource:@"GeoIPASNum" ofType:@"dat"];
    NSString *geoip_country = [[NSBundle mainBundle] pathForResource:@"GeoIP" ofType:@"dat"];
    self.progress = 0;
    self.max_runtime_enabled = TRUE;
    [self.measurement setNetworkType:[[ReachabilityManager sharedManager] getStatus]];
    
    //Configuring common test parameters
    test.set_option("geoip_country_path", [geoip_country UTF8String]);
    test.set_option("geoip_asn_path", [geoip_asn UTF8String]);
    test.set_option("save_real_probe_ip", include_ip);
    test.set_option("save_real_probe_asn", include_asn);
    test.set_option("save_real_probe_cc", include_cc);
    test.set_option("no_collector", !upload_results);
    test.set_option("software_name", [@"ooniprobe-ios" UTF8String]);
    test.set_option("software_version", [software_version UTF8String]);
    test.set_error_filepath([[TestUtility getFileName:self.measurement.Id ext:@"log"] UTF8String]);
    test.set_output_filepath([[TestUtility getFileName:self.measurement.Id ext:@"json"] UTF8String]);
    test.set_verbosity(VERBOSITY);
    test.add_annotation("network_type", [self.measurement.networkType UTF8String]);
    test.on_log([self](uint32_t type, const char *s) {
        NSLog(@"%s", s);
    });
    test.on_begin([self]() {
        [self updateProgress:0];
    });
    test.on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    });
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.on_overall_data_usage([self](mk::DataUsage d) {
        //NSNumber* down = [NSNumber numberWithUnsignedLongLong:d.down];
        //NSNumber* up = [NSNumber numberWithUnsignedLongLong:d.up];
        [self.result setDataUsageDown:self.result.dataUsageDown+d.down];
        [self.result setDataUsageUp:self.result.dataUsageUp+d.up];
        //NSLog(@"dataUsageDown %qu", d.down);
        //NSLog(@"dataUsageUp %qu", d.up);
    });
    test.start([self]() {
        [self testEnded];
    });
}

-(void)updateProgress:(double)prog {
    self.progress = prog;
    NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%", prog * 100.0];
    NSLog(@"%@", os);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:[NSNumber numberWithInt:self.idx] forKey:@"index"];
        [noteInfo setObject:[NSNumber numberWithDouble:prog] forKey:@"prog"];
        [noteInfo setObject:self.name forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil userInfo:noteInfo];
    });
}

-(void)on_entry:(const char*)str{
    if (str != nil) {
        //TODO Lo startdate ti consiglio di prenderlo dal primo `on_entry` ?
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
            NSLog(@"Error parsing JSON: %@", error);
            blocking = ANOMALY_ORANGE;
            [self updateBlocking:blocking];
            return;
        }
        if ([json safeObjectForKey:@"probe_asn"]){
            [self.measurement setAsn:[json objectForKey:@"probe_asn"]];
            if (self.result.asn == nil){
                [self.result setAsn:[json objectForKey:@"probe_asn"]];
                [self.result save];
            }
            else {
                if (![self.result.asn isEqualToString:self.measurement.asn])
                    NSLog(@"Something's wrong");
            }
        }
        if ([json safeObjectForKey:@"probe_cc"]){
            [self.measurement setCountry:[json objectForKey:@"probe_cc"]];
            if (self.result.country == nil){
                [self.result setCountry:[json objectForKey:@"probe_cc"]];
                [self.result save];
            }
            else {
                if (![self.result.country isEqualToString:self.measurement.country])
                    NSLog(@"Something's wrong");
            }
        }
        if ([json safeObjectForKey:@"probe_ip"])
            [self.measurement setIp:[json objectForKey:@"probe_ip"]];
        if ([json safeObjectForKey:@"report_id"])
            [self.measurement setReportId:[json objectForKey:@"report_id"]];
        if ([self.name isEqualToString:@"web_connectivity"]){
            blocking = [self checkBlocking:[json objectForKey:@"test_keys"]];
        }
        else if ([self.name isEqualToString:@"http_invalid_request_line"]){
            /*
             on_entry method for http invalid request line test
             if the "tampering" key exists and is null then anomaly will be set to 1 (orange)
             otherwise "tampering" object exists and is TRUE, then anomaly will be set to 2 (red)
             */
            if ([[json objectForKey:@"test_keys"] objectForKey:@"tampering"]){
                //this case shouldn't happen
                if ([[json objectForKey:@"test_keys"] objectForKey:@"tampering"] == [NSNull null])
                    blocking = ANOMALY_ORANGE;
                else if ([[[json objectForKey:@"test_keys"] objectForKey:@"tampering"] boolValue])
                    blocking = ANOMALY_RED;
            }
        }
        else if ([self.name isEqualToString:@"http_header_field_manipulation"]){
            /*
             on_entry method for HttpHeaderFieldManipulation test
             if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
             otherwise the keys in the "tampering" object will be checked, if any of them is TRUE, then anomaly will be set to 2 (red)
             */
            if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
                blocking = ANOMALY_ORANGE;
            else {
                NSDictionary *tampering = [[json objectForKey:@"test_keys"] objectForKey:@"tampering"];
                NSArray *keys = [[NSArray alloc]initWithObjects:@"header_field_name", @"header_field_number", @"header_field_value", @"header_name_capitalization", @"request_line_capitalization", @"total", nil];
                for (NSString *key in keys) {
                    if ([tampering objectForKey:key] &&
                        [tampering objectForKey:key] != [NSNull null] &&
                        [[tampering objectForKey:key] boolValue]) {
                        blocking = ANOMALY_RED;
                    }
                }
            }
        }
        else if ([self.name isEqualToString:@"ndt"] || [self.name isEqualToString:@"dash"]){
            /*
             on_entry method for ndt and dash test
             if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
             */
            if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
                blocking = ANOMALY_ORANGE;
        }
        else if ([self.name isEqualToString:@"whatsapp"]){
            // whatsapp: red if "whatsapp_endpoints_status" or "whatsapp_web_status" or "registration_server" are "blocked"
            NSArray *keys = [[NSArray alloc] initWithObjects:@"whatsapp_endpoints_status", @"whatsapp_web_status", @"registration_server_status", nil];
            for (NSString *key in keys) {
                if ([[json objectForKey:@"test_keys"] objectForKey:key]){
                    if ([[json objectForKey:@"test_keys"] objectForKey:key] == [NSNull null]) {
                        if (blocking < ANOMALY_ORANGE)
                            blocking = ANOMALY_ORANGE;
                    }
                    else if ([[[json objectForKey:@"test_keys"] objectForKey:key] isEqualToString:@"blocked"]) {
                        blocking = ANOMALY_RED;
                    }
                }
            }
        }
        else if ([self.name isEqualToString:@"telegram"]){
            /*
             for telegram: red if either "telegram_http_blocking" or "telegram_tcp_blocking" is true, OR if ""telegram_web_status" is "blocked"
             the "*_failure" keys for telegram and whatsapp might indicate a test failure / anomaly
             */
            NSArray *keys = [[NSArray alloc] initWithObjects:@"telegram_http_blocking", @"telegram_tcp_blocking", nil];
            for (NSString *key in keys) {
                if ([[json objectForKey:@"test_keys"] objectForKey:key]){
                    if ([[json objectForKey:@"test_keys"] objectForKey:key] == [NSNull null]) {
                        if (blocking < ANOMALY_ORANGE)
                            blocking = ANOMALY_ORANGE;
                    }
                    else if ([[[json objectForKey:@"test_keys"] objectForKey:key] boolValue]) {
                        blocking = ANOMALY_RED;
                    }
                }
            }
            if ([[json objectForKey:@"test_keys"] objectForKey:@"telegram_web_status"]){
                if ([[json objectForKey:@"test_keys"] objectForKey:@"telegram_web_status"] == [NSNull null]) {
                    if (blocking < ANOMALY_ORANGE)
                        blocking = ANOMALY_ORANGE;
                }
                else if ([[[json objectForKey:@"test_keys"] objectForKey:@"telegram_web_status"] isEqualToString:@"blocked"]) {
                    blocking = ANOMALY_RED;
                }
            }
        }
        else if ([self.name isEqualToString:@"facebook_messenger"]){
            // FB: red blocking if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
            NSArray *keys = [[NSArray alloc] initWithObjects:@"facebook_tcp_blocking", @"facebook_dns_blocking", nil];
            for (NSString *key in keys) {
                if ([[json objectForKey:@"test_keys"] objectForKey:key]){
                    if ([[json objectForKey:@"test_keys"] objectForKey:key] == [NSNull null]) {
                        if (blocking < ANOMALY_ORANGE)
                            blocking = ANOMALY_ORANGE;
                    }
                    else if ([[[json objectForKey:@"test_keys"] objectForKey:key] boolValue]) {
                        blocking = ANOMALY_RED;
                    }
                }
            }
        }
        [self updateBlocking:blocking];
        [self.measurement save];
        //create new measurement entry if web_connectivity test
        if ([self.name isEqualToString:@"web_connectivity"]){
            self.entryIdx++;
            if (self.entryIdx < [self.inputs count]){
                [self createMeasurementObject];
                self.measurement.input = [self.inputs objectAtIndex:self.entryIdx];
            }
        }
    }
}

- (int)checkBlocking:(NSDictionary*)test_keys{
    /*
     null => anomaly, (orange
     false => not blocked, (green)
     string (dns, tcp-ip, http-failure, http-diff) => blocked (red)
     */
    id element = [test_keys objectForKey:@"blocking"];
    int blocking = 0;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
        blocking = 1;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        blocking = 2;
    }
    return blocking;
}


-(void)updateBlocking:(int)blocking{
    if (blocking > self.measurement.blocking){
        [self.measurement setBlocking:blocking];
    }
}

-(void)testEnded{
    NSLog(@"%@ testEnded", self.name);
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    [self.measurement setEndTime:[NSDate date]];
    [self.measurement setState:measurementDone];
    [self updateProgress:1];
    [self.measurement save];
    [self.delegate testEnded:self];
}

@end

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
        self.measurement.name = self.name;
        //TODO update db o trova un modo per farlo nella superclass
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}

-(void) run_test {
    NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    mk::nettests::WebConnectivityTest test;
    self.entryIdx = 0;
    self.measurement.input = [self.inputs objectAtIndex:self.entryIdx];
    if (self.max_runtime_enabled){
        test.set_option("max_runtime", [max_runtime doubleValue]);
    }
    if ([self.inputs count] > 0) {
        for (NSString* input in self.inputs) {
            test.add_input([input UTF8String]);
        }
    }
    [super init_common:test];
}

@end

@implementation HttpInvalidRequestLine : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_invalid_request_line";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}

-(void) run_test {
    mk::nettests::HttpInvalidRequestLineTest test;
    [super init_common:test];
}

@end

@implementation HttpHeaderFieldManipulation : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_header_field_manipulation";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}

-(void) run_test {
    mk::nettests::HttpHeaderFieldManipulationTest test;
    [super init_common:test];
}

@end

@implementation NdtTest : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"ndt";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}


-(void) run_test {
    mk::nettests::NdtTest test;
    [super init_common:test];
    //when setting server check first ndt_server_auto
}

@end

@implementation Dash : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}


-(void) run_test {
    mk::nettests::DashTest test;
    //when setting server check first ndt_server_auto
    [super init_common:test];
}

@end

@implementation Whatsapp : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"whatsapp";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}

-(void) run_test {
    mk::nettests::WhatsappTest test;
    [super init_common:test];
}

@end

@implementation Telegram : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"telegram";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}


-(void) run_test {
    mk::nettests::TelegramTest test;
    [super init_common:test];
}

@end

@implementation FacebookMessenger : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
        self.measurement.name = self.name;
    }
    return self;
}

-(void)run {
    [super run];
    [self run_test];
}

-(void) run_test {
    mk::nettests::FacebookMessengerTest test;
    [super init_common:test];
}

@end
