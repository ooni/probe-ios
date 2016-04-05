//
//  AdvancedSettingsTableViewController.m
//  Libight_iOS
//
//  Created by Lorenzo Primiterra on 05/04/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "AdvancedSettingsTableViewController.h"

@interface AdvancedSettingsTableViewController ()

@end

@implementation AdvancedSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"advanced_settings", nil);
    settingsItems = @[@"collector_address", @"bouncer_address"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *current = [settingsItems objectAtIndex:indexPath.row];
    cell.textLabel.text = NSLocalizedString(current, nil);
    cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:current];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *current = [settingsItems objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(current, @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    alert.tag = indexPath.row;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    value = [alert textFieldAtIndex:0];
    value.autocorrectionType = UITextAutocorrectionTypeNo;
    [value setKeyboardType:UIKeyboardTypeURL];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && value.text.length > 0) {
        NSString *current = [settingsItems objectAtIndex:alertView.tag];
        [[NSUserDefaults standardUserDefaults] setObject:value.text forKey:current];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
}

@end
