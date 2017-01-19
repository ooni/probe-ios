// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"set_up_sharing", nil);
    [self.nextButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"im_all_set", nil)] forState:UIControlStateNormal];

    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(previous)] ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = [UIColor colorWithRed:60.0/255.0 green:118.0/255.0 blue:61.0/255.0 alpha:1.0];
    style.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:240.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.view makeToast:NSLocalizedString(@"correct", nil) duration:3.0 position:CSToastPositionBottom style:style];
    
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    settingsItems = @[@"include_ip", @"include_asn", @"include_cc", @"upload_results"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    return [settingsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section == 0){
        cell.textLabel.text = NSLocalizedString(@"settings_text", nil);
        cell.imageView.image = nil;
        cell.accessoryView = nil;
    }
    else {
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
        else switchview.on = NO;
        cell.accessoryView = switchview;
    }
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

-(IBAction)configure:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"first_run"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToast" object:nil];
    }];
}

-(void)previous{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
