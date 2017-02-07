// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "NetworkMeasurement.h"
#import "TestStorage.h"
#import "Tests.h"

#include <measurement_kit/ooni.hpp>
#include <measurement_kit/nettests.hpp>
#include <measurement_kit/ndt.hpp>

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

static void setup_idempotent() {
    static bool initialized = false;
    if (!initialized) {
        // Set the logger verbose and make sure it logs on the "logcat"
        mk::set_verbosity(MK_LOG_INFO);
        mk::on_log([](uint32_t, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        });
        initialized = true;
    }
}

static std::string get_dns_server() {
    std::string dns_server = "8.8.4.4";
    res_state res = nullptr;
    res = (res_state) malloc(sizeof(struct __res_state));
    if (res == nullptr) {
        return dns_server;
    }
    if (res_ninit(res) != 0) {
        free(res);
        return dns_server;
    }
    for (int i = 0; i < res->nscount; ++i) {
        char addr[INET_ADDRSTRLEN];
        if (inet_ntop(AF_INET, &res->nsaddr_list[i].sin_addr, addr,
                      sizeof (addr)) == nullptr) {
            continue;
        }
        #ifdef DEBUG
        NSLog(@"found DNS resolver: %s", addr);
        #endif
        dns_server = addr;
        break;
    }
    free(res);
    return dns_server;
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
    include_ip = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_ip"] boolValue];
    include_asn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_asn"] boolValue];
    include_cc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_cc"] boolValue];
    upload_results = [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
    collector_address = [[NSUserDefaults standardUserDefaults] stringForKey:@"collector_address"];
    max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    self.backgroundTask = UIBackgroundTaskInvalid;
    self.running = FALSE;
    self.viewed = FALSE;
    self.anomaly = 0;
    self.entry = FALSE;
    return self;
}

-(void) run {
    // Nothing to do here
}

- (void) run_test {
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.running = TRUE;
    [TestStorage add_test:self];
}

- (void)showNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"finished_running", nil), NSLocalizedString(self.name, nil)];
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToastFinished" object:nil userInfo:noteInfo];
    });
}

-(void)on_entry:(const char*)str{
    if (!self.entry){
        [TestStorage set_entry:self.test_id];
        self.entry = TRUE;
    }
    NSData *data = [[NSString stringWithUTF8String:str] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    int blocking = [Tests checkAnomaly:[json objectForKey:@"test_keys"]];
    if (blocking > self.anomaly){
        self.anomaly = blocking;
        [TestStorage set_anomaly:self.test_id :blocking];
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
    int anomaly = 0;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
        anomaly = 1;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        anomaly = 2;
    }
    return anomaly;
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
        .set_options("backend", [@"8.8.8.1:53" UTF8String])
        .set_options("dns/nameserver", get_dns_server())
        .set_options("dns/engine", "system") // This a fix for: https://github.com/measurement-kit/ooniprobe-ios/issues/61
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_error_filepath([[self getFileName:@"log"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
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
        .set_options("backend", [HIRL_BACKEND UTF8String])
        .set_options("dns/nameserver", get_dns_server())
        .set_options("dns/engine", "system") // This a fix for: https://github.com/measurement-kit/ooniprobe-ios/issues/61
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_error_filepath([[self getFileName:@"log"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_progress([self](double prog, const char *s) {
            [self updateProgress:prog];
        })
        .on_log([self](uint32_t type, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        })
        .on_entry([self](std::string s) {
            [self on_entry:s.c_str()];
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
        .set_options("port", 80)
        .set_options("dns/nameserver", get_dns_server())
        .set_options("dns/engine", "system") // This a fix for: https://github.com/measurement-kit/ooniprobe-ios/issues/61
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
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
    mk::nettests::WebConnectivityTest()
        .set_options("backend", [WC_BACKEND UTF8String])
        /*
         * XXX nameserver is the nameserver to be used by web connectivity to
         * perform its DNS checks. In theory it may differ from dns/nameserver
         * but, in practice, does it make sense to have two settings?
         */
        .set_options("dns/nameserver", get_dns_server())
        .set_options("dns/engine", "system") // This a fix for: https://github.com/measurement-kit/ooniprobe-ios/issues/61
        .set_options("nameserver", get_dns_server())
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("max_runtime", [max_runtime doubleValue])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String])
        .set_input_filepath([path UTF8String])
        .set_error_filepath([[self getFileName:@"log"] UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_progress([self](double prog, const char *s) {
            [self updateProgress:prog];
        })
        .on_log([self](uint32_t type, const char *s) {
            #ifdef DEBUG
            NSLog(@"%s", s);
            #endif
        })
        .on_entry([self](std::string s) {
            [self on_entry:s.c_str()];
        })
        .start([self]() {
            [self testEnded];
        });
}

@end

@implementation NdtTest : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"ndt_test";
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
        .set_options("test_suite", MK_NDT_DOWNLOAD | MK_NDT_UPLOAD)
        .set_options("dns/nameserver", get_dns_server())
        .set_options("dns/engine", "system") // This a fix for: https://github.com/measurement-kit/ooniprobe-ios/issues/61
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_options("software_name", [@"ooniprobe-ios" UTF8String])
        .set_options("software_version", [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
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
            [self on_entry:s.c_str()];
        })
        .start([self]() {
            [self testEnded];
        });
}

@end
