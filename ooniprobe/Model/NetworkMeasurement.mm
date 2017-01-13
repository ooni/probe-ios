// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "NetworkMeasurement.h"
#import "TestStorage.h"

#import "measurement_kit/common.hpp"
#import "measurement_kit/ndt.hpp"

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
            NSLog(@"%s", s);
        });
        initialized = true;
    }
}

static std::string get_dns_server() {
    std::string dns_server = "8.8.4.4:53";
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
        NSLog(@"found DNS resolver: %s", addr);
        dns_server = addr;
        break;
    }
    free(res);
    return dns_server;
}


@implementation NetworkMeasurement

-(id) init {
    self = [super init];
    NSBundle *bundle = [NSBundle mainBundle];
    geoip_asn = [bundle pathForResource:@"GeoIPASNum" ofType:@"dat"];
    geoip_country = [bundle pathForResource:@"GeoIP" ofType:@"dat"];
    ca_cert = [bundle pathForResource:@"cacert" ofType:@"pem"];
    include_ip = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_ip"] boolValue];
    include_asn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_asn"] boolValue];
    include_cc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"include_cc"] boolValue];
    upload_results = [[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue];
    collector_address = [[NSUserDefaults standardUserDefaults] stringForKey:@"collector_address"];
    max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
    self.backgroundTask = UIBackgroundTaskInvalid;
    return self;
}

-(void) run {
    // Nothing to do here
}

- (void)showNotification
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = [NSString stringWithFormat:@"Test %@ finished running", self.name];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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

-(void)writeOrAppend:(NSString*)string{
    NSString *fileName = [self getFileName:@"log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Note: It is not optimal to open(), close(), and seek() each time
    // but we agreed not to touch this code because MK should soon add the
    // code to specify the file where to save log files.
    if(![fileManager fileExistsAtPath:fileName])
    {
        [string writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[[NSString stringWithFormat:@"\n%@",string] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"Test_name"];
    [coder encodeObject:self.test_id forKey:@"Test_id"];
    [coder encodeObject:self.json_file forKey:@"Test_jsonfile"];
    [coder encodeObject:self.log_file forKey:@"Test_logfile"];
    [coder encodeObject:[NSNumber numberWithBool:self.completed] forKey:@"test_completed"];
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
    self.completed = [[coder decodeObjectForKey:@"test_completed"] boolValue];
    return self;
}

@end

//NOT USED
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
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.completed = FALSE;
    [TestStorage add_test:self];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::nettests::DnsInjectionTest()
        .set_options("backend", "8.8.8.1:53")
        .set_options("dns/nameserver", get_dns_server())
        .set_options("net/ca_bundle_path", [ca_cert UTF8String])
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_progress([self](double prog, const char *s) {
            NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%: %s", prog * 100.0, s];
            self.progress = prog;
            NSLog(@"%@", os);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
            });
        })
        .on_log([self](uint32_t type, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
            });
        })
        .start([self]() {
            NSLog(@"dns_injection testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completed = TRUE;
                [TestStorage set_completed:self.test_id];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                [self showNotification];
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
                self.backgroundTask = UIBackgroundTaskInvalid;
            });
        });
}

@end

@implementation HTTPInvalidRequestLine : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"http_invalid_request_line";
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
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.completed = FALSE;
    [TestStorage add_test:self];
    setup_idempotent();
    mk::nettests::HttpInvalidRequestLineTest()
        .set_options("backend", [HIRL_BACKEND UTF8String])
        .set_options("dns/nameserver", get_dns_server())
        .set_options("net/ca_bundle_path", [ca_cert UTF8String])
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_progress([self](double prog, const char *s) {
            NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%: %s", prog * 100.0, s];
            self.progress = prog;
            NSLog(@"%@", os);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
            });
        })
        .on_log([self](uint32_t type, const char *s) {
                NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
            });
        })
        .start([self]() {
            NSLog(@"http_invalid_request_line testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completed = TRUE;
                [TestStorage set_completed:self.test_id];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                [self showNotification];
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
                self.backgroundTask = UIBackgroundTaskInvalid;
            });
        });
}

@end

