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

    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:measurement.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    //[self.headerView setBackgroundColor:[TestUtility getColorForTest:result.test_group_name]];
    [self.networkLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.countryLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Country", nil)];
    [self.runtimeLabel setText:NSLocalizedString(@"TestResults.Details.Hero.Runtime", nil)];
    [self.dateLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];
    [self.dateDetailLabel setText:localizedDateTime];

    //self.rawDataButton.layer.cornerRadius = self.rawDataButton.bounds.size.height/2;
    //self.rawDataButton.layer.masksToBounds = YES;
    //[self.rawDataButton setTitle:NSLocalizedString(@"TestResults.Details.RawData", nil) forState:UIControlStateNormal];
    //[self.viewLogButton setTitle:NSLocalizedString(@"TestResults.Details.ViewLog", nil) forState:UIControlStateNormal];

    NSString *network = [result getNetworkName];
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
