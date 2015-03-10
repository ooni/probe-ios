//
//  NetworkMeasurement.m
//  libight_ios
//
//  Created by x on 3/5/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "NetworkMeasurement.h"

/*Include header from test*/
#include "ooni/dns_injection.hpp"
#include "ooni/http_invalid_request_line.hpp"
#include "ooni/tcp_connect.hpp"

#include "common/poller.h"
#include "common/log.h"
#include "common/utils.hpp"

@implementation NetworkMeasurement

@end


@implementation DNSInjection : NetworkMeasurement

- (void)run {
    NSString *pathToHost = [[NSBundle mainBundle] pathForResource:@"hosts" ofType:@"txt"];
    
    ight_set_verbose(1);
    ight::common::Settings options;
    options["nameserver"] = "8.8.8.8:53";
    ight::ooni::dns_injection::DNSInjection dns_injection([pathToHost UTF8String], options);
    dns_injection.begin([&](){
        dns_injection.end([](){
            ight_break_loop();
        });
    });
    ight_loop();
}


@end

@implementation HTTPInvalidRequestLine : NetworkMeasurement

-(void)run {
    ight_set_verbose(1);
    ight::common::Settings options;
    options["backend"] = "http://google.com/";
    ight::ooni::http_invalid_request_line::HTTPInvalidRequestLine http_invalid_request_line(options);
    http_invalid_request_line.begin([&](){
        http_invalid_request_line.end([](){
            ight_break_loop();
        });
    });
    ight_loop();
}

@end

@implementation TCPConnect : NetworkMeasurement

-(void)run {
    NSString *pathToHost = [[NSBundle mainBundle] pathForResource:@"hosts" ofType:@"txt"];
    
    ight_set_verbose(1);
    ight::ooni::tcp_connect::TCPConnect tcp_connect([pathToHost UTF8String], {
        {"port", "80"},
    });
    tcp_connect.begin([&]() {
        tcp_connect.end([]() {
            ight_break_loop();
        });
    });
    ight_loop();
}

@end