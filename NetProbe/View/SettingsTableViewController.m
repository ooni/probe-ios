//
//  SettingsTableViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 05/04/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

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
    settingsItems = @[@"include_ip", @"include_asn", @"gps_position", @"advanced_settings"];
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdvanced" forIndexPath:indexPath];
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
