#import "TestSummaryTableViewController.h"

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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:result.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.title = localizedDateTime;
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
        [cell setBackgroundColor:[UIColor whiteColor]];
        [title setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [status setImage:nil];
    }
    if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        [title setText:[LocalizationUtility getNameForTest:current.test_name]];
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", current.test_name]]];
        [icon setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
        if (!current.is_anomaly){
            [status setImage:[UIImage imageNamed:@"tick"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        }
        else {
            [status setImage:[UIImage imageNamed:@"cross"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        }
    }
    else if ([result.test_group_name isEqualToString:@"middle_boxes"]){
        [title setText:[LocalizationUtility getNameForTest:current.test_name]];
        if (!current.is_anomaly){
            [status setImage:[UIImage imageNamed:@"tick"]];
            [status setTintColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        }
        else
            [status setImage:[UIImage imageNamed:@"exclamation_point"]];
    }
    else if ([result.test_group_name isEqualToString:@"websites"]){
        [title setText:[NSString stringWithFormat:@"%@", current.url_id.url]];
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category_%@", current.url_id.category_code]]];
        [icon setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
        if (current.is_failed){
            if (!current.is_anomaly){
                [status setImage:[UIImage imageNamed:@"tick"]];
                [status setTintColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
            }
            else {
                [status setImage:[UIImage imageNamed:@"cross"]];
                [status setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
            }
        }
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        [title setText:[LocalizationUtility getNameForTest:current.test_name]];
        UIImageView *detail1Image = (UIImageView*)[cell viewWithTag:5];
        UILabel *detail1Label = (UILabel*)[cell viewWithTag:6];
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
            TestKeys *testKeys = [current testKeysObj];
            [stackView2 setHidden:NO];
            [detail1Image setImage:[UIImage imageNamed:@"upload_black"]];
            [detail1Image setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
            [detail2Image setImage:[UIImage imageNamed:@"download_black"]];
            [detail2Image setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
            [detail1Label setText:[NSString stringWithFormat:@"%@", [testKeys getUploadWithUnit]]];
            [detail2Label setText:[NSString stringWithFormat:@"%@", [testKeys getDownloadWithUnit]]];
        }
        else if ([current.test_name isEqualToString:@"dash"]){
            TestKeys *testKeys = [current testKeysObj];
            [stackView2 setHidden:YES];
            [detail1Image setImage:[UIImage imageNamed:@"video_quality"]];
            [detail1Label setText:[testKeys getVideoQuality:YES]];
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

-(void)showPopup{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Modal.ReRun.Title", nil)
                                 message:NSLocalizedString(@"Modal.ReRun.Paragraph", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    /*
    UIAlertAction* viewLogButton = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"TestResults.Details.ViewLog", nil)
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     segueType = @"log";
                                     [self performSegueWithIdentifier:@"log" sender:self];
                                 }];
    UIAlertAction* viewJsonButton = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"view_json", nil)
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     segueType = @"json";
                                     [self performSegueWithIdentifier:@"log" sender:self];
                                 }];
    UIAlertAction* viewDBButton = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"view_db_obj", nil)
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     segueType = @"db";
                                     [self performSegueWithIdentifier:@"log" sender:self];
                                 }];

     */
    UIAlertAction* reRunButton = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      [self performSegueWithIdentifier:@"toTestRun" sender:self];
                                  }];
    [alert addAction:reRunButton];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.Cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
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
    else if ([[segue identifier] isEqualToString:@"log"]){
        LogViewController *vc = (LogViewController *)segue.destinationViewController;
        [vc setType:segueType];
        [vc setMeasurement:segueObj];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController *)segue.destinationViewController;
        [vc setCurrentTest:[[NetworkTest alloc] initWithMeasurement:segueObj]];
    }
    else if ([[segue identifier] isEqualToString:@"toWebsitesTestDetails"] || [[segue identifier] isEqualToString:@"toMiddleBoxesTestDetails"] || [[segue identifier] isEqualToString:@"toInstantMessagingTestDetails"] || [[segue identifier] isEqualToString:@"toNdtTestDetails"] || [[segue identifier] isEqualToString:@"toDashTestDetails"]){
        TestDetailsViewController *vc = (TestDetailsViewController *)segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:segueObj];
    }
}

@end
