#import "TestDetailsViewController.h"

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
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(advancedScreens)];
    //assign button to navigationbar
    self.navigationItem.rightBarButtonItem = moreButton;

    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:measurement.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    [self.networkLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.networkLabel setText:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)]];
    [self.runtimeLabel setText:NSLocalizedString(@"TestResults.Details.Hero.Runtime", nil)];
    [self.dateLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];
    [self.dateDetailLabel setText:localizedDateTime];

    //TODO remove
    //NSString *network = [result getNetworkName];
    /*
    NSMutableAttributedString *networkText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", network]];
    [networkText addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-SemiBold" size:15]
                    range:NSMakeRange(0, networkText.length)];
    NSMutableAttributedString *networkTypeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [result getLocalizedNetworkType]]];
    [networkTypeText addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-Regular" size:15]
                        range:NSMakeRange(0, networkTypeText.length)];
    NSMutableAttributedString *asnName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@", [result getAsn]]];
    [asnName addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-SemiBold" size:15]
                    range:NSMakeRange(0, asnName.length)];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:networkText];
    [attrStr appendAttributedString:networkTypeText];
    [attrStr appendAttributedString:asnName];
    [self.networkDetailLabel setAttributedText:attrStr];
    */
    [self.networkDetailLabel setText:[NSString stringWithFormat:@"%@\n%@ (%@)", [result getNetworkName], [result getAsn], [result getLocalizedNetworkType]]];

    NSString *country = [result getCountry];
    [self.countryDetailLabel setText:country];

    [self.runtimeDetailLabel setText:[NSString stringWithFormat:@"%.02f sec", measurement.runtime]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toViewLog"]){
        LogViewController *vc = (LogViewController *)segue.destinationViewController;
        [vc setType:segueType];
        [vc setMeasurement:measurement];
    }
}


@end
