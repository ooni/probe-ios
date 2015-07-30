//
//  ViewController.m
//  test8
//
//  Created by Simone Basso on 18/01/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "ViewController.h"

/*Include header from test*/
#include "ight/ooni/dns_injection.hpp"
#include "ight/ooni/http_invalid_request_line.hpp"
#include "ight/ooni/tcp_connect.hpp"

#include "ight/common/poller.hpp"
#include "ight/common/log.hpp"
#include "ight/common/utils.hpp"

@implementation ViewController : UIViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
    [self loadAvailableMeasurements];
    self.manager = [[NetworkManager alloc] init];
    self.manager.running = false;
    self.manager.runningNetworkMeasurements = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"refreshTable" object:nil];
    [self setLabels];
}

- (void) loadAvailableMeasurements {
    DNSInjection *dns_injectionMeasurement = [[DNSInjection alloc] init];
    [self.availableNetworkMeasurements addObject:dns_injectionMeasurement];
    
    TCPConnect *tcp_connectMeasurement = [[TCPConnect alloc] init];
    [self.availableNetworkMeasurements addObject:tcp_connectMeasurement];
    
    HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
    [self.availableNetworkMeasurements addObject:http_invalid_request_lineMeasurement];
}

-(void)refreshTable{
    [self.tableView reloadData];
}

- (void) setLabels {
    [self.testing_historyLabel setText:NSLocalizedString(@"testing_history", nil)];
    [self.pending_testsLabel setText:NSLocalizedString(@"pending_tests", nil)];
    [self.run_testLabel setText:NSLocalizedString(@"run_test", nil)];
    
    [self.dns_injectionLabel setText:NSLocalizedString(@"dns_injection", nil)];
    [self.tcp_connectLabel setText:NSLocalizedString(@"tcp_connect", nil)];
    [self.http_invalid_request_lineLabel setText:NSLocalizedString(@"http_invalid_request_line", nil)];
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) runTests:(id)sender {
    if (self.selectedMeasurement != nil) {
        [self.selectedMeasurement run];
        [self.manager.runningNetworkMeasurements addObject:self.selectedMeasurement];
        [self.tableView reloadData];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.manager.runningNetworkMeasurements count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UIProgressView *bar = (UIProgressView*)[cell viewWithTag:2];
    UIButton *go_log = (UIButton *)[cell viewWithTag:3];
    NetworkMeasurement *current = [self.manager.runningNetworkMeasurements objectAtIndex:indexPath.row];
    [title setText:NSLocalizedString(current.name, nil)];
    //[title setText:NSLocalizedString(@"dns_injection", nil)];
    if (current.finished) [bar setProgress:1.0 animated:YES];
    else [bar setProgress:0.2 animated:YES];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"running_tests", nil);
}

- (void) unselectAll {
    [self.dns_injectionButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.tcp_connectButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.http_invalid_request_lineButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
}

//TODO one function click - example
- (IBAction)buttonClick:(id)sender forEvent:(UIEvent *)event {
    UIButton *tappedButton = (UIButton*)sender;
    [self unselectAll];
    [tappedButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    if (tappedButton == self.dns_injectionButton){
        DNSInjection *dns_injectionMeasurement = [[DNSInjection alloc] init];
        self.selectedMeasurement = dns_injectionMeasurement;
    }
    else if (tappedButton == self.tcp_connectButton) {
        TCPConnect *tcp_connectMeasurement = [[TCPConnect alloc] init];
        self.selectedMeasurement = tcp_connectMeasurement;
    }
    else if (tappedButton == self.http_invalid_request_lineButton){
        HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
        self.selectedMeasurement = http_invalid_request_lineMeasurement;
    }
    self.selectedMeasurement.manager = self.manager;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toLog"]){
        UINavigationController *navigationController = segue.destinationViewController;
        LogViewController *vc = (LogViewController * )navigationController.topViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [vc setTest:[self.manager.runningNetworkMeasurements objectAtIndex:indexPath.row]];
    }
    else if ([[segue identifier] isEqualToString:@"toInfo"]){
        UINavigationController *navigationController = segue.destinationViewController;
        TestInfoViewController *vc = (TestInfoViewController * )navigationController.topViewController;
        UIButton *tappedButton = (UIButton*)sender;
        if (tappedButton.tag == 1){
            [vc setFileName:@"ts-012-dns-injection"];
        }
        else if (tappedButton.tag == 2){
            [vc setFileName:@"ts-008-tcpconnect"];
        }
        else if (tappedButton.tag == 3){
            [vc setFileName:@"ts-007-http-invalid-request-line"];
        }
    }
}

@end
