#import "DashboardTableViewController.h"
#import "GRMustache.h"

@interface DashboardTableViewController ()

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    items = [TestUtility getTestTypes];    
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    UIImageView *navbarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ooni_logo"]];
    navbarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [navbarImageView.widthAnchor constraintEqualToConstant:135].active = YES;
    [navbarImageView.heightAnchor constraintEqualToConstant:24].active = YES;
    self.navigationController.navigationBar.topItem.titleView = navbarImageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return tableView.frame.size.width / 5 * 3;
    }
    return (tableView.frame.size.width / 5 * 3 )/2;
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
    UILabel *bottomLabel = (UILabel*)[cell viewWithTag:8];

    [runButton setTitleColor:[TestUtility getColorForTest:testName] forState:UIControlStateNormal];
    [runButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Dashboard.Card.Run", nil)] forState:UIControlStateNormal];
    [configureButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Dashboard.Card.Configure", nil)] forState:UIControlStateNormal];

    UIImageView *testLogo = (UIImageView*)[cell viewWithTag:7];
    [titleLabel setText:[LocalizationUtility getNameForTest:testName]];
    [descLabel setText:[LocalizationUtility getDescriptionForTest:testName]];
    NSString *time = [GRMustacheTemplate renderObject:@{ @"seconds": [NSString stringWithFormat:@"%d", [TestUtility getTotalTimeForTest:testName]] } fromString:NSLocalizedString(@"Dashboard.Card.Seconds", nil) error:NULL];
    [estimateTime setText:time];
    [bottomLabel setText:NSLocalizedString(@"Dashboard.Card.Subtitle", nil)];

    [testLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testName]]];
    [testLogo setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [backgroundView setBackgroundColor:[TestUtility getColorForTest:testName]];
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
        [MessageUtility alertWithTitle:@"Modal.Error" message:@"Modal.Error.NoInternet" inView:self];
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
        NSString *testSuiteName = [items objectAtIndex:indexPath.row];
        [vc setTestSuiteName:testSuiteName];
    }
    else if ([[segue identifier] isEqualToString:@"toTestOverview"]){
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        TestOverviewViewController *vc = (TestOverviewViewController * )segue.destinationViewController;
        NSString *testName = [items objectAtIndex:indexPath.row];
        [vc setTestName:testName];
    }    
}


@end
