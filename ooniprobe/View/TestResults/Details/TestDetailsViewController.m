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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFooter) name:@"uploadFinished" object:nil];
    self.scrollView.alwaysBounceVertical = NO;

    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(advancedScreens)];
    //assign button to navigationbar
    self.navigationItem.rightBarButtonItem = moreButton;
    [self reloadFooter];
    isInExplorer = ![self.measurement hasReportFile];
    if ([self.measurement hasReportFile]){
        [self.measurement getExplorerUrl:^(NSString *measurement_url){
            isInExplorer = TRUE;
            [TestUtility removeFile:[self.measurement getReportFile]];
            [TestUtility removeFile:[self.measurement getLogFile]];
        } onError:^(NSError *error) {
            /* NOTHING */
        }];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
            [self.navigationController.navigationBar setBarTintColor:[TestUtility getColorForTest:result.test_group_name]];
    }
}

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
    UIAlertAction* explorerButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"TestResults.Details.CopyExplorerURL", nil)
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self copyExplorerUrl];
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

-(IBAction)copyExplorerUrl{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSMutableString *link = [NSMutableString stringWithFormat:@"https://explorer.ooni.io/measurement/%@", self.measurement.report_id];
    if ([self.measurement.test_name isEqualToString:@"web_connectivity"])
        [link appendFormat:@"?input=%@", self.measurement.url_id.url];
    pasteboard.string = link;
    [MessageUtility showToast:NSLocalizedString(@"Toast.CopiedToClipboard", nil) inView:self.view];
}

#pragma mark - Navigation

-(void)reloadFooter{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.measurement.is_uploaded || self.measurement.is_failed){
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
