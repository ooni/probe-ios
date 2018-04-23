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
    self.title = [LocalizationUtility getNameForTest:measurement.name];

    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:measurement.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.name]];
    [self.networkLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.countryLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Country", nil)];
    [self.runtimeLabel setText:NSLocalizedString(@"TestResults.Details.Hero.Runtime", nil)];
    [self.dateLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];
    [self.dateDetailLabel setText:localizedDateTime];

    self.rawDataButton.layer.cornerRadius = self.rawDataButton.bounds.size.height/2;
    self.rawDataButton.layer.masksToBounds = YES;
    [self.rawDataButton setTitle:NSLocalizedString(@"Raw Data", nil) forState:UIControlStateNormal];
    [self.viewLogButton setTitle:NSLocalizedString(@"TestResults.Details.ViewLog", nil) forState:UIControlStateNormal];

    //TODO how to behave when not resolved bold not bold
    NSString *asn;
    if ([result getAsnName] != NULL)
        asn = [result getAsnName];
    else
        asn = [result getAsn];
    
    //TODO if we can resolve the name properly we should drop the ASN
    NSMutableAttributedString *asnText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", asn]];
    [asnText addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-SemiBold" size:15]
                    range:NSMakeRange(0, asnText.length)];
    NSMutableAttributedString *asnName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@", [result getAsn]]];
    [asnName addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-Regular" size:15]
                        range:NSMakeRange(0, asnName.length)];
    NSMutableAttributedString *networkText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [result getLocalizedNetworkType]]];
    [networkText addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-Regular" size:15]
                        range:NSMakeRange(0, networkText.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:asnText];
    [attrStr appendAttributedString:asnName];
    [attrStr appendAttributedString:networkText];
    [self.networkDetailLabel setAttributedText:attrStr];
    
    NSString *country = [result getCountry];
    [self.countryDetailLabel setText:country];

    [self.runtimeDetailLabel setText:[NSString stringWithFormat:@"%.02f sec", measurement.duration]];
}

- (IBAction)viewLogs{
    segueType = @"log";
    [self performSegueWithIdentifier:@"log" sender:self];
}

- (IBAction)rawData{
    segueType = @"json";
    [self performSegueWithIdentifier:@"log" sender:self];
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
