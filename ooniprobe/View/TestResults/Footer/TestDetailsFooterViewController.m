#import "TestDetailsFooterViewController.h"
#import "ThirdPartyServices.h"

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
    
    [self.dateLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.dateDetailLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.networkLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.networkNameLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.networkAsnLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.countryLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.countryDetailLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.runtimeLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.runtimeDetailLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
}

-(IBAction)openMethodology:(id)sender{
    NSString *url = [LocalizationUtility getUrlForTest:measurement.test_name];
    if (url != nil)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
