#import "TestDetailsFooterViewController.h"
#import "ThirdPartyServices.h"

@interface TestDetailsFooterViewController ()

@end

@implementation TestDetailsFooterViewController
@synthesize result, measurement;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataButton.layer.cornerRadius = self.dataButton.bounds.size.height/2;
    self.dataButton.layer.masksToBounds = YES;
    self.dataButton.layer.borderWidth = 0.5f;
    self.dataButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[self.dataButton setTitle:NSLocalizedString(@"TestResults.Details.Methodology", nil) forState:UIControlStateNormal];

    self.explorerButton.layer.cornerRadius = self.explorerButton.bounds.size.height/2;
    self.explorerButton.layer.masksToBounds = YES;
    self.explorerButton.layer.borderWidth = 0.5f;
    self.explorerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[self.explorerButton setTitle:NSLocalizedString(@"TestResults.Details.Methodology", nil) forState:UIControlStateNormal];

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
