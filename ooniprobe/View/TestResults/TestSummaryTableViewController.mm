#import "TestSummaryTableViewController.h"
#define MEASUREMENT_OK 0
#define MEASUREMENT_FAILURE 1
#define MEASUREMENT_BLOCKED 2

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

    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:result.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.title = localizedDateTime;

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMeasurements) name:@"networkTestEnded" object:nil];
    [self reloadMeasurements];
    defaultColor = [SettingsUtility getColorForTest:result.name];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[SettingsUtility getColorForTest:result.name]];
    //self.tabBarController.navigationItem.title = NSLocalizedString(@"test_results", nil);
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
    if ([result.name isEqualToString:@"performance"])
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_per" forIndexPath:indexPath];
    else if ([result.name isEqualToString:@"middle_boxes"])
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_mb" forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UIImageView *status = (UIImageView*)[cell viewWithTag:3];
    if (current.blocking == MEASUREMENT_OK || current.blocking == MEASUREMENT_BLOCKED){
        [cell setBackgroundColor:[UIColor whiteColor]];
        [title setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if (current.blocking == MEASUREMENT_FAILURE){
        [cell setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
        [title setTextColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        [status setImage:[UIImage imageNamed:@"reload"]];
    }
    Summary *summary = [result getSummary];

    if ([result.name isEqualToString:@"instant_messaging"]){
        [title setText:NSLocalizedString(current.name, nil)];
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_black", current.name]]];
        if (current.blocking == MEASUREMENT_OK)
            [status setImage:[UIImage imageNamed:@"tick_green"]];
        else if (current.blocking == MEASUREMENT_BLOCKED)
            [status setImage:[UIImage imageNamed:@"tick_red"]];
    }
    else if ([result.name isEqualToString:@"middle_boxes"]){
        [title setText:NSLocalizedString(current.name, nil)];
        if (current.blocking == MEASUREMENT_OK)
            [status setImage:[UIImage imageNamed:@"tick_green"]];
        else if (current.blocking == MEASUREMENT_BLOCKED)
            [status setImage:[UIImage imageNamed:@"exclamation_point_orange"]];
    }
    else if ([result.name isEqualToString:@"websites"]){
        [title setText:NSLocalizedString(current.input, nil)];
        UIImageView *icon = (UIImageView*)[cell viewWithTag:2];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category_%@", current.category]]];
        [icon setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];

        if (current.blocking == MEASUREMENT_OK)
            [status setImage:[UIImage imageNamed:@"tick_green"]];
        else if (current.blocking == MEASUREMENT_BLOCKED)
            [status setImage:[UIImage imageNamed:@"tick_red"]];
    }
    else if ([result.name isEqualToString:@"performance"]){
        [title setText:NSLocalizedString(current.name, nil)];
        UIImageView *detail1Image = (UIImageView*)[cell viewWithTag:5];
        UILabel *detail1Label = (UILabel*)[cell viewWithTag:6];
        UIStackView *stackView2 = (UIStackView*)[cell viewWithTag:4];
        UIImageView *detail2Image = (UIImageView*)[cell viewWithTag:7];
        UILabel *detail2Label = (UILabel*)[cell viewWithTag:8];
        [detail1Image setHidden:NO];
        [detail2Image setHidden:NO];
        [detail1Label setHidden:NO];
        [detail2Label setHidden:NO];

        if (current.blocking == MEASUREMENT_OK)
            [status setImage:nil];
        else if (current.blocking == MEASUREMENT_BLOCKED)
            [status setImage:nil];
        else if (current.blocking == MEASUREMENT_FAILURE){
            [detail1Image setHidden:YES];
            [detail2Image setHidden:YES];
            [detail1Label setHidden:YES];
            [detail2Label setHidden:YES];
        }

        if ([current.name isEqualToString:@"ndt"]){
            [stackView2 setHidden:NO];
            [detail1Image setImage:[UIImage imageNamed:@"upload_black"]];
            [detail2Image setImage:[UIImage imageNamed:@"download_black"]];
            [detail1Label setText:[NSString stringWithFormat:@"%@", [summary getUploadWithUnit]]];
            [detail2Label setText:[NSString stringWithFormat:@"%@", [summary getDownloadWithUnit]]];
        }
        else if ([current.name isEqualToString:@"dash"]){
            [stackView2 setHidden:YES];
            [detail1Image setImage:[UIImage imageNamed:@"video_quality_black"]];
            [detail1Label setText:[summary getVideoQuality:NO]];
        }
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    segueObj = [self.measurements objectAtIndex:indexPath.row];
    [self showPopup];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)showPopup{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* viewLogButton = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"view_log", nil)
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

    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"cancel", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
    [alert addAction:viewLogButton];
    [alert addAction:viewJsonButton];
    [alert addAction:viewDBButton];
    if (segueObj.blocking == MEASUREMENT_FAILURE){
        UIAlertAction* reRunButton = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"re_run_test", nil)
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self performSegueWithIdentifier:@"toTestRun" sender:self];
                                       }];
        [alert addAction:reRunButton];
    }
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"header"]){
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HeaderSwipeViewController *vc = (HeaderSwipeViewController * )segue.destinationViewController;
        //NSString *current = [categories objectAtIndex:indexPath.row];
        [vc setResult:result];
    }
    else if ([[segue identifier] isEqualToString:@"log"]){
        LogViewController *vc = (LogViewController * )segue.destinationViewController;
        [vc setType:segueType];
        [vc setMeasurement:segueObj];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        /*if ([result.name isEqualToString:@"websites"]) {
            Url *currentUrl = [[Url alloc] initWithUrl:segueObj.input category:segueObj.category];
            [vc setCurrentTest:[[WCNetworkTest alloc] initWithUrls:@[currentUrl]]];
            [segueObj remove];
        }*/
        [vc setCurrentTest:[[NetworkTest alloc] initWithMeasurement:segueObj]];
    }
}

@end
