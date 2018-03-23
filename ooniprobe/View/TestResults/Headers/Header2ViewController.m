#import "Header2ViewController.h"

@interface Header2ViewController ()

@end

@implementation Header2ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];
    
    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];
    [self.labelNetwork setText:NSLocalizedString(@"network", nil)];
    [self.labelDataUsage setText:NSLocalizedString(@"data_usage", nil)];
    [self.labelRuntime setText:NSLocalizedString(@"runtime", nil)];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurement];
}

-(void)reloadMeasurement{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.labelNetworkType setText:NSLocalizedString(result.networkType, nil)];
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
        
        [self.labelRuntimeDetail setText:[NSString stringWithFormat:@"%.02f sec", result.duration]];
    });
}
@end
