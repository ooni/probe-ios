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
    //self.tableView.tableFooterView = [UIView new];
    
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:measurement.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.title = localizedDateTime;

    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.name]];
    [self.labelNetwork setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.labelDataUsage setText:NSLocalizedString(@"TestResults.Summary.Hero.DataUsage", nil)];
    [self.labelRuntime setText:NSLocalizedString(@"TestResults.Summary.Hero.Runtime", nil)];
    [self.labelDate setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];

    [self.labelNetworkType setText:[result getLocalizedNetworkType]];
    NSString *asn = [result getAsn];
    NSString *asnName = [result getAsnName];
    NSString *country = [result getCountry];
    
    NSMutableAttributedString *asnText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ - ", asnName, asn]];
    [asnText addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-Regular" size:15]
                    range:NSMakeRange(0, asnText.length)];
    NSMutableAttributedString *countryName = [[NSMutableAttributedString alloc] initWithString:country];
    [countryName addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:15]
                        range:NSMakeRange(0, countryName.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:asnText];
    [attrStr appendAttributedString:countryName];
    [self.labelNetworkDetail setAttributedText:attrStr];
    [self.labelDataUsageUpload setText:[result getFormattedDataUsageUp]];
    [self.labelDataUsageDownload setText:[result getFormattedDataUsageDown]];
    
    [self.labelRuntimeDetail setText:[NSString stringWithFormat:@"%.02f sec", measurement.duration]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
