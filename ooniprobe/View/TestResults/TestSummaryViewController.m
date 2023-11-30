#import "TestSummaryViewController.h"
#import "ReachabilityManager.h"
#import "Tests.h"
#import "UploadFooterViewController.h"
#import "TestSummaryTableViewCell.h"
#import "RunningTest.h"

@interface TestSummaryViewController ()
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *expandedSections;
@end

@implementation TestSummaryViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConstraints) name:@"networkTestEndedUI" object:nil];
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMeasurements) name:@"uploadFinished" object:nil];
    if ([result.test_group_name isEqualToString:@"websites"])
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reRunWebsites)];

    [self reloadMeasurements];
    _expandedSections = [NSMutableDictionary new];
    defaultColor = [TestUtility getColorForTest:result.test_group_name];
    [NavigationBarUtility setNavigationBar:self.navigationController.navigationBar color:defaultColor];
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadConstraints];
    self.title = @"";
    self.title = [LocalizationUtility getNameForTest:self.result.test_group_name];
    [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                    color:[TestUtility getBackgroundColorForTest:result.test_group_name]];
}

- (void)reloadConstraints {
    CGFloat tableConstraint = 0;
    CGFloat uploadConstraint = 0;
    if ([RunningTest currentTest].isTestRunning) {
        uploadConstraint += 64;
    }
    if ([result isEveryMeasurementUploaded]) {
        tableConstraint = -45 + tableConstraint;
    } else {
        tableConstraint = 64 + tableConstraint;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableFooterConstraint.constant = tableConstraint;
        self.uploadBarFooterConstraint.constant = uploadConstraint;
        [self.tableView setNeedsUpdateConstraints];
        [self.tableView reloadData];
    });
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorNamed:@"color_blue5"]];
    }
}

- (void)resultUpdated:(NSNotification *)notification {
    if (result.Id != ((Result *) [notification object]).Id) {
        return;
    }
    result = [notification object];
    [self reloadMeasurements];
}

