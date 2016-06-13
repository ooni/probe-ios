// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "NetworkMeasurement.h"

#import "measurement_kit/common.hpp"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

static void setup_idempotent() {
    static bool initialized = false;
    if (!initialized) {
        // Set the logger verbose and make sure it logs on the "logcat"
        mk::set_verbosity(MK_LOG_DEBUG2);
        // XXX Ok to call NSLog() from another thread?
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
    self.logLines = [[NSMutableArray alloc] init];
    self.finished = FALSE;
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

-(NSString*) getFileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/test-%f", documentsDirectory, [[NSDate date] timeIntervalSince1970]];
    NSLog(@"documentsDirectory %@", fileName);
    return fileName;
}

-(void)writeOrAppend:(NSString*)string{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self.log_file])
    {
        [string writeToFile:self.log_file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:self.log_file];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[[NSString stringWithFormat:@"\n%@",string] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
@end


@implementation DNSInjection : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"dns_injection";
    return self;
}

- (void) run {
    self.json_file = [NSString stringWithFormat:@"%@.json", [self getFileName]];
    self.log_file = [NSString stringWithFormat:@"%@.txt", [self getFileName]];

    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::ooni::DnsInjectionTest()
        .set_options("backend", "8.8.8.1:53")
        .set_options("dns/nameserver", get_dns_server())
        .set_input_file_path([path UTF8String])
        .set_output_file_path([self.json_file UTF8String])
        .set_verbosity(MK_LOG_DEBUG2)
        .on_log([self](uint32_t, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate], [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
                [self.logLines addObject:current];
            });
        })
        .run([self]() {
            NSLog(@"dns_injection testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.finished = TRUE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
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
    self.json_file = [NSString stringWithFormat:@"%@.json", [self getFileName]];
    self.log_file = [NSString stringWithFormat:@"%@.txt", [self getFileName]];

    setup_idempotent();
    mk::ooni::HttpInvalidRequestLineTest()
        .set_options("backend", "http://213.138.109.232/")
        .set_options("dns/nameserver", get_dns_server())
        .set_output_file_path([self.json_file UTF8String])
        .set_verbosity(MK_LOG_DEBUG2)
        .on_log([self](uint32_t, const char *s) {
            // XXX OK to send messages to object from another thread?
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                                 [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
                [self.logLines addObject:current];
            });
        })
        .run([self]() {
            NSLog(@"http_invalid_request_line testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.finished = TRUE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
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
    self.json_file = [NSString stringWithFormat:@"%@.json", [self getFileName]];
    self.log_file = [NSString stringWithFormat:@"%@.txt", [self getFileName]];

    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::ooni::TcpConnectTest()
        .set_options("port", "80")
        .set_options("dns/nameserver", get_dns_server())
        .set_input_file_path([path UTF8String])
        .set_output_file_path([self.json_file UTF8String])
        .set_verbosity(MK_LOG_DEBUG2)
        .on_log([self](uint32_t, const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                                 [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeOrAppend:current];
                [self.logLines addObject:current];
            });
        })
        .run([self]() {
            NSLog(@"tcp_connect testEnded");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.finished = TRUE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
            });
        });
}

@end
