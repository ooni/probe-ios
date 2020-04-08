#import "DashboardTableViewController.h"
#import "DashboardTableViewCell.h"
#import "Suite.h"

@interface DashboardTableViewController ()

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTests) name:@"settingsChanged" object:nil];
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(runAll)];
    [self loadTests];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *navbarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ooni_logo"]];
    navbarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [navbarImageView.widthAnchor constraintEqualToConstant:135].active = YES;
    [navbarImageView.heightAnchor constraintEqualToConstant:24].active = YES;
    self.navigationController.navigationBar.topItem.titleView = navbarImageView;
}

-(void)loadTests{
    items = [[NSMutableArray alloc] init];
    [items addObject:[[WebsitesSuite alloc] init]];
    [items addObject:[[InstantMessagingSuite alloc] init]];
    [items addObject:[[MiddleBoxesSuite alloc] init]];
    [items addObject:[[PerformanceSuite alloc] init]];
    [self.tableView reloadData];
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
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    AbstractSuite *test = [items objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell setTestSuite:test];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)run:(id)sender{
    if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
        [self performSegueWithIdentifier:@"toTestRun" sender:sender];
    else
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil)
                               message:NSLocalizedString(@"Modal.Error.NoInternet", nil) inView:self];
}

-(void)runAll{
    [self performSegueWithIdentifier:@"toTestRunAll" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTestRun"]){
        UITableViewCell* cell = (UITableViewCell*)[[[sender superview] superview] superview];
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        AbstractSuite *testSuite = [items objectAtIndex:indexPath.row];
        [vc setTestSuite:testSuite];
    }
    if ([[segue identifier] isEqualToString:@"toTestRunAll"]){
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        [vc setTestSuites:items];
    }
    else if ([[segue identifier] isEqualToString:@"toTestOverview"]){
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        TestOverviewViewController *vc = (TestOverviewViewController * )segue.destinationViewController;
        AbstractSuite *testSuite = [items objectAtIndex:indexPath.row];
        [vc setTestSuite:testSuite];
    }    
}


@end
