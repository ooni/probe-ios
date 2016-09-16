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
    collector_address = [[NSUserDefaults standardUserDefaults] stringForKey:@"collector_address"];
    self.completed = FALSE;
    return self;
}

-(void) run {
    // Nothing to do here
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


@implementation DNSInjection : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"dns_injection";
    return self;
}

- (void) run {
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    [TestStorage add_test:self];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::ooni::DnsInjection()
        .set_options("backend", "8.8.8.1:53")
        .set_options("dns/nameserver", get_dns_server())
        .set_options("net/ca_bundle_path", [ca_cert UTF8String])
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_log([self](uint32_t type, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate], [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            if ((type & MK_LOG_JSON) != 0) {
                NSData *data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                if ([json objectForKey:@"progress"]){
                    self.progress = [[json objectForKey:@"progress"] floatValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
            });
        })
        .run([self]() {
            NSLog(@"dns_injection testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completed = TRUE;
                [TestStorage set_completed:self.test_id];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
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

-(void) run {
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    [TestStorage add_test:self];
    setup_idempotent();
    mk::ooni::HttpInvalidRequestLine()
        .set_options("backend", "http://213.138.109.232/")
        .set_options("dns/nameserver", get_dns_server())
        .set_options("net/ca_bundle_path", [ca_cert UTF8String])
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_log([self](uint32_t type, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                                 [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            if ((type & MK_LOG_JSON) != 0) {
                NSData *data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                if ([json objectForKey:@"progress"]){
                    self.progress = [[json objectForKey:@"progress"] floatValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
            });
        })
        .run([self]() {
            NSLog(@"http_invalid_request_line testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completed = TRUE;
                [TestStorage set_completed:self.test_id];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            });
        });
}

@end

@implementation TCPConnect : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"tcp_connect";
    return self;
}

-(void) run {
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    [TestStorage add_test:self];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::ooni::TcpConnect()
        .set_options("port", 80)
        .set_options("dns/nameserver", get_dns_server())
        .set_options("net/ca_bundle_path", [ca_cert UTF8String])
        .set_options("geoip_country_path", [geoip_country UTF8String])
        .set_options("geoip_asn_path", [geoip_asn UTF8String])
        .set_options("save_real_probe_ip", include_ip)
        .set_options("save_real_probe_asn", include_asn)
        .set_options("collector_base_url", [collector_address UTF8String])
        .set_input_filepath([path UTF8String])
        .set_output_filepath([[self getFileName:@"json"] UTF8String])
        .set_verbosity(MK_LOG_INFO)
        .on_log([self](uint32_t type, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                                 [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            if ((type & MK_LOG_JSON) != 0) {
                NSData *data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                if ([json objectForKey:@"progress"]){
                    self.progress = [[json objectForKey:@"progress"] floatValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
            });
        })
        .run([self]() {
            NSLog(@"tcp_connect testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completed = TRUE;
                [TestStorage set_completed:self.test_id];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
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

-(void) run {
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    [TestStorage add_test:self];
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"urls" ofType:@"txt"];
    
    mk::ooni::WebConnectivity()
    .set_options("backend", "https://a.collector.test.ooni.io:4444")
    .set_options("nameserver", get_dns_server())
    .set_options("geoip_country_path", [geoip_country UTF8String])
    .set_options("geoip_asn_path", [geoip_asn UTF8String])
    .set_options("net/ca_bundle_path", [ca_cert UTF8String])
    .set_options("save_real_probe_ip", include_ip)
    .set_options("save_real_probe_asn", include_asn)
    .set_options("collector_base_url", [collector_address UTF8String])
    .set_input_filepath([path UTF8String])
    .set_output_filepath([[self getFileName:@"json"] UTF8String])
    .set_verbosity(MK_LOG_INFO)
    .on_log([self](uint32_t type, const char *s) {
        NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
        NSLog(@"%s", s);
        if ((type & MK_LOG_JSON) != 0) {
            NSData *data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if ([json objectForKey:@"progress"]){
                self.progress = [[json objectForKey:@"progress"] floatValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self writeOrAppend:current];
        });
    })
    .run([self]() {
        NSLog(@"web_connectivity testEnded");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completed = TRUE;
            [TestStorage set_completed:self.test_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
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

-(void) run {
    self.test_id = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    self.json_file = [NSString stringWithFormat:@"test-%@.json", self.test_id];
    self.log_file = [NSString stringWithFormat:@"test-%@.log", self.test_id];
    [TestStorage add_test:self];
        
    mk::ndt::NdtTest()
    .set_options("test_suite", MK_NDT_DOWNLOAD)
    .set_verbosity(MK_LOG_INFO)
    .set_output_filepath([[self getFileName:@"json"] UTF8String])
    .on_log([self](uint32_t type, const char *s) {
        NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
        NSLog(@"%s", s);
        if ((type & MK_LOG_JSON) != 0) {
            NSData *data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if ([json objectForKey:@"progress"]){
                self.progress = [[json objectForKey:@"progress"] floatValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
                });
            }
        }
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
    .set_options("collector_base_url", [collector_address UTF8String])
    .run([self]() {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completed = TRUE;
            [TestStorage set_completed:self.test_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        });
    });
}

@end