#import "TestSummaryTableViewController.h"
#import "ReachabilityManager.h"
#import "Tests.h"

@interface TestSummaryTableViewController ()

@end

@implementation TestSummaryTableViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];

    [self reloadMeasurements];
    defaultColor = [TestUtility getColorForTest:result.test_group_name];
    self.title = [LocalizationUtility getNameForTest:self.result.test_group_name];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[TestUtility getColorForTest:result.test_group_name]];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    }
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurements];
}

-(void)reloadMeasurements{
    self.measurements = result.measurements;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.measurements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Measurement *current = [self.measurements objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    if ([result.test_group_name isEqualToString:@"performance"])
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_per" forIndexPath:indexPath];
    else if ([result.test_group_name isEqualToString:@"middle_boxes"])
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_mb" forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UIImageView *status = (UIImageView*)[cell viewWithTag:3];
    if (current.is_failed){
        [cell setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
        [title setTextColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        [status setImage:[UIImage imageNamed:@"reload"]];
    }
    else {
        [cell setBackgroundColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
        [title setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [status setImage:nil];
    }
    if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        [title setText:[LocalizationUtility getNameForTest:current.test_name]];
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", current.test_name]]];
        if (current.is_failed)
            [icon setTintColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        else
            [icon setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
        if (!current.is_anomaly){
            [status setImage:[UIImage imageNamed:@"tick"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        }
        else {
            [status setImage:[UIImage imageNamed:@"exclamation_point"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        }
    }
    else if ([result.test_group_name isEqualToString:@"middle_boxes"]){
        [title setText:[LocalizationUtility getNameForTest:current.test_name]];
        if (!current.is_anomaly){
            [status setImage:[UIImage imageNamed:@"tick"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        }
        else {
            [status setImage:[UIImage imageNamed:@"exclamation_point"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        }
    }
    else if ([result.test_group_name isEqualToString:@"websites"]){
        [title setText:[NSString stringWithFormat:@"%@", current.url_id.url]];
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category_%@", current.url_id.category_code]]];
        if (current.is_failed)
            [icon setTintColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        else
            [icon setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
        if (!current.is_failed){
            if (!current.is_anomaly){
                [status setImage:[UIImage imageNamed:@"tick"]];
                [status setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
            }
            else {
                [status setImage:[UIImage imageNamed:@"exclamation_point"]];
                [status setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
            }
        }
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        [title setText:[LocalizationUtility getNameForTest:current.test_name]];
        UIImageView *detail1Image = (UIImageView*)[cell viewWithTag:5];
        UILabel *detail1Label = (UILabel*)[cell viewWithTag:6];
        UIStackView *stackView1 = (UIStackView*)[cell viewWithTag:9];
        UIStackView *stackView2 = (UIStackView*)[cell viewWithTag:4];
        UIImageView *detail2Image = (UIImageView*)[cell viewWithTag:7];
        UILabel *detail2Label = (UILabel*)[cell viewWithTag:8];
        [detail1Image setHidden:NO];
        [detail2Image setHidden:NO];
        [detail1Label setHidden:NO];
        [detail2Label setHidden:NO];

        if (current.is_failed){
            [detail1Image setHidden:YES];
            [detail2Image setHidden:YES];
            [detail1Label setHidden:YES];
            [detail2Label setHidden:YES];
        }
        else {
            if (!current.is_anomaly)
                [status setImage:nil];
            else
                [status setImage:nil];
        }
        if ([current.test_name isEqualToString:@"ndt"]){
            TestKeys *testKeysNdt = [current testKeysObj];
            [stackView2 setHidden:NO];
            [detail1Image setImage:[UIImage imageNamed:@"download"]];
            [detail1Image setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [detail2Image setImage:[UIImage imageNamed:@"upload"]];
            [detail2Image setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [detail1Label setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [detail2Label setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self setText:[testKeysNdt getDownloadWithUnit] forLabel:detail1Label inStackView:stackView1];
            [self setText:[testKeysNdt getUploadWithUnit] forLabel:detail2Label inStackView:stackView2];
        }
        else if ([current.test_name isEqualToString:@"dash"]){
            TestKeys *testKeysDash = [current testKeysObj];
            [stackView2 setHidden:YES];
            [detail1Image setImage:[UIImage imageNamed:@"video_quality"]];
            [detail1Image setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [detail1Label setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self setText:[testKeysDash getVideoQuality:YES] forLabel:detail1Label inStackView:stackView1];
        }
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    segueObj = [self.measurements objectAtIndex:indexPath.row];
    if (segueObj.is_failed){
        [self showPopup];
    }
    else
        [self goToDetails];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setText:(NSString*)text forLabel:(UILabel*)label inStackView:(UIStackView*)stackView{
    if (text == nil)
        text = NSLocalizedString(@"TestResults.NotAvailable", nil);
    [label setText:text];
    if ([text isEqualToString:NSLocalizedString(@"TestResults.NotAvailable", nil)]){
        [stackView setAlpha:0.3f];
    }
}

-(void)showPopup{
    UIAlertAction* reRunButton = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
                                          [self performSegueWithIdentifier:@"toTestRun" sender:self];
                                      else
                                          [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil) message:NSLocalizedString(@"Modal.Error.NoInternet", nil) inView:self];
                                  }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.Cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.ReRun.Title", nil)
                           message:NSLocalizedString(@"Modal.ReRun.Paragraph", nil)
                          okButton:reRunButton
                      cancelButton:cancelButton
                            inView:self];
}

-(void)goToDetails{
    if ([segueObj.test_name isEqualToString:@"ndt"])
        [self performSegueWithIdentifier:@"toNdtTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"dash"])
        [self performSegueWithIdentifier:@"toDashTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"whatsapp"] ||
             [segueObj.test_name isEqualToString:@"telegram"] ||
             [segueObj.test_name isEqualToString:@"facebook_messenger"])
        [self performSegueWithIdentifier:@"toInstantMessagingTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"http_invalid_request_line"] ||
             [segueObj.test_name isEqualToString:@"http_header_field_manipulation"])
        [self performSegueWithIdentifier:@"toMiddleBoxesTestDetails" sender:self];
    else if ([segueObj.test_name isEqualToString:@"web_connectivity"])
        [self performSegueWithIdentifier:@"toWebsitesTestDetails" sender:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"header"]){
        HeaderSwipeViewController *vc = (HeaderSwipeViewController *)segue.destinationViewController;
        [vc setResult:result];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController *)segue.destinationViewController;
        NSString *testSuiteName = segueObj.result_id.test_group_name;
        AbstractSuite *testSuite = [[AbstractSuite alloc] initSuite:testSuiteName];
        AbstractTest *test = [[AbstractTest alloc] initTest:segueObj.test_name];
        [testSuite setTestList:[NSMutableArray arrayWithObject:test]];
        [testSuite setResult:segueObj.result_id];
        if ([testSuiteName isEqualToString:@"websites"])
            [(WebConnectivity*)test setInputs:[NSArray arrayWithObject:segueObj.url_id.url]];
        [segueObj setReRun];
        [vc setTestSuite:testSuite];
    }
    else if ([[segue identifier] isEqualToString:@"toWebsitesTestDetails"] || [[segue identifier] isEqualToString:@"toMiddleBoxesTestDetails"] || [[segue identifier] isEqualToString:@"toInstantMessagingTestDetails"] || [[segue identifier] isEqualToString:@"toNdtTestDetails"] || [[segue identifier] isEqualToString:@"toDashTestDetails"]){
        TestDetailsViewController *vc = (TestDetailsViewController *)segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:segueObj];
    }
}

@end
