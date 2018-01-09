//
//  AutomaticTestsTableViewController.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/01/18.
//  Copyright © 2018 Simone Basso. All rights reserved.
//

#import "AutomaticTestsTableViewController.h"

@interface AutomaticTestsTableViewController ()

@end

@implementation AutomaticTestsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"automatic_tests", nil);
    tests = [SettingsUtility getTests];
    test_types = [SettingsUtility getTestTypes];
    automatic_tests = [SettingsUtility getAutomaticTestsEnabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *test_type = [test_types objectAtIndex:section];
    return NSLocalizedString(test_type, nil);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [test_types count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *test_type = [test_types objectAtIndex:section];
    return [[tests objectForKey:test_type] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *test_type = [test_types objectAtIndex:indexPath.section];
    NSString *current = [[tests objectForKey:test_type] objectAtIndex:indexPath.row];
    cell.textLabel.text = NSLocalizedString(current, nil);
    cell.imageView.image = [UIImage imageNamed:current];
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
    if ([automatic_tests containsObject:current]) switchview.on = YES;
        else switchview.on = NO;
    cell.accessoryView = switchview;
    return cell;
}

-(IBAction)setSwitch:(UISwitch *)mySwitch{
    UITableViewCell *cell = (UITableViewCell *)mySwitch.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *test_type = [test_types objectAtIndex:indexPath.section];
    NSString *current = [[tests objectForKey:test_type] objectAtIndex:indexPath.row];
    automatic_tests = [SettingsUtility addRemoveAutomaticTest:current];
}

@end

