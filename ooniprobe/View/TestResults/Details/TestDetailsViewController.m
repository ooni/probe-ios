#import "TestDetailsViewController.h"
#import "TestDetailsFooterViewController.h"
#import "Tests.h"
#import "TestRunningViewController.h"
#import "UploadFooterViewController.h"

@interface TestDetailsViewController ()

@end

@implementation TestDetailsViewController
@synthesize result, measurement;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.title = [LocalizationUtility getNameForTest:measurement.test_name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMeasurement) name:@"uploadFinished" object:nil];
    self.scrollView.alwaysBounceVertical = NO;

    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(advancedScreens)];
    //assign button to navigationbar
    self.navigationItem.rightBarButtonItem = moreButton;
    [self reloadFooter];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
            [self.navigationController.navigationBar setBarTintColor:[TestUtility getColorForTest:result.test_group_name]];
    }
}

//TODO-UPLOAD connect to constraints (after merge branch)
/*-(void)reloadMeasurement{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.measurement.is_uploaded){
            self.footerConstraint.constant = -45;
            [self.view setNeedsUpdateConstraints];
        }
        else {
            self.footerConstraint.constant = 0;
            [self.view setNeedsUpdateConstraints];
        }
    });
}
*/

- (void)advancedScreens{
    UIAlertAction* rawDataButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"TestResults.Details.RawData", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self rawData];
                                   }];
    UIAlertAction* logButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"TestResults.Details.ViewLog", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self viewLogs];
                                   }];
    NSArray *buttons = [NSArray arrayWithObjects:rawDataButton, logButton, nil];
    [MessageUtility alertWithTitle:nil message:nil buttons:buttons inView:self];

}

- (IBAction)viewLogs{
    segueType = @"log";
    [self performSegueWithIdentifier:@"toViewLog" sender:self];
}

- (IBAction)rawData{
    segueType = @"json";
    [self performSegueWithIdentifier:@"toViewLog" sender:self];
}

#pragma mark - Navigation

//TODO-UPLOAD maybe remove (after merge branch)
-(bool)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"footer_upload"]){
        if (![SettingsUtility getSettingWithName:@"upload_results_manually"] || self.measurement.is_uploaded)
        return NO;
    }
    return YES;
}

-(void)reloadFooter{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.measurement.is_uploaded){
            self.scrollViewFooterConstraint.constant = -45;
            [self.scrollView setNeedsUpdateConstraints];
        }
        else {
            self.scrollViewFooterConstraint.constant = 0;
            [self.scrollView setNeedsUpdateConstraints];
        }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toViewLog"]){
        LogViewController *vc = (LogViewController *)segue.destinationViewController;
        [vc setType:segueType];
        [vc setMeasurement:measurement];
    }
    else if ([[segue identifier] isEqualToString:@"footer"]){
        TestDetailsFooterViewController *vc = (TestDetailsFooterViewController * )segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:measurement];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController *)segue.destinationViewController;
        NSString *testSuiteName = self.measurement.result_id.test_group_name;
        AbstractSuite *testSuite = [[AbstractSuite alloc] initSuite:testSuiteName];
        AbstractTest *test = [[AbstractTest alloc] initTest:self.measurement.test_name];
        [testSuite setTestList:[NSMutableArray arrayWithObject:test]];
        [testSuite setResult:self.measurement.result_id];
        if ([testSuiteName isEqualToString:@"websites"])
            [(WebConnectivity*)test setInputs:[NSArray arrayWithObject:self.measurement.url_id.url]];
        [self.measurement setReRun];
        [vc setTestSuite:testSuite];
    }
    else if ([[segue identifier] isEqualToString:@"footer_upload"]){
        UploadFooterViewController *vc = (UploadFooterViewController * )segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:measurement];
        [vc setUpload_all:false];
    }
}


@end
