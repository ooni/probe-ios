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


static void setup_idempotent() {
    static bool initialized = false;
    if (!initialized) {
        // Set the logger verbose and make sure it logs on the "logcat"
        mk::set_verbosity(VERBOSITY);
        mk::on_log([](uint32_t, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        });
        initialized = true;
    }
}

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

- (void) run_test {
    include_ip = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_ip"] boolValue];
    include_asn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_asn"] boolValue];
    include_cc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_cc"] boolValue];
    upload_results = [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
    collector_address = [[NSUserDefaults standardUserDefaults] stringForKey:@"collector_address"];
    max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    software_version = [VersionUtility get_software_version];
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.running = TRUE;
    [TestStorage add_test:self];
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

-(void)on_entry_wc:(const char*)str{
    if (str != nil) {
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = [Tests checkAnomaly:[json objectForKey:@"test_keys"]];
        if (blocking > self.anomaly){
            self.anomaly = blocking;
            [TestStorage set_anomaly:self.test_id :blocking];
        }
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

/*
 on_entry method for http invalid request line test
 if the "tampering" key exists and is null then anomaly will be set to 1 (orange)
 otherwise "tampering" object exists and is TRUE, then anomaly will be set to 2 (red)
 */
-(void)on_entry_hirl:(const char*)str{
    if (str != nil) {
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = ANOMALY_GREEN;
        if ([[json objectForKey:@"test_keys"] objectForKey:@"tampering"]){
            //this case shouldn't happen
            if ([[json objectForKey:@"test_keys"] objectForKey:@"tampering"] == [NSNull null])
                blocking = ANOMALY_ORANGE;
            else if ([[[json objectForKey:@"test_keys"] objectForKey:@"tampering"] boolValue])
                blocking = ANOMALY_RED;
        }
        if (blocking > self.anomaly){
            self.anomaly = blocking;
            [TestStorage set_anomaly:self.test_id :blocking];
        }
    }
}

/*
 on_entry method for http invalid request line test
 if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
 otherwise the keys in the "tampering" object will be checked, if any of them is TRUE, then anomaly will be set to 2 (red)
 */
-(void)on_entry_hhfm:(const char*)str{
    if (str != nil) {
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        int blocking = ANOMALY_GREEN;
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
        if (blocking > self.anomaly){
            self.anomaly = blocking;
            [TestStorage set_anomaly:self.test_id :blocking];
        }
    }
}

/*
 on_entry method for ndt and dash test
 if the "failure" key exists and is not null then anomaly will be set to 1 (orange)
 */
-(void)on_entry_ndt:(const char*)str{
    if (str != nil) {
        if (!self.entry){
            [TestStorage set_entry:self.test_id];
            self.entry = TRUE;
        }
        NSError *error;
        NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        int blocking = ANOMALY_GREEN;
        if ([[json objectForKey:@"test_keys"] objectForKey:@"failure"] != [NSNull null])
            blocking = ANOMALY_ORANGE;
        if (blocking > self.anomaly){
            self.anomaly = blocking;
            [TestStorage set_anomaly:self.test_id :blocking];
        }
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

// NOT USED
@implementation DNSInjection : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"dns_injection";
    return self;
}

-(void)run{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    [self run_test];
}

- (void) run_test {
    [super run_test];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::nettests::DnsInjectionTest()
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [software_version UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_error_filepath([[self getFileName:@"log"] UTF8String])
        .set_verbosity(VERBOSITY)
        .on_progress([self](double prog, const char *s) {
            [self updateProgress:prog];
        })
        .on_log([self](uint32_t type, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        })
        .start([self]() {
            [self testEnded];
        });
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
    [super run_test];
    setup_idempotent();
    mk::nettests::HttpInvalidRequestLineTest()
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [software_version UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_error_filepath([[self getFileName:@"log"] UTF8String])
        .set_verbosity(VERBOSITY)
        .on_progress([self](double prog, const char *s) {
            [self updateProgress:prog];
        })
        .on_log([self](uint32_t type, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        })
        .on_entry([self](std::string s) {
            [self on_entry_hirl:s.c_str()];
        })
        .start([self]() {
            [self testEnded];
        });
}

@end

// NOT USED
@implementation TCPConnect : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"tcp_connect";
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
    [super run_test];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    setup_idempotent();
    mk::nettests::TcpConnectTest()
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [software_version UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(VERBOSITY)
        .on_progress([self](double prog, const char *s) {
            [self updateProgress:prog];
        })
        .on_log([self](uint32_t type, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        })
        .start([self]() {
            [self testEnded];
        });
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
    [super run_test];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"global" ofType:@"txt"];
    setup_idempotent();
    mk::nettests::WebConnectivityTest test;
    test.set_options("geoip_country_path", [geoip_country UTF8String]);
    test.set_options("geoip_asn_path", [geoip_asn UTF8String]);
    test.set_options("save_real_probe_ip", include_ip);
    test.set_options("save_real_probe_asn", include_asn);
    test.set_options("save_real_probe_cc", include_cc);
    test.set_options("no_collector", !upload_results);
    test.set_options("collector_base_url", [collector_address UTF8String]);
    test.set_options("software_name", [@"ooniprobe-ios" UTF8String]);
    test.set_options("software_version", [software_version UTF8String]);
    if ([self.inputs count] > 0) {
        for (NSString* input in self.inputs) {
            test.add_input([input UTF8String]);
        }
    }
    else {
        //For now I consider when there are inputs = ran from URI scheme, when don't ran normal test
        //TODO This class has to be improved, waiting for test list managment functions
        test.set_options("max_runtime", [max_runtime doubleValue]);
        test.set_input_filepath([path UTF8String]);
    }
    test.set_error_filepath([[self getFileName:@"log"] UTF8String]);
    test.set_output_filepath([[self getFileName:@"json"] UTF8String]);
    test.set_verbosity(VERBOSITY);
    test.on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    });
    test.on_log([self](uint32_t type, const char *s) {
        #ifdef DEBUG
        NSLog(@"%s", s);
        #endif
    });
    test.on_entry([self](std::string s) {
        [self on_entry_wc:s.c_str()];
    });
    test.start([self]() {
        [self testEnded];
    });
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
    [super run_test];
    mk::nettests::NdtTest()
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [software_version UTF8String])
        .set_verbosity(VERBOSITY)
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_error_filepath([[self getFileName:@"log"] UTF8String])
        .on_progress([self](double prog, const char *s) {
            [self updateProgress:prog];
        })
        .on_log([self](uint32_t type, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        })
        .on_entry([self](std::string s) {
            [self on_entry_ndt:s.c_str()];
        })
        .start([self]() {
            [self testEnded];
        });
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
    [super run_test];
    setup_idempotent();
    mk::nettests::HttpHeaderFieldManipulationTest()
    .set_options("geoip_country_path", [geoip_country UTF8String])
    .set_options("geoip_asn_path", [geoip_asn UTF8String])
    .set_options("save_real_probe_ip", include_ip)
    .set_options("save_real_probe_asn", include_asn)
    .set_options("save_real_probe_cc", include_cc)
    .set_options("no_collector", !upload_results)
    .set_options("collector_base_url", [collector_address UTF8String])
    .set_options("software_name", [@"ooniprobe-ios" UTF8String])
    .set_options("software_version", [software_version UTF8String])
    .set_output_filepath([[self getFileName:@"json"] UTF8String])
    .set_error_filepath([[self getFileName:@"log"] UTF8String])
    .set_verbosity(VERBOSITY)
    .on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    })
    .on_log([self](uint32_t type, const char *s) {
#ifdef DEBUG
        NSLog(@"%s", s);
#endif
    })
    .on_entry([self](std::string s) {
        [self on_entry_hhfm:s.c_str()];
    })
    .start([self]() {
        [self testEnded];
    });
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
    [super run_test];
    setup_idempotent();
    mk::nettests::DashTest()
    .set_options("geoip_country_path", [geoip_country UTF8String])
    .set_options("geoip_asn_path", [geoip_asn UTF8String])
    .set_options("save_real_probe_ip", include_ip)
    .set_options("save_real_probe_asn", include_asn)
    .set_options("save_real_probe_cc", include_cc)
    .set_options("no_collector", !upload_results)
    .set_options("collector_base_url", [collector_address UTF8String])
    .set_options("software_name", [@"ooniprobe-ios" UTF8String])
    .set_options("software_version", [software_version UTF8String])
    .set_output_filepath([[self getFileName:@"json"] UTF8String])
    .set_error_filepath([[self getFileName:@"log"] UTF8String])
    .set_verbosity(VERBOSITY)
    .on_progress([self](double prog, const char *s) {
        [self updateProgress:prog];
    })
    .on_log([self](uint32_t type, const char *s) {
#ifdef DEBUG
        NSLog(@"%s", s);
#endif
    })
    .on_entry([self](std::string s) {
        // Note: here we're reusing NDT function since the entry has
        // basically the same characteristics, as far as deciding the
        // color of the test line is concerned.
        [self on_entry_ndt:s.c_str()];
    })
    .start([self]() {
        [self testEnded];
    });
}

@end
