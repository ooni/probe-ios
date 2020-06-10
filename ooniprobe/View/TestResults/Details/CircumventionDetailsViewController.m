#import "CircumventionDetailsViewController.h"

@interface CircumventionDetailsViewController ()

@end

@implementation CircumventionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestKeys *testKeys = [self.measurement testKeysObj];
    [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];

    if (!super.measurement.is_anomaly){
        [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
    }
    else {
        [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
    }
    
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
        [self.detail2TitleLabel setText:@" "];
        [self.detail2SubtitleLabel setText:@" "];
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!super.measurement.is_anomaly){
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
    }
    else {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
    }
}

@end
