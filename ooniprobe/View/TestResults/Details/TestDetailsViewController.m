#import "TestDetailsViewController.h"
#import "TestDetailsFooterViewController.h"
#import "Tests.h"
#import "TestRunningViewController.h"
#import "UploadFooterViewController.h"
#import "ReachabilityManager.h"
#import "ThirdPartyServices.h"
#import "RunningTest.h"

@interface TestDetailsViewController ()

@end

@implementation TestDetailsViewController
@synthesize result, measurement;

- (void)viewDidLoad {
    [super viewDidLoad];
    [NavigationBarUtility setNavigationBar:self.navigationController.navigationBar color:[TestUtility getBackgroundColorForTest:result.test_group_name]];
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = [LocalizationUtility getNameForTest:measurement.test_name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFooter) name:@"uploadFinished" object:nil];
    self.scrollView.alwaysBounceVertical = NO;

    [self reloadFooter];
    isInExplorer = ![self.measurement hasReportFile];
    if ([self.measurement hasReportFile]){
        isInExplorer = YES;
        if (self.measurement.report_id != NULL)
            [TestUtility deleteMeasurementWithReportId:self.measurement.report_id];
    }
    [self addShareButton];
}

-(void)addShareButton{
    UIBarButtonItem *explorerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareExplorerUrl)];
    UIBarButtonItem *reRunButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reRunWebsites)];
    if (isInExplorer && ([self.measurement is_anomaly] && [self.measurement.test_name isEqualToString:@"web_connectivity"])){
        self.navigationItem.rightBarButtonItems = @[reRunButton,explorerButton];
    }else if (isInExplorer && ![self.measurement is_anomaly]) {
        self.navigationItem.rightBarButtonItem = explorerButton;
    } else if ([self.measurement is_anomaly] && [self.measurement.test_name isEqualToString:@"web_connectivity"]) {
        self.navigationItem.rightBarButtonItem = reRunButton;
    }
}

-(void)reRunWebsites {
    UIAlertAction* okButton = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Modal.ReRun.Websites.Run", nil)
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {
                        if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
                            [self reRunTests];
                    }];
    NSString *title = NSLocalizedFormatString(@"Modal.ReRun.Title",nil);
    [MessageUtility alertWithTitle:title
                           message:nil
                          okButton:okButton
                            inView:self];
}

-(void)reRunTests{
    WebsitesSuite *testSuite = [[WebsitesSuite alloc] init];
    NSMutableArray *urls = [NSMutableArray new];
    [urls addObject:measurement.url_id.url];
    if ([testSuite getTestList] > 0 && [urls count] > 0)
        [(WebConnectivity*)[[testSuite getTestList] objectAtIndex:0] setInputs:urls];
    [[RunningTest currentTest] setAndRun:[NSMutableArray arrayWithObject:testSuite] inView: self];
    [self reloadFooter];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[TestUtility getBackgroundColorForTest:result.test_group_name]];
    }
}

-(NSString*)getExplorerUrl{
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://explorer.ooni.io/measurement/%@", self.measurement.report_id];
    if ([self.measurement.test_name isEqualToString:@"web_connectivity"])
        [url appendFormat:@"?input=%@", self.measurement.url_id.url];
    return url;
}

-(IBAction)shareExplorerUrl{
    NSURL *url = [NSURL URLWithString:[self getExplorerUrl]];
    NSArray* dataToShare = @[url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] )
    {
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewController animated:YES completion:^{}];
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
        NSString *testSuiteName = self.measurement.result_id.test_group_name;
        AbstractSuite *testSuite = [[AbstractSuite alloc] initSuite:testSuiteName];
        AbstractTest *test = [[AbstractTest alloc] initTest:self.measurement.test_name];
        test.is_rerun = true;
        [testSuite setTestList:[NSMutableArray arrayWithObject:test]];
        [testSuite setResult:self.measurement.result_id];
        if ([testSuiteName isEqualToString:@"websites"])
            [(WebConnectivity*)test setInputs:[NSArray arrayWithObject:self.measurement.url_id.url]];
        [self.measurement setReRun];
        [[RunningTest currentTest] setAndRun:[NSMutableArray arrayWithObject:testSuite] inView:self];
    }
    else if ([[segue identifier] isEqualToString:@"footer_upload"]){
        UploadFooterViewController *vc = (UploadFooterViewController * )segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:measurement];
        [vc setUpload_all:false];
    }
}


@end
