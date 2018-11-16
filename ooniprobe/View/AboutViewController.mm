#import "AboutViewController.h"
#import <measurement_kit/common.hpp>
#import "VersionUtility.h"

@interface AboutViewController ()
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings.About.Label", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    [self.learnMoreButton setTitle:NSLocalizedString(@"Settings.About.Content.LearnMore", nil) forState:UIControlStateNormal];
    self.learnMoreButton.layer.cornerRadius = 20;
    self.learnMoreButton.layer.masksToBounds = YES;
    [self.learnMoreButton setTitleColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]
                        forState:UIControlStateNormal];
    [self.learnMoreButton setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    
    [self.textLabel setText:NSLocalizedString(@"Settings.About.Content.Paragraph", nil)];
    [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    
    [self.ppButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Settings.About.Content.DataPolicy", nil)] forState:UIControlStateNormal];
    [self.ppButton setTitleColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]
                        forState:UIControlStateNormal];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"OONI Probe: %@\nmeasurement-kit: %s", [VersionUtility get_software_version], mk_version()]];
    [self.versionLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
}


-(IBAction)learnMore:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.io/"]];
}


-(IBAction)privacyPolicy:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.io/about/data-policy/"]];
}


@end
