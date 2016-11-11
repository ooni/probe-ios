// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"settings", nil);
    settingsItems = @[@"include_ip", @"include_asn", @"include_cc", @"upload_results", @"collector_address"];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    UITableViewCell *cell;
    if (indexPath.row < [settingsItems count] -1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        UIImageView *image = (UIImageView*)[cell viewWithTag:2];
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        title.text = NSLocalizedString(current, nil);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue])
            image.image = [UIImage imageNamed:@"checked_checkbox"];
        else
            image.image = [UIImage imageNamed:@"unchecked_checkbox"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSub" forIndexPath:indexPath];
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:current];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue]){
            cell.userInteractionEnabled = YES;
            cell.hidden = NO;
        }
        else {
            cell.userInteractionEnabled = NO;
            cell.hidden = YES;
        }
    }
    return cell;
}

-(void) switchRow:(long)idx{
    NSString *current = [settingsItems objectAtIndex:idx];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:current];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:current];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [settingsItems count] -1){
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(current, @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
        alert.tag = indexPath.row;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        value = [alert textFieldAtIndex:0];
        value.autocorrectionType = UITextAutocorrectionTypeNo;
        [value setKeyboardType:UIKeyboardTypeURL];
        [alert show];
    }
    else {
        [self switchRow:indexPath.row];
        [self.tableView reloadData];
    }
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
