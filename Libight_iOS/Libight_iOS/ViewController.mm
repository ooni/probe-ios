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

@implementation ViewController : UIViewController

- (void) loadAvailableMeasurements {
    DNSInjection *dns_injectionMeasurement = [[DNSInjection alloc] init];
    [self.availableNetworkMeasurements addObject:dns_injectionMeasurement];

    TCPConnect *tcp_connectMeasurement = [[TCPConnect alloc] init];
    [self.availableNetworkMeasurements addObject:tcp_connectMeasurement];

    HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
    [self.availableNetworkMeasurements addObject:http_invalid_request_lineMeasurement];
}

- (void) setLabels {
    [self.testing_historyLabel setText:NSLocalizedString(@"testing_history", nil)];
    [self.pending_testsLabel setText:NSLocalizedString(@"pending_tests", nil)];
    [self.run_testLabel setText:NSLocalizedString(@"run_test", nil)];
    
    [self.dns_injectionLabel setText:NSLocalizedString(@"dns_injection", nil)];
    [self.tcp_connectLabel setText:NSLocalizedString(@"tcp_connect", nil)];
    [self.http_invalid_request_lineLabel setText:NSLocalizedString(@"http_invalid_request_line", nil)];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
    [self loadAvailableMeasurements];
    
    self.runningNetworkMeasurements = [[NSMutableArray alloc] init];
    
    [self setLabels];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) runTests:(id)sender {
    [self.selectedMeasurement run];
    [self.runningNetworkMeasurements addObject:self.selectedMeasurement];
    self.selectedMeasurement = nullptr;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.runningNetworkMeasurements count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void) unselectAll {
    [self.dns_injectionButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.tcp_connectButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.http_invalid_request_lineButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
}

- (IBAction)dns_injectionClick:(id)sender forEvent:(UIEvent *)event {
    [self unselectAll];
    [self.dns_injectionButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    
    DNSInjection *dns_injectionMeasurement = [[DNSInjection alloc] init];
    self.selectedMeasurement = dns_injectionMeasurement;
}

- (IBAction)tcp_connectClick:(id)sender forEvent:(UIEvent *)event {
    [self unselectAll];
    [self.tcp_connectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];

    TCPConnect *tcp_connectMeasurement = [[TCPConnect alloc] init];
    self.selectedMeasurement = tcp_connectMeasurement;
}

- (IBAction)http_invalid_request_lineClick:(id)sender forEvent:(UIEvent *)event {
    [self unselectAll];
    [self.http_invalid_request_lineButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];

    HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
    self.selectedMeasurement = http_invalid_request_lineMeasurement;
}

@end
