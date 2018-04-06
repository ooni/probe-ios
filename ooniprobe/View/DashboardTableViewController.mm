#import "DashboardTableViewController.h"

@interface DashboardTableViewController ()

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    items = [SettingsUtility getTestTypes];
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *navbarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ooniprobe_logo"]];
    navbarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [navbarImageView.widthAnchor constraintEqualToConstant:135].active = YES;
    [navbarImageView.heightAnchor constraintEqualToConstant:24].active = YES;
    self.navigationController.navigationBar.topItem.titleView = navbarImageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.width / 5 * 3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *testName = [items objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
    UIView *backgroundView = (UIView*)[cell viewWithTag:1];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *descLabel = (UILabel*)[cell viewWithTag:3];
    UILabel *estimateTime = (UILabel*)[cell viewWithTag:4];
    RunButton *runButton = (RunButton*)[cell viewWithTag:5];
    ConfigureButton *configureButton = (ConfigureButton*)[cell viewWithTag:6];

    [runButton setTitleColor:[SettingsUtility getColorForTest:testName] forState:UIControlStateNormal];
    [runButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"Dashboard.Card.Run", nil)] forState:UIControlStateNormal];
    [configureButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"Dashboard.Card.Configure", nil)] forState:UIControlStateNormal];

    //ConfigureButton *configureButton = (ConfigureButton*)[cell viewWithTag:6];
    UIImageView *testLogo = (UIImageView*)[cell viewWithTag:7];

    [titleLabel setText:NSLocalizedString(testName, nil)];
    NSString *test_desc = [NSString stringWithFormat:@"%@_desc", testName];
    [descLabel setText:NSLocalizedString(test_desc, nil)];
    //TODO Estimated Time test
    [estimateTime setText:@"2min"];
    [testLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white", testName]]];
    [backgroundView setBackgroundColor:[SettingsUtility getColorForTest:testName]];
    backgroundView.layer.cornerRadius = 15;
    backgroundView.layer.masksToBounds = YES;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)run:(id)sender{
    if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
        [self performSegueWithIdentifier:@"toTestRun" sender:sender];
    else
        [MessageUtility alertWithTitle:@"warning" message:@"no_internet" inView:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTestSettings"]){
        UITableViewCell* cell = (UITableViewCell*)[[[sender superview] superview] superview];
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        SettingsTableViewController *vc = (SettingsTableViewController * )segue.destinationViewController;
        NSString *testName = [items objectAtIndex:indexPath.row];
        [vc setTestName:testName];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        UITableViewCell* cell = (UITableViewCell*)[[[sender superview] superview] superview];
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        NSString *testName = [items objectAtIndex:indexPath.row];
        if ([testName isEqualToString:@"websites"])
            [vc setCurrentTest:[[WCNetworkTest alloc] init]];
        else if ([testName isEqualToString:@"performance"])
            [vc setCurrentTest:[[SPNetworkTest alloc] init]];
        else if ([testName isEqualToString:@"middle_boxes"])
            [vc setCurrentTest:[[MBNetworkTest alloc] init]];
        else if ([testName isEqualToString:@"instant_messaging"])
            [vc setCurrentTest:[[IMNetworkTest alloc] init]];
    }
    else if ([[segue identifier] isEqualToString:@"toTestOverview"]){
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        TestOverviewViewController *vc = (TestOverviewViewController * )segue.destinationViewController;
        NSString *testName = [items objectAtIndex:indexPath.row];
        [vc setTestName:testName];
    }    
}


@end