//NOT USED
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
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.completed = FALSE;
    [TestStorage add_test:self];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::nettests::TcpConnectTest()
        .set_options("port", 80)
        .set_options("dns/nameserver", get_dns_server())
        .set_options("net/ca_bundle_path", [ca_cert UTF8String])
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("save_real_probe_cc", include_cc)
        .set_options("no_collector", !upload_results)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_progress([self](double prog, const char *s) {
            NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%: %s", prog * 100.0, s];
            self.progress = prog;
            NSLog(@"%@", os);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
            });
        })
        .on_log([self](uint32_t type, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
            });
        })
        .start([self]() {
            NSLog(@"tcp_connect testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completed = TRUE;
                [TestStorage set_completed:self.test_id];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                [self showNotification];
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
                self.backgroundTask = UIBackgroundTaskInvalid;
            });
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
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.completed = FALSE;
    [TestStorage add_test:self];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"global" ofType:@"txt"];
    mk::nettests::WebConnectivityTest()
    .set_options("backend", [WC_BACKEND UTF8String])
    .set_options("port", 80)
    .set_options("dns/nameserver", get_dns_server())
    .set_options("nameserver", get_dns_server())
    .set_options("geoip_country_path", [geoip_country UTF8String])
    .set_options("geoip_asn_path", [geoip_asn UTF8String])
    .set_options("net/ca_bundle_path", [ca_cert UTF8String])
    .set_options("save_real_probe_ip", include_ip)
    .set_options("save_real_probe_asn", include_asn)
    .set_options("save_real_probe_cc", include_cc)
    .set_options("no_collector", !upload_results)
    .set_options("collector_base_url", [collector_address UTF8String])
    .set_options("max_runtime", [max_runtime doubleValue])
    .set_input_filepath([path UTF8String])
    .set_error_filepath([[self getFileName:@"log"] UTF8String])
    .set_output_filepath([[self getFileName:@"json"] UTF8String])
    .set_verbosity(MK_LOG_INFO)
    .on_progress([self](double prog, const char *s) {
        NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%: %s", prog * 100.0, s];
        self.progress = prog;
        NSLog(@"%@", os);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
        });
    })
    .on_log([self](uint32_t type, const char *s) {
        NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
        NSLog(@"%s", s);
    })
    .start([self]() {
        NSLog(@"web_connectivity testEnded");
        self.completed = TRUE;
        [TestStorage set_completed:self.test_id];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        [self showNotification];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispatch_async web_connectivity testEnded");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            /*
            self.completed = TRUE;
            [TestStorage set_completed:self.test_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [self showNotification];
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
            self.backgroundTask = UIBackgroundTaskInvalid;
             */
        });
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
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    self.progress = 0;
    self.completed = FALSE;
    [TestStorage add_test:self];
    mk::nettests::NdtTest()
    .set_options("test_suite", MK_NDT_DOWNLOAD)
    .set_verbosity(MK_LOG_INFO)
    .set_output_filepath([[self getFileName:@"json"] UTF8String])
    .on_progress([self](double prog, const char *s) {
        NSString *os = [NSString stringWithFormat:@"Progress: %.1f%%: %s", prog * 100.0, s];
        self.progress = prog;
        NSLog(@"%@", os);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
        });
    })
    .on_log([self](uint32_t type, const char *s) {
        NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
        NSLog(@"%s", s);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self writeOrAppend:current];
        });
    })
    .set_options("net/ca_bundle_path", [ca_cert UTF8String])
    .set_options("dns/nameserver", get_dns_server())
    .set_options("geoip_country_path", [geoip_country UTF8String])
    .set_options("geoip_asn_path", [geoip_asn UTF8String])
    .set_options("save_real_probe_ip", include_ip)
    .set_options("save_real_probe_asn", include_asn)
    .set_options("save_real_probe_cc", include_cc)
    .set_options("no_collector", !upload_results)
    .set_options("collector_base_url", [collector_address UTF8String])
    .start([self]() {
        NSLog(@"ndt testEnded");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completed = TRUE;
            [TestStorage set_completed:self.test_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [self showNotification];
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
            self.backgroundTask = UIBackgroundTaskInvalid;
        });
    });
}

@end
