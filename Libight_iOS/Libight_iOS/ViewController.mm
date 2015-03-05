//
//  ViewController.m
//  test8
//
//  Created by Simone Basso on 18/01/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "ViewController.h"

/*Include header from test*/
#include "ooni/dns_injection.hpp"
#include "ooni/http_invalid_request_line.hpp"
#include "ooni/tcp_connect.hpp"

#include "common/poller.h"
#include "common/log.h"
#include "common/utils.hpp"


@interface ViewController ()
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.testing_historyLabel setText:NSLocalizedString(@"testing_history", nil)];
    [self.pending_testsLabel setText:NSLocalizedString(@"pending_tests", nil)];
    [self.run_testLabel setText:NSLocalizedString(@"run_test", nil)];
    
    [self.dns_injectionLabel setText:NSLocalizedString(@"dns_injection", nil)];
    [self.tcp_connectLabel setText:NSLocalizedString(@"tcp_connect", nil)];
    [self.http_invalid_request_lineLabel setText:NSLocalizedString(@"http_invalid_request_line", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)runTests:(id)sender{
    [self dns_injection_test];
}

- (void)dns_injection_test {
    NSString *pathToHost = [[NSBundle mainBundle] pathForResource:@"hosts" ofType:@"txt"];
    
    /*DNS_INJECTION TEST*/
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

-(void)http_invalid_request_line_test{
    /*HTTP INVALID REQUEST LINE TEST*/
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

-(void)tcp_connect_test{
    /*TCP CONNECT TEST*/
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}


- (IBAction)dns_injectionClick:(id)sender forEvent:(UIEvent *)event {
    printf("DNS Injection clicked");

}

- (IBAction)tcp_connectClick:(id)sender forEvent:(UIEvent *)event {
    printf("TCP clicked");

}

- (IBAction)http_invalid_request_lineClick:(id)sender forEvent:(UIEvent *)event {
    printf("HTTP clicked");
}
@end
