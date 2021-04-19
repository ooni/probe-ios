#import "TestSummaryViewController.h"
#import "ReachabilityManager.h"
#import "Tests.h"
#import "UploadFooterViewController.h"
#import "TestSummaryTableViewCell.h"

@interface TestSummaryViewController ()

@end

@implementation TestSummaryViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMeasurements) name:@"uploadFinished" object:nil];
    if ([result.test_group_name isEqualToString:@"websites"])
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reRunWebsites)];
    
    [self reloadMeasurements];
    defaultColor = [TestUtility getColorForTest:result.test_group_name];
    [NavigationBarUtility setNavigationBar:self.navigationController.navigationBar color:defaultColor];
    self.navigationController.navigationBar.topItem.title = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"";
    self.title = [LocalizationUtility getNameForTest:self.result.test_group_name];
    [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                    color:[TestUtility getBackgroundColorForTest:result.test_group_name]];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorNamed:@"color_blue5"]];
    }
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurements];
}

-(void)reloadMeasurements{
    self.measurements = result.measurementsSorted;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([result isEveryMeasurementUploaded]){
            self.tableFooterConstraint.constant = -45;
            [self.tableView setNeedsUpdateConstraints];
        }
        else {
            self.tableFooterConstraint.constant = 0;
            [self.tableView setNeedsUpdateConstraints];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.measurements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Measurement *current = [self.measurements objectAtIndex:indexPath.row];
    NSString *cell_id;
    if ([result.test_group_name isEqualToString:@"performance"])
        cell_id = @"Cell_per";
    //__deprecated
    else if ([result.test_group_name isEqualToString:@"middle_boxes"] ||
             [result.test_group_name isEqualToString:@"experimental"])
         cell_id = @"Cell_mb";
    else
        cell_id = @"Cell";
    TestSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TestSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    [cell setResult:result andMeasurement:current];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    segueObj = [self.measurements objectAtIndex:indexPath.row];
    [self goToDetails];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)goToDetails{
    if ([result.test_group_name isEqualToString:@"experimental"])
        [self performSegueWithIdentifier:@"toViewLog" sender:self];
    else if (segueObj.is_failed)
        [self performSegueWithIdentifier:@"toFailedTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"ndt"])
        [self performSegueWithIdentifier:@"toNdtTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"dash"])
        [self performSegueWithIdentifier:@"toDashTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"whatsapp"] ||
             [segueObj.test_name isEqualToString:@"telegram"] ||
             [segueObj.test_name isEqualToString:@"facebook_messenger"] ||
             [segueObj.test_name isEqualToString:@"signal"])
        [self performSegueWithIdentifier:@"toInstantMessagingTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"http_invalid_request_line"] ||
             [segueObj.test_name isEqualToString:@"http_header_field_manipulation"])
        [self performSegueWithIdentifier:@"toMiddleBoxesTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"web_connectivity"])
        [self performSegueWithIdentifier:@"toWebsitesTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"tor"] ||
             [segueObj.test_name isEqualToString:@"psiphon"] ||
             [segueObj.test_name isEqualToString:@"riseupvpn"])
        [self performSegueWithIdentifier:@"toCircumventionTestDetails" sender:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

-(void)reRunWebsites{
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.ReRun.Websites.Run", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
                                       [self performSegueWithIdentifier:@"toTestRun" sender:self];
                               }];
    NSString *title = NSLocalizedFormatString(@"Modal.ReRun.Websites.Title",
                                              [NSString stringWithFormat:@"%ld", self.measurements.count]);
    [MessageUtility alertWithTitle:title
                           message:nil
                          okButton:okButton
                            inView:self];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"header"]){
        HeaderSwipeViewController *vc = (HeaderSwipeViewController *)segue.destinationViewController;
        [vc setResult:result];
    }
    else if ([[segue identifier] isEqualToString:@"toWebsitesTestDetails"] ||
             [[segue identifier] isEqualToString:@"toMiddleBoxesTestDetails"] ||
             [[segue identifier] isEqualToString:@"toInstantMessagingTestDetails"] ||
             [[segue identifier] isEqualToString:@"toNdtTestDetails"] ||
             [[segue identifier] isEqualToString:@"toDashTestDetails"] ||
             [[segue identifier] isEqualToString:@"toFailedTestDetails"] ||
             [[segue identifier] isEqualToString:@"toCircumventionTestDetails"]){
        TestDetailsViewController *vc = (TestDetailsViewController *)segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:segueObj];
    }
    else if ([[segue identifier] isEqualToString:@"footer_upload"]){
        UploadFooterViewController *vc = (UploadFooterViewController * )segue.destinationViewController;
        [vc setResult:result];
        [vc setUpload_all:true];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController *)segue.destinationViewController;
        WebsitesSuite *testSuite = [[WebsitesSuite alloc] init];
        NSMutableArray *urls = [NSMutableArray new];
        for (Measurement *m in self.measurements)
            [urls addObject:m.url_id.url];
        if ([testSuite getTestList] > 0 && [urls count] > 0)
            [(WebConnectivity*)[[testSuite getTestList] objectAtIndex:0] setInputs:urls];
        [vc setTestSuites:[NSMutableArray arrayWithObject:testSuite]];
    }
    else if ([[segue identifier] isEqualToString:@"toViewLog"]){
        LogViewController *vc = (LogViewController *)segue.destinationViewController;
        [vc setType:@"json"];
        [vc setMeasurement:segueObj];
    }
}

@end
