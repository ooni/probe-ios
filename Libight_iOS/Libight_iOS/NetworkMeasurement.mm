//
//  NetworkMeasurement.m
//  libight_ios
//
//  Created by x on 3/5/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "NetworkMeasurement.h"

@implementation NetworkMeasurement

-(id) init {
    self = [super init];
    self.logLines = [[NSMutableArray alloc] init];
    return self;
}

-(void) run {
    [self setupLogger];
}

-(void) setupLogger {
    ight_set_verbose(1);

    ight_set_logger([self](const char *s) {
        [self.logLines addObject:[NSString stringWithUTF8String:s]];
    });
}

@end


@implementation DNSInjection : NetworkMeasurement

- (void) run {
    [super run];

    NSString *pathToHost = [[NSBundle mainBundle] pathForResource:@"hosts" ofType:@"txt"];
    
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

-(void) run {
    [super run];
    
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

-(void) run {
    [super run];

    NSString *pathToHost = [[NSBundle mainBundle] pathForResource:@"hosts" ofType:@"txt"];

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