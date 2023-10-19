#import "CircumventionDetailsViewController.h"
#import "RunningTest.h"

@interface CircumventionDetailsViewController ()

@end

@implementation CircumventionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestKeys *testKeys = [self.measurement testKeysObj];
    [self.textLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [linkAttributes setObject:[UIColor colorNamed:@"color_base"] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.textLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:linkAttributes];
    [self reloadConstraints];

    if (!super.measurement.is_anomaly){
        [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_green7"]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
    }
    else {
        [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
    }
    [self.detail2TitleLabel setText:@""];
    [self.detail2SubtitleLabel setText:@""];
    [self.detail3TitleLabel setText:@""];
    [self.detail3SubtitleLabel setText:@""];

    if ([self.measurement.test_name isEqualToString:@"psiphon"]){
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Psiphon.Reachable.Hero.Title", nil)];
            [self.textLabel setMarkdown:NSLocalizedString(@"TestResults.Details.Circumvention.Psiphon.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Psiphon.Blocked.Hero.Title", nil)];
            [self.textLabel setMarkdown:NSLocalizedString(@"TestResults.Details.Circumvention.Psiphon.Blocked.Content.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Psiphon.BootstrapTime.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[testKeys getBootstrapTime]];
    }
    else if ([self.measurement.test_name isEqualToString:@"tor"]){
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Tor.Reachable.Hero.Title", nil)];
            [self.textLabel setMarkdown:NSLocalizedString(@"TestResults.Details.Circumvention.Tor.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Tor.Blocked.Hero.Title", nil)];
            [self.textLabel setMarkdown:NSLocalizedString(@"TestResults.Details.Circumvention.Tor.Blocked.Content.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Tor.BrowserBridges.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.Tor.DirectoryAuthorities.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[testKeys getBridges]];
        [self.detail2SubtitleLabel setText:[testKeys getAuthorities]];
    }
    if ([self.measurement.test_name isEqualToString:@"riseupvpn"]){
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Reachable.Hero.Title", nil)];
            [self.textLabel setMarkdown:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Blocked.Hero.Title", nil)];
            [self.textLabel setMarkdown:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Blocked.Content.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Table.Header.Api", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Table.Header.Openvpn", nil)];
        [self.detail3TitleLabel setText:NSLocalizedString(@"TestResults.Details.Circumvention.RiseupVPN.Table.Header.Bridge", nil)];

        [self.detail1SubtitleLabel setText:[testKeys getRiseupVPNApiStatus]];
        [self.detail2SubtitleLabel setText:[testKeys getRiseupVPNOpenvpnGatewayStatus]];
        [self.detail3SubtitleLabel setText:[testKeys getRiseupVPNBridgedGatewayStatus]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadConstraints];
    if (!super.measurement.is_anomaly){
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorNamed:@"color_green7"]];
    }
    else {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorNamed:@"color_yellow9"]];
    }
}

-(void)reloadConstraints{
    CGFloat uploadConstraint = 64;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.uploadBarFooterConstraint.constant = uploadConstraint;
    });
}
@end
