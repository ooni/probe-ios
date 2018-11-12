#import "Header3ViewController.h"

@interface Header3ViewController ()

@end

@implementation Header3ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];
    
    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.test_group_name]];
    [self.countryLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Country", nil)];
    [self.networkLabel setText:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)]];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadMeasurement];
    });
}

-(void)reloadMeasurement{
    //TODO remove
    //NSString *network = [result getNetworkNameOrAsn];
    /*
    NSMutableAttributedString *networkText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", network]];
    [networkText addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:15]
                        range:NSMakeRange(0, networkText.length)];
    NSMutableAttributedString *networkTypeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [result getLocalizedNetworkType]]];
    [networkTypeText addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"FiraSans-Regular" size:15]
                            range:NSMakeRange(0, networkTypeText.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:networkText];
    [attrStr appendAttributedString:networkTypeText];
    [self.networkDetailLabel setAttributedText:attrStr];
    */
    [self.networkDetailLabel setText:[NSString stringWithFormat:@"%@\n%@ (%@)", [result getNetworkName], [result getAsn], [result getLocalizedNetworkType]]];
    NSString *country = [result getCountry];
    [self.countryDetailLabel setText:country];
}
@end
