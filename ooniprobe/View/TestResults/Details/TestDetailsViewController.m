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
    [self.labelDateDetail setText:localizedDateTime];
    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.name]];
    [self.labelNetwork setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.labelCountry setText:NSLocalizedString(@"TestResults.Summary.Hero.Country", nil)];
    [self.labelRuntime setText:NSLocalizedString(@"TestResults.Details.Hero.Runtime", nil)];
    [self.labelDate setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];

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
    [self.labelNetworkDetail setAttributedText:attrStr];
    
    NSString *country = [result getCountry];
    [self.labelCountryDetail setText:country];

    [self.labelRuntimeDetail setText:[NSString stringWithFormat:@"%.02f sec", measurement.duration]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
