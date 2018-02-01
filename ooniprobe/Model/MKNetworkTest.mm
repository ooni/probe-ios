#import "MKNetworkTest.h"

#import "VersionUtility.h"
#import "TestUtility.h"

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
    self.measurement = [[Measurement alloc] init];
    self.measurement.resultId = self.resultId;
    self.backgroundTask = UIBackgroundTaskInvalid;
    return self;
}

-(void)run {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    //TODO save/update measurement object
    [self.measurement setStartTime:[NSDate date]];
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

    self.measurement.reportFile = [NSString stringWithFormat:@"test-%ld.json", self.measurement.uniqueId];
    self.measurement.logFile = [NSString stringWithFormat:@"test-%ld.log", self.measurement.uniqueId];
    [self.measurement save];
    
    //Configuring common test parameters
    test.set_option("geoip_country_path", [geoip_country UTF8String]);
    test.set_option("geoip_asn_path", [geoip_asn UTF8String]);
    test.set_option("save_real_probe_ip", include_ip);
    test.set_option("save_real_probe_asn", include_asn);
    test.set_option("save_real_probe_cc", include_cc);
    test.set_option("no_collector", !upload_results);
    test.set_option("software_name", [@"ooniprobe-ios" UTF8String]);
    test.set_option("software_version", [software_version UTF8String]);
    test.set_error_filepath([[TestUtility getFileName:self.measurement.uniqueId ext:@"log"] UTF8String]);
    test.set_output_filepath([[TestUtility getFileName:self.measurement.uniqueId ext:@"json"] UTF8String]);
    test.set_verbosity(VERBOSITY);
    test.on_log([self](uint32_t type, const char *s) {
#ifdef DEBUG
        NSLog(@"%s", s);
#endif
    });
    test.on_begin([self]() {
        //TODO Create measurement object and set input
        [self updateProgress:0];
    });
    test.on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    });
}

-(void)updateProgress:(double)prog {
    self.progress = prog;
#ifdef DEBUG
    NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%", prog * 100.0];
    NSLog(@"%@", os);
#endif
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
        [noteInfo setObject:[NSNumber numberWithInt:self.idx] forKey:@"index"];
        [noteInfo setObject:[NSNumber numberWithDouble:prog] forKey:@"prog"];
        [noteInfo setObject:self.name forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil userInfo:noteInfo];
    });
}

-(void)on_entry:(NSDictionary*)json{
    //NSLog(@"on_entry %@", json);
    if ([json safeObjectForKey:@"probe_asn"])
        [self.measurement setAsn:[json objectForKey:@"probe_asn"]];
    if ([json safeObjectForKey:@"probe_cc"])
        [self.measurement setCountry:[json objectForKey:@"probe_cc"]];
    if ([json safeObjectForKey:@"probe_ip"])
        [self.measurement setIp:[json objectForKey:@"probe_ip"]];
    
    [self.measurement setState:@"done"];

    /*
     TODO set
     dataUsage, state, failure, reportId, measurementId, resultId
     networkName
     */
}

-(void)updateAnomaly:(int)blocking{
    /*if (blocking > self.anomaly){
        self.anomaly = blocking;
        [TestStorage set_anomaly:self.test_id :blocking];
    }*/
}

-(void)testEnded:(MKNetworkTest*)test{
#ifdef DEBUG
    NSLog(@"%@ testEnded", self.name);
#endif
    //self.running = FALSE;
    //[TestStorage set_completed:self.measurement.uniqueId];
    //[TestUtility showNotification:self.name];
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    [self.measurement setEndTime:[NSDate date]];
    
    //TODO
    [self.delegate testEnded:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //TODO
        //NSDictionary *noteInfo = [NSDictionary dictionaryWithObject:self.name forKey:@"test_name"];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"showToastTestFinished" object:nil userInfo:noteInfo];
    });
}

//TODO onTestEnded delegate callback
-(void)testEnded{
    [self testEnded:self];
}

@end

@implementation WebConnectivity : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
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
    [super init_common:test];
    if (self.max_runtime_enabled){
        test.set_option("max_runtime", [max_runtime doubleValue]);
    }
    if ([self.inputs count] > 0) {
        for (NSString* input in self.inputs) {
            test.add_input([input UTF8String]);
        }
    }
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

-(void)on_entry:(const char*)str{
    if (str != nil) {
        /*
         salva measurement, rialloca measurement.
         sempre creare un measurement on_start e set input
         `on_entry(datum)` you will:
         - If it's the first entry, `UPDATE` it with the content of `datum`
         - If it's not the first entry, `INSERT` a new row with the content of `datum`
         */
        //TODO Create/Update measurement object
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [super on_entry:json];
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        blocking = [self checkAnomaly:[json objectForKey:@"test_keys"]];
        [self updateAnomaly:blocking];
    }
}

