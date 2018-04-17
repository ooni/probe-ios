#import "Header2ViewController.h"

@interface Header2ViewController ()

@end

@implementation Header2ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];
    
    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.name]];
    [self.labelNetwork setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.labelCountry setText:NSLocalizedString(@"TestResults.Summary.Hero.Country", nil)];
    [self.labelDataUsage setText:NSLocalizedString(@"TestResults.Summary.Hero.DataUsage", nil)];
    [self.labelRuntime setText:NSLocalizedString(@"TestResults.Summary.Hero.Runtime", nil)];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurement];
}

-(void)reloadMeasurement{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *asn;
        if ([result getAsnName] != NULL)
            asn = [result getAsnName];
        else
            asn = [result getAsn];

        //TODO reused function in another class
        NSMutableAttributedString *asnText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", asn]];
        [asnText addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:15]
                        range:NSMakeRange(0, asnText.length)];
        NSMutableAttributedString *networkText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [result getLocalizedNetworkType]]];
        [networkText addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-Regular" size:15]
                        range:NSMakeRange(0, networkText.length)];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
        [attrStr appendAttributedString:asnText];
        [attrStr appendAttributedString:networkText];
        [self.labelNetworkDetail setAttributedText:attrStr];

        NSString *country = [result getCountry];
        [self.labelCountryDetail setText:country];

        [self.labelDataUsageUpload setText:[result getFormattedDataUsageUp]];
        [self.labelDataUsageDownload setText:[result getFormattedDataUsageDown]];
        
        [self.labelRuntimeDetail setText:[NSString stringWithFormat:@"%.02f sec", result.duration]];
    });
}
@end
