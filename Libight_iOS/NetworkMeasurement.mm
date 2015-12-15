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
        mk::set_verbose(1);
        // XXX Ok to call NSLog() from another thread?
        mk::on_log([](const char *s) {
            NSLog(@"%s", s);
        });

        // Copy DNS resolver(s) from device
        // This code copied from the iOS tutorial
        // XXX This should run before every test but to do this we need
        // to further change measurement-kit DNS code
        res_state res = nullptr;
        do {
            res = (res_state) malloc(sizeof(struct __res_state));
            if (res == nullptr) break;
            if (res_ninit(res) != 0) break;
            mk::clear_nameservers();
            for (int i = 0; i < res->nscount; ++i) {
                char addr[INET_ADDRSTRLEN];
                if (inet_ntop(AF_INET, &res->nsaddr_list[i].sin_addr, addr,
                            sizeof (addr)) == nullptr) {
                    continue;
                }
                mk::add_nameserver(addr);
                NSLog(@"adding DNS resolver: %s", addr);
            }
            free(res);
            res = nullptr;
        } while (0);
        if (res) free(res);

        // Remember that we have initialized
        initialized = true;
    }
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

-(NSString*) getDate{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    return [dateformatter stringFromDate:[NSDate date]];
}


@end


@implementation DNSInjection : NetworkMeasurement

-(id) init {
    self = [super init];
    self.name = @"dns_injection";
    return self;
}

- (void) run {
    setup_idempotent();
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];
    mk::ooni::DnsInjectionTest()
        .set_backend("8.8.8.8:53")
        .set_input_file_path([path UTF8String])
        .set_verbose()
        .on_log([self](const char *s) {
            NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate], [NSString stringWithUTF8String:s]];
            NSLog(@"%s", s);
            dispatch_async(dispatch_get_main_queue(), ^{
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
    setup_idempotent();
    mk::ooni::HttpInvalidRequestLineTest()
    .set_backend("http://www.google.com/")
    .set_verbose()
    .on_log([self](const char *s) {
        // XXX OK to send messages to object from another thread?
        NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
        NSLog(@"%s", s);
        dispatch_async(dispatch_get_main_queue(), ^{
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
    setup_idempotent();

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"hosts" ofType:@"txt"];

    mk::ooni::TcpConnectTest()
    .set_port("80")
    .set_input_file_path([path UTF8String])
    .set_verbose()
    .on_log([self](const char *s) {
        NSString *current = [NSString stringWithFormat:@"%@: %@", [super getDate],
                             [NSString stringWithUTF8String:s]];
        NSLog(@"%s", s);
        dispatch_async(dispatch_get_main_queue(), ^{
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
