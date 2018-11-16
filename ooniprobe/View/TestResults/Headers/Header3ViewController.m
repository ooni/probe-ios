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
    [self.networkDetailLabel setText:[NSString stringWithFormat:@"%@\n%@ (%@)", [result getNetworkName:YES], [result getAsn], [result getLocalizedNetworkType]]];
    NSString *country = [result getCountry];
    [self.countryDetailLabel setText:country];
}
@end
