#import "TestDetailsFooterViewController.h"

@interface TestDetailsFooterViewController ()

@end

@implementation TestDetailsFooterViewController
@synthesize result, measurement;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:measurement.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    [self.networkLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.networkLabel setText:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)]];
    [self.runtimeLabel setText:NSLocalizedString(@"TestResults.Details.Hero.Runtime", nil)];
    [self.dateLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];
    [self.dateDetailLabel setText:localizedDateTime];
    [self.networkNameLabel setText:[result getNetworkName]];
    [self.networkAsnLabel setText:[NSString stringWithFormat:@"%@ (%@)", [result getAsn], [result getLocalizedNetworkType]]];
    NSString *country = [result getCountry];
    [self.countryDetailLabel setText:country];
    
    [self.runtimeDetailLabel setText:[NSString stringWithFormat:@"%.02f sec", measurement.runtime]];
    
    [self.dateLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.dateDetailLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.networkLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.networkNameLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.networkAsnLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.countryLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.countryDetailLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.runtimeLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.runtimeDetailLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
}

@end
