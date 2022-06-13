#import "TestDetailsFooterViewController.h"
#import "ThirdPartyServices.h"
#import "LogViewController.h"

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
    [self.dataButton setTitle:NSLocalizedString(@"TestResults.Details.RawData", nil) forState:UIControlStateNormal];

    self.explorerButton.layer.cornerRadius = self.explorerButton.bounds.size.height/2;
    self.explorerButton.layer.masksToBounds = YES;
    self.explorerButton.layer.borderWidth = 0.5f;
    self.explorerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.explorerButton setTitle:NSLocalizedString(@"TestResults.Details.ShowInExplorer", nil) forState:UIControlStateNormal];

    [self.logButton setTitle:NSLocalizedString(@"TestResults.Details.ViewLog", nil) forState:UIControlStateNormal];

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
    [self.methodologyLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];

    NSString *url = [LocalizationUtility getUrlForTest:self.measurement.test_name];
    [self.methodologyLabel setMarkdown:NSLocalizedFormatString(@"TestResults.Details.Methodology.Paragraph", url)];
    [self.methodologyLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }];
    if ([self.measurement hasLogFile])
        [self.logButton setHidden:NO];
    if (self.measurement.report_id != NULL && ![self.measurement.report_id isEqualToString:@""]){
        [self.explorerButton setHidden:NO];
    }
}

-(IBAction)openExplorerUrl:(id)sender{
    NSString *url = [self getExplorerUrl];
    if (url != nil)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(NSString*)getExplorerUrl{
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://explorer.ooni.io/measurement/%@", self.measurement.report_id];
    if ([self.measurement.test_name isEqualToString:@"web_connectivity"])
        [url appendFormat:@"?input=%@", self.measurement.url_id.url];
    return url;
}

- (IBAction)viewLogs{
    segueType = @"log";
    [self performSegueWithIdentifier:@"toViewLog" sender:self];
}

- (IBAction)rawData{
    segueType = @"json";
    [self performSegueWithIdentifier:@"toViewLog" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toViewLog"]){
        LogViewController *vc = (LogViewController *)segue.destinationViewController;
        [vc setType:segueType];
        [vc setMeasurement:measurement];
    }
}

@end
