// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     Settings:
     - Includere ip nel report ON/OFF
     - Includere asn ON/OFF
     - Posizione gps (non precisa) ON/OFF
     - Impostazioni avanzate
        - Indirizzo collector da usare - Stringa
        - Indirizzo bouncer - Stringa
     */
    self.title = NSLocalizedString(@"settings", nil);
    settingsItems = @[@"include_ip", @"include_asn", @"collector_address"];
    //removed @"gps_position", advanced_settings
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSwitch" forIndexPath:indexPath];
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
        else switchview.on = NO;
        switchview.onTintColor = [UIColor colorWithRed:162.0/255.0 green:155.0/255.0 blue:130.0/255.0 alpha:1.0];
        cell.accessoryView = switchview;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSub" forIndexPath:indexPath];
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:current];
    }
    /*
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdvanced" forIndexPath:indexPath];
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }*/
    return cell;
}

-(void)setSwitch:(id)sender{
    UISwitch* switchControl = sender;
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:clickedCell];
    NSString *current = [settingsItems objectAtIndex:indexPath.row];
    if (switchControl.on)
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
