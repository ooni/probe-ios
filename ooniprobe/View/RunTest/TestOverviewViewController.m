#import "TestOverviewViewController.h"

@interface TestOverviewViewController ()

@end

@implementation TestOverviewViewController
@synthesize testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLastMeasurement) name:@"networkTestEnded" object:nil];

    [self.testNameLabel setText:[LocalizationUtility getNameForTest:testName]];
    NSString *testLongDesc = [LocalizationUtility getLongDescriptionForTest:testName];
    [self.testDescriptionLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
    [self.testDescriptionLabel setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    [self.testDescriptionLabel setMarkdown:testLongDesc];
    [self.testDescriptionLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];
    
    [self.runButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Dashboard.Overview.Run", nil)] forState:UIControlStateNormal];
    if ([testName isEqualToString:@"websites"])
        [self.websitesButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Dashboard.Overview.ChooseWebsites", nil)] forState:UIControlStateNormal];
    else
        [self.websitesButton setHidden:YES];

    [self reloadLastMeasurement];
    [self.testImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testName]]];
    [self.testImage setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    defaultColor = [TestUtility getColorForTest:testName];
    [self.runButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.backgroundView setBackgroundColor:defaultColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:defaultColor];
}

-(void)reloadLastMeasurement{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *estimatedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"Dashboard.Overview.Estimated", nil)]];
        [estimatedString addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:14]
                                range:NSMakeRange(0, estimatedString.length)];
        
        NSString *time = NSLocalizedFormatString(@"Dashboard.Card.Seconds", [NSString stringWithFormat:@"%d", [TestUtility getTotalTimeForTest:testName]]);
        NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", time]];
        [timeString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"FiraSans-SemiBold" size:14]
                           range:NSMakeRange(0, timeString.length)];
        
        NSMutableAttributedString *lastTestString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"Dashboard.Overview.LatestTest", nil)]];
        [lastTestString addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:14]
                                range:NSMakeRange(0, lastTestString.length)];
        
        NSString *ago;
        SRKResultSet *results = [[[[[Result query] limit:1] where:[NSString stringWithFormat:@"test_group_name = '%@'", testName]] orderByDescending:@"start_time"] fetch];
        if ([results count] > 0){
            ago = [[[results objectAtIndex:0] start_time] timeAgoSinceNow];
        }
        else
            ago = NSLocalizedString(@"Dashboard.Overview.LastRun.Never", nil);

        NSMutableAttributedString *agoString = [[NSMutableAttributedString alloc] initWithString:ago];
        [agoString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"FiraSans-SemiBold" size:14]
                           range:NSMakeRange(0, agoString.length)];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
        [attrStr appendAttributedString:estimatedString];
        [attrStr appendAttributedString:timeString];
        [attrStr appendAttributedString:lastTestString];
        [attrStr appendAttributedString:agoString];
        [self.testDetailLabel setAttributedText:attrStr];
    });
}

-(NSInteger)daysBetweenTwoDates:(NSDate*)testDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:testDate
                                                          toDate:[NSDate date]
                                                         options:0];
    return components.day;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    }
}

-(IBAction)run:(id)sender{
    if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
        [self performSegueWithIdentifier:@"toTestRun" sender:sender];
    else
        [MessageUtility alertWithTitle:@"Modal.Error" message:@"Modal.Error.NoInternet" inView:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        [vc setTestSuiteName:testName];
    }
    else if ([[segue identifier] isEqualToString:@"toTestSettings"]){
        SettingsTableViewController *vc = (SettingsTableViewController * )segue.destinationViewController;
        [vc setTestName:testName];
    }

}


@end