- (void)reloadMeasurements {
    self.measurements = result.measurementsSorted;
    // Create a mutable dictionary to hold the grouped measurements
    NSMutableDictionary *groupedMeasurements = [NSMutableDictionary new];

    // Iterate over each measurement
    for (Measurement *measurement in self.measurements) {
        // Get the test_name of the current measurement
        NSString *testName = measurement.test_name;

        // If this test_name is not already a key in the dictionary, add it
        // with the current measurement as the value in an array
        if (!groupedMeasurements[testName]) {
            groupedMeasurements[testName] = [NSMutableArray arrayWithObject:measurement];
        }
            // If this test_name is already a key in the dictionary, append the current
            // measurement to the existing array
        else {
            [groupedMeasurements[testName] addObject:measurement];
        }
    }

    // Replace the measurements array with the grouped measurements
    self.groupedMeasurements = [groupedMeasurements allValues];

    [self reloadConstraints];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupedMeasurements count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.expandedSections[@(section)]) {
        NSArray *group = self.groupedMeasurements[section];
        return 1 + group.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cell_id;
    if ([result.test_group_name isEqualToString:@"performance"]) {
        cell_id = @"Cell_per";
        //__deprecated
    } else if ([result.test_group_name isEqualToString:@"middle_boxes"] ||
            [result.test_group_name isEqualToString:@"experimental"]) {
        cell_id = @"Cell_mb";
    } else {
        cell_id = @"Cell";
    }
    TestSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TestSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }

    if (indexPath.row == 0) {
        Measurement *current = self.groupedMeasurements[indexPath.section][0];

        [cell setResult:result andMeasurement:current];
        if ([self.groupedMeasurements[indexPath.section] count] > 1) {
            UIImage *image = [UIImage imageNamed:@"backArrow"];

            // Define the rotation orientation
            UIImageOrientation orientation = self.expandedSections[@(indexPath.section)] ? UIImageOrientationRight : UIImageOrientationLeft; // 90 degrees rotation

            // Create a new image with the new orientation
            UIImage *rotatedImage = [UIImage imageWithCGImage:image.CGImage scale:3.0 orientation:orientation];

            // Display the rotated image
            cell.accessoryView = [[UIImageView alloc] initWithImage:[rotatedImage imageWithTintColor:[UIColor colorNamed:@"color_gray4"]]];
        } else {
            cell.accessoryView = nil;
        }
        cell.backgroundColor = [UIColor colorNamed:@"color_white"];
    } else {
        Measurement *current = self.groupedMeasurements[indexPath.section][indexPath.row - 1];
        [cell setResult:result andMeasurement:current];
        cell.accessoryView = nil;
        cell.backgroundColor = [UIColor colorNamed:@"color_gray0"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *group = self.groupedMeasurements[indexPath.section];

    // Check if it's a parent row
    if (indexPath.row == 0) {
        if (group.count == 1) {
            // This is a parent with no children. Add your click listener code here.
            segueObj = group[0];
            [self goToDetails];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            NSNumber *sectionKey = @(indexPath.section);

            // Check if the section is already expanded
            if (self.expandedSections[sectionKey]) {
                // If it is, remove the key to collapse it
                [self.expandedSections removeObjectForKey:sectionKey];
            } else {
                // If it's not, add the key to expand it
                self.expandedSections[sectionKey] = @YES;
            }

            // Reload the section to reflect the changes
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        // This is a child. Add your click listener code here.
        segueObj = group[indexPath.row - 1];
        [self goToDetails];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}

- (void)goToDetails {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void)reRunTests {
    WebsitesSuite *testSuite = [[WebsitesSuite alloc] init];
    NSMutableArray *urls = [NSMutableArray new];
    for (Measurement *m in self.measurements)
        [urls addObject:m.url_id.url];
    if ([testSuite getTestList] > 0 && [urls count] > 0)
        [(WebConnectivity *) [[testSuite getTestList] objectAtIndex:0] setInputs:urls];
    [[RunningTest currentTest] setAndRun:[NSMutableArray arrayWithObject:testSuite] inView:self];
    [self reloadMeasurements];
}

- (void)reRunWebsites {
    UIAlertAction *okButton = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Modal.ReRun.Websites.Run", nil)
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction *action) {
                        if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
                            [self reRunTests];
                    }];
    NSString *title = NSLocalizedFormatString(@"Modal.ReRun.Websites.Title",
            [NSString stringWithFormat:@"%ld", self.measurements.count]);
    [MessageUtility alertWithTitle:title
                           message:nil
                          okButton:okButton
                            inView:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"header"]) {
        HeaderSwipeViewController *vc = (HeaderSwipeViewController *) segue.destinationViewController;
        [vc setResult:result];
    } else if ([[segue identifier] isEqualToString:@"toWebsitesTestDetails"] ||
            [[segue identifier] isEqualToString:@"toMiddleBoxesTestDetails"] ||
            [[segue identifier] isEqualToString:@"toInstantMessagingTestDetails"] ||
            [[segue identifier] isEqualToString:@"toNdtTestDetails"] ||
            [[segue identifier] isEqualToString:@"toDashTestDetails"] ||
            [[segue identifier] isEqualToString:@"toFailedTestDetails"] ||
            [[segue identifier] isEqualToString:@"toCircumventionTestDetails"]) {
        TestDetailsViewController *vc = (TestDetailsViewController *) segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:segueObj];
    } else if ([[segue identifier] isEqualToString:@"footer_upload"]) {
        UploadFooterViewController *vc = (UploadFooterViewController *) segue.destinationViewController;
        [vc setResult:result];
        [vc setUpload_all:true];
    } else if ([[segue identifier] isEqualToString:@"toViewLog"]) {
        LogViewController *vc = (LogViewController *) segue.destinationViewController;
        [vc setType:@"json"];
        [vc setMeasurement:segueObj];
    }
}

@end
