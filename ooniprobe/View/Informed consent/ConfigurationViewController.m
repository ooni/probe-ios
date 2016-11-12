// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"configuration", nil);
    self.titleLabel.text = NSLocalizedString(@"configuration", nil);
    self.subtitleLabel.text = NSLocalizedString(@"configuration_text", nil);

    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = [UIColor colorWithRed:60.0/255.0 green:118.0/255.0 blue:61.0/255.0 alpha:1.0];
    style.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:240.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.view makeToast:NSLocalizedString(@"correct", nil) duration:3.0 position:CSToastPositionBottom style:style];
    
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIBarButtonItem *configure = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"configure", nil) style:UIBarButtonItemStylePlain target:self action:@selector(configure)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:configure, nil];

    settingsTitles = @[@"include_ip_ic", @"include_asn_ic", @"include_cc_ic", @"upload_results_ic"];
    settingsItems = @[@"include_ip", @"include_asn", @"include_cc", @"upload_results"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    NSString *current = [settingsItems objectAtIndex:indexPath.row];
    NSString *currentTitle = [settingsTitles objectAtIndex:indexPath.row];
    title.text = NSLocalizedString(currentTitle, nil);
    UISwitch *switchview  = (UISwitch*)[cell viewWithTag:2];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
    else switchview.on = NO;
    return cell;
}

-(IBAction)setSwitch:(UISwitch *)mySwitch{
    UITableViewCell *cell = (UITableViewCell *)mySwitch.superview.superview;
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *current = [settingsItems objectAtIndex:indexpath.row];
    if (mySwitch.on)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:current];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:current];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)configure{
    //save prefs
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"first_run"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToast" object:nil];
    }];
}

@end
