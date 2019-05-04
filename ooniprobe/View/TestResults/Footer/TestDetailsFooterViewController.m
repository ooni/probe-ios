#import "TestDetailsFooterViewController.h"

@interface TestDetailsFooterViewController ()

@end

@implementation TestDetailsFooterViewController
@synthesize result, measurement;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.methodologyButton.layer.cornerRadius = self.methodologyButton.bounds.size.height/2;
    self.methodologyButton.layer.masksToBounds = YES;
    self.methodologyButton.layer.borderWidth = 0.5f;
    self.methodologyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.methodologyButton setTitle:NSLocalizedString(@"TestResults.Details.Methodology", nil) forState:UIControlStateNormal];

    [self.networkLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Network", nil)];
    [self.runtimeLabel setText:NSLocalizedString(@"TestResults.Details.Hero.Runtime", nil)];
    [self.dateLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];
    [self.dateDetailLabel setText:[measurement getLocalizedStartTime]];
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

-(IBAction)openMethodology:(id)sender{
    NSString *url = [LocalizationUtility getUrlForTest:measurement.test_name];
    if (url != nil)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