- (int)checkAnomaly:(NSDictionary*)test_keys{
    /*null => anomal = 1,
     false => anomaly = 0,
     stringa (dns, tcp-ip, http-failure, http-diff) => anomaly = 2
     
     Return values:
     0 == OK,
     1 == orange,
     2 == red
     */
    id element = [test_keys objectForKey:@"blocking"];
    int anomaly = 0;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
        anomaly = 1;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        anomaly = 2;
    }
    return anomaly;
}

@end

@implementation HttpInvalidRequestLine : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_invalid_request_line";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

/*
 on_entry method for http invalid request line test
 if the "tampering" key exists and is null then anomaly will be set to 1 (orange)
 otherwise "tampering" object exists and is TRUE, then anomaly will be set to 2 (red)
 */
-(void)on_entry:(const char*)str{
    if (str != nil) {
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [super on_entry:json];
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        if ([[json objectForKey:@"test_keys"] objectForKey:@"tampering"]){
            //this case shouldn't happen
            if ([[json objectForKey:@"test_keys"] objectForKey:@"tampering"] == [NSNull null])
                blocking = ANOMALY_ORANGE;
            else if ([[[json objectForKey:@"test_keys"] objectForKey:@"tampering"] boolValue])
                blocking = ANOMALY_RED;
        }
        [self updateAnomaly:blocking];
    }
}

@end

@implementation HttpHeaderFieldManipulation : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"http_header_field_manipulation";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

/*
 on_entry method for HttpHeaderFieldManipulation test
 if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
 otherwise the keys in the "tampering" object will be checked, if any of them is TRUE, then anomaly will be set to 2 (red)
 */
-(void)on_entry:(const char*)str{
    if (str != nil) {
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [super on_entry:json];
        
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }

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
        [self updateAnomaly:blocking];
    }
}

@end

@implementation NdtTest : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"ndt";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

/*
 on_entry method for ndt test
 if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
 */
-(void)on_entry:(const char*)str{
    if (str != nil) {
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [super on_entry:json];

        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
            blocking = ANOMALY_ORANGE;
        [self updateAnomaly:blocking];
    }
}

@end

@implementation Dash : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

/*
 Note: here we're reusing NDT function since the entry has
 basically the same characteristics, as far as deciding the
 color of the test line is concerned.
 if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
 */
-(void)on_entry:(const char*)str{
    if (str != nil) {
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [super on_entry:json];

        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
            blocking = ANOMALY_ORANGE;
        [self updateAnomaly:blocking];
    }
}

@end

@implementation Whatsapp : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"whatsapp";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

/*
 whatsapp: red if "whatsapp_endpoints_status" or "whatsapp_web_status" or "registration_server" are "blocked"
 docs: https://github.com/TheTorProject/ooni-spec/blob/master/test-specs/ts-018-whatsapp.md#semantics
 */

-(void)on_entry:(const char*)str{
    if (str != nil) {
        /*if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }*/
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        //whatsapp_endpoints_status and whatsapp_web_status and registration_server_status must be both false if null (set test anomaly), if at least one is true (set test blocked)
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
        [self updateAnomaly:blocking];
    }
}

@end

@implementation Telegram : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"telegram";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}
/*
 for telegram: red if either "telegram_http_blocking" or "telegram_tcp_blocking" is true, OR if ""telegram_web_status" is "blocked"
 the "*_failure" keys for telegram and whatsapp might indicate a test failure / anomaly
 docs: https://github.com/TheTorProject/ooni-spec/blob/master/test-specs/ts-020-telegram.md#semantics
 */
-(void)on_entry:(const char*)str{
    if (str != nil) {
        /*if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }*/
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        //telegram_http_blocking and telegram_tcp_blocking must be both false if null (set test anomaly), if at least one is true (set test blocked)
        //telegram_web_status must be "ok", if null anomaly, if "blocked" (set test blocked)
        //telegram_web_failure must be null, if != null (set test blocked)
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
        [self updateAnomaly:blocking];
    }
}


@end

@implementation FacebookMessenger : MKNetworkTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
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
    test.on_entry([self](std::string s) {
        [self on_entry:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
}

/*
 FB: red blocking if either "facebook_tcp_blocking" or "facebook_dns_blocking" is true
 docs: https://github.com/TheTorProject/ooni-spec/blob/master/test-specs/ts-019-facebook-messenger.md#semantics
 */
-(void)on_entry:(const char*)str{
    if (str != nil) {
        /*if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }*/
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = ANOMALY_GREEN;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
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
        [self updateAnomaly:blocking];
    }
}


@end

