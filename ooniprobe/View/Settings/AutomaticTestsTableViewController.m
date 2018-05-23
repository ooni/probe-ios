#import "AutomaticTestsTableViewController.h"

@interface AutomaticTestsTableViewController ()

@end

@implementation AutomaticTestsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings.AutomatedTesting.EnabledTests", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    tests = [TestUtility getTests];
    test_types = [TestUtility getTestTypes];
    automatic_tests = [SettingsUtility getAutomaticTestsEnabled];
}

#pragma mark - Table view data source


  - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *test_type = [test_types objectAtIndex:section];
    return [LocalizationUtility getNameForTest:test_type];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray6 alpha:1.0f]];
    [header.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
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
    cell.textLabel.text = [LocalizationUtility getNameForTest:current];
    cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    
    if ([test_type isEqualToString:@"instant_messaging"])
        cell.imageView.image = [UIImage imageNamed:current];
    else
        cell.imageView.image = [UIImage imageNamed:test_type];
    
    [cell.imageView setTintColor:[UIColor colorWithRGBHexString:color_base alpha:1.0f]];
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

