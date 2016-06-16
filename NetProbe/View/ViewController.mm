//
//  ViewController.m
//  test8
//
//  Created by Simone Basso on 18/01/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "ViewController.h"

/*Include header from test*/
#include "measurement_kit/ooni.hpp"

#include "measurement_kit/common.hpp"

@implementation ViewController : UIViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
    [self loadAvailableMeasurements];
    self.runningNetworkMeasurements = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshTable" object:nil];
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

-(void)refreshTable:(NSNotification *)notification{
    NetworkMeasurement *current  = (NetworkMeasurement*)[notification object];
    [self.runningNetworkMeasurements removeObject:current];
    [self.tableView reloadData];
}

- (void) setLabels {
    [self.testing_historyLabel setText:[NSLocalizedString(@"testing_history", nil) uppercaseString]];
    [self.pending_testsLabel setText:[NSLocalizedString(@"pending_tests", nil)  uppercaseString]];
    [self.run_testLabel setText:[NSLocalizedString(@"run_test", nil)  uppercaseString]];
    
    [self.dns_injectionLabel setText:[NSLocalizedString(@"dns_injection", nil) uppercaseString]];
    [self.tcp_connectLabel setText:[NSLocalizedString(@"tcp_connect", nil) uppercaseString]];
    [self.http_invalid_request_lineLabel setText:[NSLocalizedString(@"http_invalid_request_line", nil) uppercaseString]];
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) runTests:(id)sender {
    if (self.selectedMeasurement != nil) {
        [self.selectedMeasurement run];
        [self.runningNetworkMeasurements addObject:self.selectedMeasurement];
        [self unselectAll];
        self.selectedMeasurement = nil;
        [self.tableView reloadData];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [self.runningNetworkMeasurements count];
            break;
        case 1:
            return [[TestStorage get_tests] count]-[self.runningNetworkMeasurements count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"running_tests", @"");
            break;
        case 1:
            sectionName = NSLocalizedString(@"finished_tests", @"");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NetworkMeasurement *current;

    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_running" forIndexPath:indexPath];
        current = [self.runningNetworkMeasurements objectAtIndex:indexPath.row];
        UIProgressView *bar = (UIProgressView*)[cell viewWithTag:2];
        [bar setProgress:0.2 animated:NO];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_finished" forIndexPath:indexPath];
        current = [NSKeyedUnarchiver unarchiveObjectWithData:[[TestStorage get_tests] objectAtIndex:indexPath.row]];
        //TODO for now I hide the logbutton on aborted test. need an icon
        UIButton *logbutton = (UIButton*)[cell viewWithTag:3];
        if (!current.completed) [logbutton setHidden:YES];
        else [logbutton setHidden:NO];
    }
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    [title setText:NSLocalizedString(current.name, nil)];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestStorage remove_test_atindex:indexPath.row];
        [self.tableView reloadData];
    }
}


- (void) unselectAll {
    [self.dns_injectionButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.tcp_connectButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.http_invalid_request_lineButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
}

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
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toLog"]){
        LogViewController *vc = (LogViewController * )segue.destinationViewController;
        UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:clickedCell];
        NetworkMeasurement *current = [NSKeyedUnarchiver unarchiveObjectWithData:[[TestStorage get_tests] objectAtIndex:indexPath.row]];
        [vc setTest:current];
    }
    else if ([[segue identifier] isEqualToString:@"toInfo"]){
        TestInfoViewController *vc = (TestInfoViewController * )segue.destinationViewController;
        UIButton *tappedButton = (UIButton*)sender;
        if (tappedButton.tag == 1){
            [vc setFileName:@"dns-injection"];
        }
        else if (tappedButton.tag == 2){
            [vc setFileName:@"tcp_connect"];
        }
        else if (tappedButton.tag == 3){
            [vc setFileName:@"http-invalid-request-line"];
        }
    }
}

@end
