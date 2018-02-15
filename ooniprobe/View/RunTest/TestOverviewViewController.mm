#import "TestOverviewViewController.h"

@interface TestOverviewViewController ()

@end

@implementation TestOverviewViewController
@synthesize testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(self.testName, nil);
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    
    [self.testNameLabel setText:NSLocalizedString(self.testName, nil)];
    
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"description", nil)];
    [description addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, description.length)];
    
    NSString *testDesc = [NSString stringWithFormat:@"%@_longdesc", testName];
    NSMutableAttributedString *testDescStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@", NSLocalizedString(testDesc, nil)]];
    [testDescStr addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                                range:NSMakeRange(0, testDesc.length)];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:description];
    [attrStr appendAttributedString:testDescStr];
    [self.testDescriptionLabel setAttributedText:attrStr];

    //TODO
    [self.timeLabel setText:@"2min 10MB"];
    [self.lastRunLabel setText:@"2 days ago"];
    
    [self.testImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white", testName]]];
    defaultColor = [SettingsUtility getColorForTest:testName];
    [self.backgroundView setBackgroundColor:defaultColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:defaultColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIColor *defaultColor = [UIColor colorWithRGBHexString:color_blue5 alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:defaultColor];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        [vc setTestName:testName];
    }
}

@end
