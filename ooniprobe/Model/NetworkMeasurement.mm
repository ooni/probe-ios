#import "NetworkMeasurement.h"
#import "TestStorage.h"
#import "Tests.h"
#import "VersionUtility.h"

#include <measurement_kit/ooni.hpp>
#include <measurement_kit/nettests.hpp>
#include <measurement_kit/ndt.hpp>

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

#define VERBOSITY MK_LOG_INFO
#define ANOMALY_GREEN 0
#define ANOMALY_ORANGE 1
#define ANOMALY_RED 2

@implementation NetworkMeasurement

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSBundle *bundle = [NSBundle mainBundle];
    geoip_asn = [bundle pathForResource:@"GeoIPASNum" ofType:@"dat"];
    geoip_country = [bundle pathForResource:@"GeoIP" ofType:@"dat"];
    self.running = FALSE;
    self.viewed = FALSE;
    self.anomaly = ANOMALY_GREEN;
    self.entry = FALSE;
    self.backgroundTask = UIBackgroundTaskInvalid;
    return self;
}

-(void) run {
    // Nothing to do here
}

- (void) init_common:(mk::nettests::BaseTest&) test{
    include_ip = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_ip"] boolValue];
    include_asn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_asn"] boolValue];
    include_cc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_cc"] boolValue];
    upload_results = [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
    max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    software_version = [VersionUtility get_software_version];
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.running = TRUE;
    [TestStorage add_test:self];
    //Configuring common test parameters
    test.set_option("geoip_country_path", [geoip_country UTF8String]);
    test.set_option("geoip_asn_path", [geoip_asn UTF8String]);
    test.set_option("save_real_probe_ip", include_ip);
    test.set_option("save_real_probe_asn", include_asn);
    test.set_option("save_real_probe_cc", include_cc);
    test.set_option("no_collector", !upload_results);
    test.set_option("software_name", [@"ooniprobe-ios" UTF8String]);
    test.set_option("software_version", [software_version UTF8String]);
    test.set_error_filepath([[self getFileName:@"log"] UTF8String]);
    test.set_output_filepath([[self getFileName:@"json"] UTF8String]);
    test.set_verbosity(VERBOSITY);
    test.on_log([self](uint32_t type, const char *s) {
#ifdef DEBUG
        NSLog(@"%s", s);
#endif
    });
    test.on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    });
}

- (void)showNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"finished_running", nil), NSLocalizedString(self.name, nil)];
        [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    });
}

-(NSString*) getDate {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    return [dateformatter stringFromDate:[NSDate date]];
}

-(NSString*) getFileName:(NSString*)ext {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/test-%@.%@", documentsDirectory, self.test_id, ext];
    return fileName;
}

-(void)updateProgress:(double)prog {
    self.progress = prog;
#ifdef DEBUG
    NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%", prog * 100.0];
    NSLog(@"%@", os);
#endif
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgress" object:nil];
    });
}

-(void)testEnded{
#ifdef DEBUG
    NSLog(@"%@ testEnded", self.name);
#endif
    self.running = FALSE;
    [TestStorage set_completed:self.test_id];
    [self showNotification];
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
        NSDictionary *noteInfo = [NSDictionary dictionaryWithObject:self.name forKey:@"test_name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToastTestFinished" object:nil userInfo:noteInfo];
    });
}

-(void)updateAnomaly:(int)blocking{
    if (blocking > self.anomaly){
        self.anomaly = blocking;
        [TestStorage set_anomaly:self.test_id :blocking];
    }
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"Test_name"];
    [coder encodeObject:self.test_id forKey:@"Test_id"];
    [coder encodeObject:self.json_file forKey:@"Test_jsonfile"];
    [coder encodeObject:self.log_file forKey:@"Test_logfile"];
    [coder encodeObject:[NSNumber numberWithBool:self.running] forKey:@"test_running"];
    [coder encodeObject:[NSNumber numberWithBool:self.viewed] forKey:@"test_viewed"];
    [coder encodeObject:[NSNumber numberWithInt:self.anomaly] forKey:@"anomaly"];
    [coder encodeObject:[NSNumber numberWithInt:self.entry] forKey:@"entry"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.name = [coder decodeObjectForKey:@"Test_name"];
    self.test_id = [coder decodeObjectForKey:@"Test_id"];
    self.json_file = [coder decodeObjectForKey:@"Test_jsonfile"];
    self.log_file = [coder decodeObjectForKey:@"Test_logfile"];
    self.running = [[coder decodeObjectForKey:@"test_running"] boolValue];
    self.viewed = [[coder decodeObjectForKey:@"test_viewed"] boolValue];
    self.anomaly = [[coder decodeObjectForKey:@"anomaly"] intValue];
    self.entry = [[coder decodeObjectForKey:@"entry"] boolValue];
    return self;
}

@end

@implementation HTTPInvalidRequestLine : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"http_invalid_request_line";
    return self;
}

-(void)run {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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

@implementation WebConnectivity : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"web_connectivity";
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self run_test];
}

-(void) run_test {
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking;
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"Error parsing JSON: %@", error);
#endif
            blocking = ANOMALY_ORANGE;
            [self updateAnomaly:blocking];
            return;
        }
        blocking = [Tests checkAnomaly:[json objectForKey:@"test_keys"]];
        [self updateAnomaly:blocking];
    }
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

@end

@implementation NdtTest : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"ndt";
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self run_test];
}

-(void) run_test {
    mk::nettests::NdtTest test;
    [super init_common:test];
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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
        if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
            blocking = ANOMALY_ORANGE;
        [self updateAnomaly:blocking];
    }
}

@end


@implementation HttpHeaderFieldManipulation : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"http_header_field_manipulation";
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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


@implementation Dash : NetworkMeasurement

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"dash";
    }
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self run_test];
}

-(void) run_test {
    mk::nettests::DashTest test;
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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
        if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
            blocking = ANOMALY_ORANGE;
        [self updateAnomaly:blocking];
    }
}

@end

@implementation Whatsapp : NetworkMeasurement

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"whatsapp";
    }
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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

@implementation Telegram : NetworkMeasurement

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"telegram";
    }
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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

@implementation FacebookMessenger : NetworkMeasurement

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"facebook_messenger";
    }
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
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
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
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
