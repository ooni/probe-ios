#import "Header2ViewController.h"

@interface Header2ViewController ()

@end

@implementation Header2ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];
    [self.labelNetworkType setText:NSLocalizedString(result.networkType, nil)];
    [self.labelNetwork setText:NSLocalizedString(@"network", nil)];
    
    //TODO what to write when one param is null? (user disabled sharing asn or country)
    NSString *asn = @"";
    NSString *asnName = @"";
    NSString *country = @"";
    if (result.asn) asn = result.asn;
    if (result.asnName) asnName = result.asnName;
    if (result.country) country = result.country;
    
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
    
    [self.labelDataUsage setText:NSLocalizedString(@"data_usage", nil)];

    [self.labelDataUsageUpload setText:[result getFormattedDataUsageUp]];
    [self.labelDataUsageDownload setText:[result getFormattedDataUsageDown]];

    [self.labelRuntime setText:NSLocalizedString(@"runtime", nil)];
    [self.labelRuntimeDetail setText:@"2 min"];
}


@end
